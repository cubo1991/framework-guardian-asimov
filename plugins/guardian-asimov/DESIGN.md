# DESIGN.md — design decisions

## Why one skill with `references/` instead of eleven skills (v1.4.0)

Until v1.3.1 every domain (`git`, `filesystem`, `database`, …) was its
own skill. That made the plugin hard to ship and discover as a single
product, and the model had to decide among eleven overlapping
descriptions. v1.4.0 folds everything into one skill, `guardian-risk-gate`:

- `SKILL.md` holds the decision process (under 200 lines) and is the
  only thing loaded when the skill triggers.
- `references/` holds the per-domain checklists, the profiles and the
  constitution. `SKILL.md` tells the agent which one to open, so only
  the relevant domain enters the context (progressive disclosure,
  references one level deep).
- `scripts/` and `evals/` are not loaded into context; they are tooling.

The skill folder is self-contained, so it can be zipped and used on its
own in any agent that supports Agent Skills. The Claude Code plugin is a
thin wrapper that adds `hooks/hooks.json`.

## Why the decision process is the core and the domains are references

The domain references (`git`, `filesystem`, etc.) provide **specific
checklists** — what to look at in that domain. But the logic of "how to
go from a checklist to a decision" (classify, choose an action, format
the warning) is the same for all domains. Writing it once in `SKILL.md`
avoids duplicating the same decision logic ten times and having the
copies drift apart.

## Why the constitution is a separate document

`references/constitution.md` is a background reference rather than an
action trigger — the agent reads it when it needs the rationale, not on
every task. `SKILL.md` does the heavy lifting at decision time.

## Why three profiles and not a continuous scale

A continuous scale (e.g. "paranoia level 1 to 10") sounds more flexible,
but in practice nobody remembers what "level 6" means, and it is hard to
document consistently. Three named profiles with clear semantics
(`Paranoid`/`Balanced`/`Expert`) are easier to reason about, communicate
and audit. If more granularity is needed in the future, it is easier to
start from these three than from an arbitrary scale (see `ROADMAP.md`).

## Why critical operations do not vary by profile

If `expert` could skip confirmation on irreversible operations (DROP
DATABASE, force push to main, rm -rf), the framework would stop doing
its main job for the one kind of damage that cannot be undone. What
`expert` gains is less friction for reversible medium/high risks, never
the safety net for what is irreversible.

## Why the `emergency` reference is separate from the decision process

The decision process is preventive: it runs before acting. `emergency`
is reactive: it runs when prevention failed (or the damage could not be
avoided for an external reason). Mixing them would have made the
prevention process longer and more confusing; separating them keeps each
focused on a different moment in an action's lifecycle.

## Why the hook is optional and described as a partial net

A skill is text the model interprets; in unattended mode it can be
ignored. The hook adds a technical brake for the patterns it recognizes,
but it is regex over command text, not a shell parser: it cannot see
indirection and it does not cover the whole critical list. The docs say
so explicitly, and `evals/hook-corpus.txt` records exactly what is and
is not detected, so the claim stays measurable.

## What was added beyond the original request

- **`emergency`**: the request covers prevention well, but a mature
  governance framework also needs a containment playbook for when
  prevention is not enough (bugs, human error, external failures). It is
  the natural counterpart of the decision process and keeps the agent
  from improvising without guidance during a real incident.
- **"No assumptions under uncertainty" as an explicit, cross-cutting
  rule**, not mentioned just once — it is repeated in the constitution
  and in `SKILL.md` because it is, in practice, the most common failure
  of a well-intentioned agent: filling information gaps with the most
  convenient scenario instead of asking.
