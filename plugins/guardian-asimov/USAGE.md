# Usage

You generally don't "invoke" the framework manually — the agent
consults it on its own when the task matches the skill's description.
You can still ask for it explicitly:

- *"Run a Guardian Risk Gate analysis before doing this."*
- *"What risk does this operation carry according to the framework?"*

## Typical flow

1. The user asks for an action with real effects (edit, delete, run,
   push, etc.).
2. The agent recognizes that `guardian-risk-gate` applies (and opens the
   matching reference: `git`, `filesystem`, `database`, etc.).
3. It assesses the eight risk dimensions and classifies: 🟢🟡🔴⚫.
4. Depending on the level (and the active profile, see
   `references/profiles.md`): it proceeds, warns, or asks for
   confirmation with alternatives.
5. It executes (or not) according to the user's answer.

## Examples of real decisions

### 🟢 Low — proceeds without friction
> User: "Add a logout button to the navbar."
> Result: the agent edits the component and that's it, with no warning —
> it is a versioned, limited, fully reversible code change.

### 🟡 Medium — warns and continues
> User: "Update the React version in `package.json`."
> Result: "Done, I updated from 18.2 to 18.3 — a minor change per
> semver, it shouldn't break anything, but run the tests to confirm."
> It continues without waiting for confirmation.

### 🔴 High — asks for confirmation
> User: "Change the authentication endpoint to use the new provider."
> Result: "This affects login for all current users.
> What can happen: if the new provider isn't configured correctly,
> nobody can log in. How to revert: I'll leave the old code commented
> out and versioned in case we need to go back quickly. Alternative:
> try it first on a test user before applying it to everyone. Do you
> confirm I should go ahead?"

### ⚫ Critical — never executes directly
> User: "Run `DROP TABLE orders`, we don't need it anymore."
> Result: "I won't run this directly because it is irreversible and
> `orders` holds production data. First: (1) is there a recent backup
> of this table? (2) safer alternative: rename it to
> `orders_deprecated` instead of deleting it, so it stays recoverable
> for a while. Do you confirm permanent deletion, or shall we go with
> the rename?"

## Decision log

Every 🟡🔴⚫ intervention the user resolves is recorded automatically in
`decision-log.md` at the project root — no need to ask. To query it:

> User: "Show me what the framework stopped this week."
> Result: the agent reads `decision-log.md` and returns a summary — not
> the whole file — for example: "There were 3 interventions: 1 Critical
> (a `DROP TABLE` resolved with a rename instead of deletion), 2 High
> (auth provider change, confirmed; and a production migration,
> confirmed with a prior backup). None were declined."

If the file doesn't exist yet (no interventions to record in the
project), the agent says so directly instead of inventing content. See
`references/decision-log.md` for the exact format of each entry.

## Switching profiles

See `references/profiles.md`. You can ask at any time:
*"From now on use the expert profile for this project."*

## When the framework does NOT intervene

- Reading and explaining code.
- Generating text/drafts the user has not yet asked to save to a file.
- Conceptual questions with nothing executed.

The goal is for the framework to be invisible in 90% of normal work,
and very present in the 10% that really needs it.
