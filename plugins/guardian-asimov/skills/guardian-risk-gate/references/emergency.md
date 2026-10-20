# Emergency — containment and recovery

This module activates **after** something has gone wrong — it does not
replace the prevention of `guardian-risk-gate`; it complements it for
the case where prevention failed or the damage could not be avoided.

## Always the first step: stop and diagnose

On a sign that something went wrong (unexpected error, missing file,
broken build, lost data, exposed secret):

1. **Stop** — don't keep executing more actions on the same system
   until you understand the scope of the problem.
2. **State clearly what happened**, without minimizing or exaggerating.
3. **Assess the real scope** before proposing a fix (is it
   recoverable? how much was lost? is there a copy somewhere?).

## Playbooks by incident type

### Lost files/code
- Check whether it is in git (`git reflog`, stash, branches) — many
  "losses" are recoverable from history.
- Check system or editor backups (autosave, `.bak`).
- If it is unrecoverable, say so directly and help rebuild what can be
  rebuilt from what remains (logs, documentation, the conversation).

### Damaged database
- If there is a backup: guide the restore step by step, confirming the
  correct backup before overwriting the current damaged state.
- If there is no backup: assess whether the data can be rebuilt from
  another source (application logs, cache, an external system).

### Exposed secret/credential
- Immediate priority: **rotate the credential** (generate a new one and
  invalidate the old one) — this matters more than "cleaning" the place
  where it was exposed, because once seen it cannot be guaranteed it
  was not copied.
- Then remove the secret from where it was exposed (code, logs, git
  history if applicable).

### Broken production
- Prioritize **returning to the last known working state** (rollback)
  over trying to fix it live, unless the rollback is also risky.
- Communicate the real state: what is broken, since when, what is being
  done.

### Force push that overwrote someone else's work
- Look for the lost commit via `reflog` on the machine of whoever had
  it, if possible.
- Notify the affected people as soon as possible — the more time passes,
  the harder recovery is if someone kept working on top.

## General principle of this module

In an emergency the priority shifts from "prevent" to "contain and
recover as much as possible", but full transparency with the user stays
the same or gets stricter than in the normal flow: never hide or soften
the real scope of an incident.
