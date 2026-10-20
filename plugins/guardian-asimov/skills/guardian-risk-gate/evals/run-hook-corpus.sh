#!/bin/bash
# run-hook-corpus.sh — runs evals/hook-corpus.txt against scripts/guardian-gate.sh.
#
# It only feeds each command's text to the hook (JSON on stdin); it does NOT
# execute any of the corpus commands.
#
# Usage:  bash evals/run-hook-corpus.sh [path/to/guardian-gate.sh]
# Exits 1 if any case does not match the expectation.

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
gate="${1:-$here/../scripts/guardian-gate.sh}"
corpus="$here/hook-corpus.txt"

command -v jq >/dev/null 2>&1 || { echo "ERROR: jq is required to run the corpus." >&2; exit 2; }
[ -f "$gate" ] || { echo "ERROR: $gate does not exist" >&2; exit 2; }

declare -A total ok
fail=0

while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in ''|\#*) continue ;; esac
  cat_="${line%%@@*}"
  rest="${line#*@@}"
  expected="${rest%%@@*}"
  cmd="${rest#*@@}"

  out=$(jq -n --arg c "$cmd" '{tool_input:{command:$c}}' | bash "$gate" 2>/dev/null)
  if printf '%s' "$out" | grep -q '"permissionDecision": *"ask"'; then got=ASK; else got=PASS; fi

  total[$cat_]=$(( ${total[$cat_]:-0} + 1 ))
  if [ "$got" = "$expected" ]; then
    ok[$cat_]=$(( ${ok[$cat_]:-0} + 1 ))
  else
    fail=$(( fail + 1 ))
    printf 'DIFFERENT [%s] expected=%s actual=%s :: %s\n' "$cat_" "$expected" "$got" "$cmd"
  fi
done < "$corpus"

echo "--- summary by category (matching / total)"
for c in TP VARIANT FIXED CONTROL LIMIT-FN LIMIT-FP; do
  [ -n "${total[$c]:-}" ] && printf '%-10s %s/%s\n' "$c" "${ok[$c]:-0}" "${total[$c]}"
done

if [ "$fail" -gt 0 ]; then
  echo "FAILED: $fail case(s) differ from the expectation."
  exit 1
fi
echo "OK: all cases match the expectation."
