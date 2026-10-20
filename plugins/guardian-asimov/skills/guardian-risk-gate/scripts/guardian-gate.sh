#!/bin/bash
# guardian-gate.sh — Guardian Risk Gate, technical enforcement layer.
#
# Runs as a PreToolUse hook before any Bash/PowerShell command.
# If the command matches the "critical operations" list defined in
# SKILL.md, it forces a real confirmation through Claude Code's permission
# system (permissionDecision: "ask"), instead of relying on the model to
# decide to ask on its own.
#
# Requires: bash, jq. See INSTALL.md if your environment lacks them.
#
# Limits (see scripts/README.md): these are regex patterns over the command
# text, not a shell parser. It cannot see indirection (eval, variables,
# python -c), and text that merely contains a pattern (a commit message,
# a grep) also triggers the confirmation.

input=$(cat)

# Without jq the command cannot be evaluated: ask for confirmation (fail
# closed) instead of silently letting everything through.
ask_nojq() {
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Guardian Risk Gate: jq is not installed, so this command cannot be evaluated. Confirm manually or install jq (see INSTALL.md)."}}'
  exit 0
}
command -v jq >/dev/null 2>&1 || ask_nojq

command=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)

# If the command could not be read (unexpected input), do not block — let
# the normal permission flow continue.
[ -z "$command" ] && exit 0

has() { printf '%s' "$command" | grep -Eiq "$1"; }

hit=""

# rm with a recursive flag AND a force flag, in any form or order
# (-rf, -fr, -r -f, --recursive --force, etc.).
if has '(^|[^[:alnum:]_-])rm[[:space:]]' \
   && has '[[:space:]](-[a-z]*r[a-z]*|--recursive)([[:space:]]|$)' \
   && has '[[:space:]](-[a-z]*f[a-z]*|--force)([[:space:]]|$)'; then
  hit=1
fi

# DELETE FROM without WHERE (aligned with SKILL.md:
# mass DELETE without a narrow WHERE).
if has 'DELETE[[:space:]]+FROM' && ! has 'WHERE'; then
  hit=1
fi

# "Critical operations" patterns — must stay aligned with the list in
# SKILL.md. Any change to that list should be reflected here too.
PATTERN='Remove-Item[^|;]*-Recurse[^|;]*-Force'
PATTERN="$PATTERN"'|Remove-Item[^|;]*-Force[^|;]*-Recurse'
PATTERN="$PATTERN"'|git[[:space:]]+reset[[:space:]]+--hard'
PATTERN="$PATTERN"'|git[[:space:]]+clean[[:space:]]+-[a-zA-Z]*f'
PATTERN="$PATTERN"'|git[[:space:]]+push[^|;]*(--force([[:space:]]|$)|[[:space:]]-f([[:space:]]|$))'
PATTERN="$PATTERN"'|git[[:space:]]+push[^|;]*[[:space:]]\+[^[:space:]]'
PATTERN="$PATTERN"'|git[[:space:]]+push[^|;]*--delete'
PATTERN="$PATTERN"'|git[[:space:]]+branch[[:space:]]+-D'
PATTERN="$PATTERN"'|DROP[[:space:]]+(DATABASE|SCHEMA|TABLE)'
PATTERN="$PATTERN"'|TRUNCATE[[:space:]]+TABLE'
PATTERN="$PATTERN"'|sudo[[:space:]]+rm'
PATTERN="$PATTERN"'|(curl|wget)[^|;]*\|[[:space:]]*(sudo[[:space:]]+)?((ba|z)?sh|python[0-9.]*|node|perl|ruby)'
PATTERN="$PATTERN"'|chmod[[:space:]]+(-R[[:space:]]+)?0?777'
PATTERN="$PATTERN"'|dd[[:space:]]+if=.*of=/dev/'
PATTERN="$PATTERN"'|mkfs\.'

if [ -n "$hit" ] || has "$PATTERN"; then
  reason="Guardian Risk Gate (technical enforcement): this command matches the framework's list of critical operations (irreversible or high-impact) — see SKILL.md. It needs real user confirmation before running, even if the model decided to proceed on its own. Detected command: ${command}"
  jq -n --arg reason "$reason" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: $reason
    }
  }'
fi
exit 0
