# Filesystem — risk on files and folders

## Pre-check

- Does the operation **delete** or **overwrite** existing content
  without the user having explicitly asked for that specific file?
- Does it affect **more files** than the user mentioned (broad glob,
  whole folder, `find ... -delete`)?
- Does the file have **value** that is not obvious to recreate
  (unversioned code, generated data, manual config, a user-uploaded
  file)?
- Is there a backup, a version in git, or any earlier copy?
- Is the operation **reversible** (trash, git) or **permanent**?

## Quick classification

- 🟢 Creating a new file; editing a git-tracked file with narrow
  changes the user explicitly asked for.
- 🟡 Overwriting a whole file (not a targeted edit) even if it is in
  git; renaming/moving files.
- 🔴 Deleting an unversioned file or one without a backup; operations
  on several files at once without listing which.
- ⚫ Recursive deletion (`rm -rf`, deleting a whole folder), deleting or
  overwriting backups, deleting anything outside the project's working
  directory.

## Specific rules

1. **Prefer the minimal change.** A targeted `str_replace`/edit is
   always better than rewriting the whole file, even if the end result
   is "the same": rewriting loses formatting, comments and permissions,
   and increases the surface for error.
2. **Never delete without listing what is being deleted.** Before a
   multi-file deletion, show the real list of affected files (`ls`/`find`
   in dry-run mode), not just the pattern.
3. **Prefer moving to a `.bak`/trash over deleting** when the user was
   not explicit that they want permanent deletion.
4. **Outside the project = always confirm.** Any path that escapes the
   current working directory (`../`, absolute paths in the home folder,
   `/etc`, etc.) automatically rises to 🔴 at minimum.
5. **Large or binary files** (assets, media, dumps): confirm before
   overwriting, because they are not easy to rebuild by hand.

## Example intervention

> User: "Clean up the `build/` and `dist/` folders."
> Framework: 🟡 Medium — `dist/` and `build/` are usually regenerable
> artifacts (recreated by the build), so deleting them is low real
> risk, but I'm flagging it anyway: if either holds something made by
> hand that is not in git, it is lost. Do you confirm both folders are
> 100% build output?
