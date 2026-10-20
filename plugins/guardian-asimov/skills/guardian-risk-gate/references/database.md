# Database — risk on persistent data

## Pre-check

- Is the operation **read-only** (`SELECT`) or does it **modify** data
  (`INSERT`/`UPDATE`/`DELETE`/DDL)?
- Does it run against a **development/staging** database or **production**?
- Does the `UPDATE`/`DELETE` have a narrow, verified `WHERE`, or can it
  affect more rows than expected?
- Is there a **recent backup** before a destructive operation?
- Is the migration **reversible** (has a `down`) or irreversible (drops
  columns/tables that hold data)?
- Is a **transaction** available so it can be rolled back if something
  goes wrong?

## Quick classification

- 🟢 `SELECT`, `EXPLAIN`, read-only queries, reversible additive
  migrations in a local development environment.
- 🟡 Narrow `UPDATE`/`DELETE` with a verified `WHERE` in development;
  additive migrations in staging/production with a `down` available.
- 🔴 `UPDATE`/`DELETE` in production; migrations that change types or
  rename columns with existing data; operations without a transaction
  on data that matters.
- ⚫ `DROP DATABASE`, `DROP TABLE`, `TRUNCATE`, `DELETE` without `WHERE`
  (or with a `WHERE` that covers everything), destructive migrations in
  production, any irreversible operation without a confirmed backup.

## Specific rules

1. **Never run destructive DDL/DML directly on production** without a
   confirmed backup and explicit user confirmation, with no profile
   exception.
2. **Prefer simulating before executing**: run the `SELECT` equivalent
   of an `UPDATE`/`DELETE`'s `WHERE` first, to show how many rows will
   be affected, before running the destructive version.
3. **Prefer transactions** when the engine supports them, so you can
   `ROLLBACK` if the result is not what was expected.
4. **Migrations**: always prefer an additive change (add a nullable
   column) over a destructive one (drop/rename) when the end goal can
   be reached in two safe steps.
5. **Never assume "dev" means "unimportant"** — if the user did not
   specify the environment, ask before running anything destructive.

## Example intervention

> User: "Delete the inactive users from the `users` table."
> Framework: ⚫ Critical — a `DELETE` on `users` is irreversible if
> there is no backup. Before deleting: (1) do you have a recent backup
> of this database? (2) I'll first show you how many rows match
> "inactive" with a `SELECT COUNT(*)` before deleting anything. Shall
> we go that way?
