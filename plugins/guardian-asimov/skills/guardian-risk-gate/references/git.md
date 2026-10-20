# Git — risk to the project history

## Pre-check

- Does the command **rewrite history** (`rebase`, `commit --amend` on
  something already pushed, `filter-branch`) or **discard changes**
  (`reset --hard`, `checkout -- .`, `clean -fd`)?
- Are there **uncommitted changes** that would be lost?
- Is the branch **local** or already **pushed/shared** with others?
- Can a `push --force` overwrite someone else's commits?
- Is it about to delete a **branch** that is not merged?

## Quick classification

- 🟢 `status`, `log`, `diff`, `add`, a normal `commit`, `push` without
  force, creating new branches, `pull` without conflicts.
- 🟡 `reset --soft`/`--mixed` (does not lose the working tree),
  `checkout` to another branch with changes already committed, `merge`.
- 🔴 `reset --hard` with uncommitted changes, `clean -fd`, `rebase` of
  an already-pushed branch, deleting an unmerged local branch.
- ⚫ `push --force` to a shared branch (main/develop/production),
  `filter-branch`/rewriting already-published history, deleting a
  remote branch, any operation that could destroy a teammate's work.

## Specific rules

1. **`--hard` and `-f`/`--force` are automatic red flags.** Any command
   that includes them rises to 🔴 at minimum.
2. **Before discarding changes**, say what will be lost (`git status`/
   `git diff` first) — never assume "it doesn't matter".
3. **`push --force` to a shared branch = always ⚫.** If it is the
   user's own branch and nobody else uses it, it can drop to 🔴 with a
   warning, but it is never executed without explicitly saying which
   commits others will lose.
4. **Prefer non-destructive alternatives**: `git stash` instead of
   `checkout -- .`; `push --force-with-lease` instead of a bare
   `--force` (it fails if someone else pushed, instead of silently
   overwriting).
5. **Deleting remote branches**: explicitly confirm the branch name
   before deleting, and verify it is merged or that the user knows it
   is not.

## Example intervention

> User: "Hard reset to the last commit and force push."
> Framework: ⚫ Critical — `reset --hard` permanently discards any
> uncommitted changes you have right now, and `push --force` can
> overwrite other people's commits if the branch is shared. Safer
> alternative: `push --force-with-lease`, which aborts if someone else
> pushed something. Do you confirm there are no local changes you want
> to keep and that the branch is yours alone?
