#!/bin/bash
# guardian-doctor.sh — self-diagnosis for the Guardian Risk Gate hook.
#
# Checks, without running any dangerous command, that the hook can start as
# registered in hooks/hooks.json and responds as expected.
# Detects silent failures (script not invocable, jq missing, broken JSON).
#
# Usage:  bash scripts/guardian-doctor.sh
# Exits 0 if everything is fine and 1 if there is any problem.

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
gate="$root/scripts/guardian-gate.sh"
hooks="$root/../../hooks/hooks.json"   # the plugin's hooks.json (absent if the skill is used standalone)
problems=0

ok()   { printf 'OK    %s\n' "$1"; }
fail() { printf 'FAIL  %s\n' "$1"; problems=$(( problems + 1 )); }

# 1. Dependencies
command -v bash >/dev/null 2>&1 && ok "bash available" || fail "bash not available"
if command -v jq >/dev/null 2>&1; then ok "jq available"; else fail "jq is NOT installed: the hook will ask for confirmation on every command (see INSTALL.md)"; fi

# 2. Files
[ -f "$gate" ]  && ok "scripts/guardian-gate.sh exists" || fail "scripts/guardian-gate.sh is missing"
if [ -f "$hooks" ]; then ok "the plugin hooks/hooks.json exists"; else echo "NOTE  hooks/hooks.json not found (standalone skill use: the hook is not registered)"; fi

# 3. hooks.json well-formed and with the expected command
if command -v jq >/dev/null 2>&1 && [ -f "$hooks" ]; then
  if jq -e . "$hooks" >/dev/null 2>&1; then
    ok "hooks.json is valid JSON"
    cmd=$(jq -r '.hooks.PreToolUse[0].hooks[0].command // empty' "$hooks")
    case "$cmd" in
      bash*) ok "the hook is invoked with 'bash' (does not depend on the execute bit)" ;;
      *)     fail "the hook command does not start with 'bash': $cmd" ;;
    esac
    [ "$(jq -r '.hooks.PreToolUse[0].hooks[0].onFailure // empty' "$hooks")" = "block" ] \
      && ok "onFailure=block: if the hook fails, the command is blocked" \
      || fail "onFailure=block is missing in hooks.json: a hook failure would let the command through"
  else
    fail "hooks.json is not valid JSON"
  fi
fi

# 4. Hook response (only text is passed; no command is executed)
if [ -f "$gate" ] && command -v jq >/dev/null 2>&1; then
  danger=$(printf '%s' '{"tool_input":{"command":"rm -rf /tmp/guardian-doctor-prueba"}}' | bash "$gate" 2>/dev/null)
  if printf '%s' "$danger" | grep -q '"permissionDecision": *"ask"'; then
    ok "a critical test command triggers the confirmation"
  else
    fail "a critical test command did NOT trigger the confirmation"
  fi
  safe=$(printf '%s' '{"tool_input":{"command":"ls -la"}}' | bash "$gate" 2>/dev/null)
  if [ -z "$safe" ]; then
    ok "a normal command passes without asking for confirmation"
  else
    fail "a normal command triggered a confirmation"
  fi
fi

echo
if [ "$problems" -eq 0 ]; then
  echo "All good."
  exit 0
fi
echo "$problems problem(s) found."
exit 1
