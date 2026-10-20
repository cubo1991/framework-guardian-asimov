# scripts/ (optional Claude Code hook)

This folder is **optional**. The skill (`SKILL.md`) works on its own in
any agent that supports Agent Skills. The scripts add a technical brake
only in Claude Code, where the plugin's `hooks/hooks.json` registers a
`PreToolUse` hook that runs `scripts/guardian-gate.sh` before any
`Bash` or `PowerShell` command.

## What `guardian-gate.sh` does

It reads the command Claude Code is about to run and compares it
against the same "Critical operations" patterns described in `SKILL.md`
(`rm -rf`, `git reset --hard`, `git push --force`, `DROP DATABASE`,
`TRUNCATE`, `sudo rm`, `curl | bash`, `chmod -R 777`, etc.). If it
matches, it returns `permissionDecision: "ask"` — which triggers
Claude Code's real permission dialog, not a mere text suggestion. The
hook is invoked with `bash` (it does not depend on the execute bit) and
has `onFailure: "block"`: if the hook fails, the command is blocked
instead of passing.

Effect by mode:

- **Interactive session**: the user sees the permission request and
  decides — like any other Claude Code confirmation, but forced by this
  hook when the command matches, even if the model "forgot" to ask.
- **Non-interactive mode (`-p`, no human available)**: with nobody to
  answer that confirmation, the action is left unexecuted. See
  `evals/scenarios/14-headless-mode-enforcement.md`.

## Requirements

- `bash` and `jq` must be available in the environment where Claude
  Code runs. If `jq` is not installed, the script fails closed: it
  returns `ask` for every command (v1.3.1; before, it silently let
  everything through). Install `jq`: `apt install jq` / `brew install jq`
  / `choco install jq`, depending on your system.

## Verify that it works

- `bash scripts/guardian-doctor.sh` — self-diagnosis: dependencies,
  `hooks.json`, `onFailure`, and that a critical test command triggers
  the confirmation (it executes nothing).
- `bash evals/run-hook-corpus.sh` — regression corpus
  (`evals/hook-corpus.txt`): what is detected, what is not (`LIMIT-FN`)
  and what gives false positives (`LIMIT-FP`). It only feeds text to the
  hook.

## Keeping the pattern in sync

If you add a new operation to the "Critical operations" list in
`SKILL.md`, also add the matching pattern to the `PATTERN` variable in
`guardian-gate.sh` — they are two lists that must be kept aligned by
hand; there is no automatic generation between them.

## Current scope and known limitations

- Covers shell commands (`Bash`/`PowerShell`). It does not cover
  operations done through other tools (e.g. a database MCP server that
  runs SQL without going through a terminal) — for those, the only
  active layer today is the reasoning one (`references/database.md`).
- The script is designed for bash/Git Bash. On Windows without Git Bash
  installed, the hook may not run correctly — see `ROADMAP.md` for the
  idea of a pure PowerShell port.
- The patterns are heuristic (regex), not a real shell parser — they
  can give false positives (asking for confirmation unnecessarily,
  harmless) but, more importantly, also false negatives for any command
  built through indirection (`eval`, variables, `python -c`) or not
  listed (`find -delete`, `terraform destroy`, `kubectl delete`,
  `docker system prune`, etc.; see the corpus). It does not replace good
  judgment; it is an additional safety net.
- Verified on Linux. Windows (Git Bash) and macOS untested.
