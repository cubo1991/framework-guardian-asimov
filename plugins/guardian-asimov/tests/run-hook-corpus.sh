#!/bin/bash
# run-hook-corpus.sh — corre tests/hook-corpus.txt contra scripts/guardian-gate.sh.
#
# Solo alimenta el texto de cada comando al hook (JSON por stdin); NO ejecuta
# ninguno de los comandos del corpus.
#
# Uso:  bash tests/run-hook-corpus.sh [ruta/a/guardian-gate.sh]
# Sale con código 1 si algún caso no coincide con lo esperado.

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
gate="${1:-$here/../scripts/guardian-gate.sh}"
corpus="$here/hook-corpus.txt"

command -v jq >/dev/null 2>&1 || { echo "ERROR: se necesita jq para correr el corpus." >&2; exit 2; }
[ -f "$gate" ] || { echo "ERROR: no existe $gate" >&2; exit 2; }

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
    printf 'DIFERENTE [%s] esperado=%s real=%s :: %s\n' "$cat_" "$expected" "$got" "$cmd"
  fi
done < "$corpus"

echo "--- resumen por categoría (coinciden / total)"
for c in TP VARIANTE CORREGIDO CONTROL LIMITE-FN LIMITE-FP; do
  [ -n "${total[$c]:-}" ] && printf '%-10s %s/%s\n' "$c" "${ok[$c]:-0}" "${total[$c]}"
done

if [ "$fail" -gt 0 ]; then
  echo "FALLÓ: $fail caso(s) distinto(s) de lo esperado."
  exit 1
fi
echo "OK: todos los casos coinciden con lo esperado."
