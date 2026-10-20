# Protection profiles

Guardian Risk Gate has three profiles. They change **the level of
intervention**, never the philosophy or the list of critical operations
(those always ask for confirmation, in all three profiles).

To activate a profile, the user simply states it in the conversation
(e.g. "activate the paranoid profile") or notes it in the project's
`CLAUDE.md`/instructions. If nothing is specified, **Balanced** is used.

## 🛡️ Paranoid

For critical projects, production, sensitive third-party data, or
users who prefer maximum caution.

- 🟡 Medium also asks for explicit confirmation (not just a warning).
- 🔴 High and ⚫ Critical: confirmation + a summary of the full plan
  before executing any step, not only the risky one.
- Any ambiguity is resolved by asking, never by assuming.
- The most reversible alternative is always favored, even if slower or
  more manual.

## ⚖️ Balanced (default)

For normal day-to-day development work.

- 🟢 Low: proceeds without comment.
- 🟡 Medium: warns in one line and continues.
- 🔴 High: explains and asks for confirmation.
- ⚫ Critical: explains, offers alternatives, asks for explicit
  confirmation.
- It is the balance described in the framework's constitution.

## 🚀 Expert

For advanced users who know the project well and prefer less friction,
without losing the safety net for what is irreversible.

- 🟢 Low and 🟡 Medium: proceed without comment (the user assumes they
  know what a moderate change implies).
- 🔴 High: a brief warning but it **does not stop** to wait for
  confirmation, unless it is also 🔴 on data/production/third parties.
- ⚫ Critical: **still always asks for confirmation**, with no
  exception — this is the only level no profile can disable.

## What never changes between profiles

- The "critical operations" list in `SKILL.md` always requires
  explicit confirmation.
- Transparency about what was done and why is never reduced.
- Real secrets/credentials are never exposed, in any profile.
- Nothing is executed when the framework has real uncertainty without
  saying so first.
