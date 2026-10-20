# Shell — risk in terminal commands

## Pre-check

- Does the command **delete, move or overwrite** anything (`rm`, `mv`,
  `>`)?
- Does it require **elevated privileges** (`sudo`)?
- Does it **install or uninstall** software or dependencies at system
  level?
- Does it change **permissions** (`chmod`/`chown`) broadly (`-R`)?
- Does it download and **execute code from the internet directly**
  (`curl ... | bash`)?
- Can it consume resources uncontrollably (fork bombs, unbounded
  processes, infinite loops)?
- Is the command's effect **easy to predict** with certainty, or are
  there flags/behavior that are not known precisely?

## Quick classification

- 🟢 Read/inspection commands (`ls`, `cat`, `grep`, `ps`, `df`),
  running the project's own scripts in its normal environment.
- 🟡 Installing a declared dependency (`npm install`, `pip install` of
  a known package), creating/moving files inside the project.
- 🔴 `sudo` for system changes, `chmod -R`/`chown -R`, installing
  software outside the project, killing processes that are not your
  own.
- ⚫ `rm -rf` (especially with broad paths or unvalidated variables),
  `curl | bash` without inspecting the script first, any command that
  could affect the entire host operating system or run with full
  privileges without a clear need.

## Specific rules

1. **Never run `curl/wget | bash` (or similar) without first showing
   the user what the script does**, or at least warning that its
   contents cannot be verified before running.
2. **Unvalidated variables in destructive commands are a red flag**:
   `rm -rf $VAR/*` with `$VAR` possibly empty deletes everything from
   the current filesystem root. Always validate or quote, and confirm
   the value before running.
3. **Prefer the most specific, least destructive command** that
   achieves the same result (for example, deleting file by file
   instead of a broad glob, if the count is manageable).
4. **`sudo` is always a pause**: explain what privilege is needed and
   why, even if the user already asked for it.
5. **Always explain, in one line, what a destructive command does**
   before running it — don't assume "it's obvious".

## Example intervention

> User: "Run `rm -rf $BUILD_DIR/*` to clean up."
> Framework: 🔴 High — if `$BUILD_DIR` is unset or empty, that command
> deletes from the current root, not just the build. Before running, I
> confirm the variable's real value (`echo $BUILD_DIR`), and if it is
> not empty, I proceed with the deletion pointing at the already
> expanded path instead of the variable.
