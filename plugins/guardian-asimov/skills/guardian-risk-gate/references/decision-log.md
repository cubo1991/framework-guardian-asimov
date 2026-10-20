# Decision Log — history of interventions

This module complements `guardian-risk-gate`: while that engine decides
*in the moment* what to do with a risky action, this module makes sure
that decision is **recorded** so it can be reviewed later — by the user,
by a teammate, or by you in a future session.

It does not replace the intervention in the chat (the warning/
confirmation still happens inline, as always) — the log is an
additional, silent record in parallel that adds no friction to the
conversation.

## When to write an entry

Automatically, whenever `guardian-risk-gate` classifies an action as
🟡 Medium, 🔴 High or ⚫ Critical **and the user has already responded**
(confirmed, declined, or chose an alternative). Not recorded:

- 🟢 Low risk (no real intervention to record).
- The moment of the warning itself — wait for the resolution, so the
  entry is complete with what finally happened.

## Where the file lives

`decision-log.md` at the root of the project being worked on (not
inside the plugin folder). If it does not exist, it is created the
first time an entry needs to be written, with the minimal header:

```markdown
# Decision Log — Guardian Risk Gate

Record of Medium, High or Critical risk interventions.
```

If the project uses version control, this file can be versioned (it
gives the team useful historical context) or excluded via `.gitignore`
if the user prefers to keep it local — don't assume; if in doubt, ask
once and don't interrupt again about it.

## Format of each entry

```markdown
## [YYYY-MM-DD HH:MM] Level — short summary of the action

- **Module(s)**: git, filesystem, ...
- **What was asked**: brief description of the requested action
- **Risk detected**: one line with the reason for the classification
- **Alternative offered**: if there was one (or "none" if not applicable)
- **Resolution**: confirmed / declined / alternative used / more
  information requested
```

Real example:

```markdown
## [2026-08-07 15:12] 🔴 High — change of authentication provider

- **Module(s)**: security
- **What was asked**: change the login endpoint to use a new provider
- **Risk detected**: affects login for all current users
- **Alternative offered**: try with a test user first
- **Resolution**: confirmed, applied to everyone directly
```

Keep each entry short — 4–5 lines. The log is for quick scanning, not
for reconstructing the whole conversation.

## When to read and summarize the log

When the user asks things like "show me the log", "what got stopped
lately", "audit this session/week/project":

1. Read `decision-log.md`.
2. If it doesn't exist yet, say so directly ("there are no entries
   recorded in this project yet") instead of inventing content.
3. If it exists, summarize — don't paste the whole file unless the
   user asks to see it all. Prioritize: how many entries there are, how
   many were Critical vs High vs Medium, and whether there is a pattern
   (e.g. "most interventions were for git operations on main").
4. If the user asks to filter by date, module or level, do it on the
   content already read.

## What this module does NOT do

- It is not an external security-audit or regulatory-compliance system
  — it is a simple log for the user's/team's own use.
- It does not record the full contents of files, commands, or sensitive
  data — only the summary of the decision. If the action itself
  involved a secret or sensitive data, the log must not contain that
  value, only the mention that the risk existed (see
  `references/security.md` and `references/privacy.md`).
- It does not replace `references/emergency.md` — if something has
  already gone wrong, that is the module that guides containment; the
  log only records that it happened, once resolved.
