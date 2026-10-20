#!/bin/bash
# guardian-gate.sh — Framework Guardian Asimov, capa de enforcement técnico.
#
# Se ejecuta como hook PreToolUse antes de cualquier comando Bash/PowerShell.
# Si el comando coincide con la lista de "operaciones críticas" definida en
# SKILL.md, fuerza una confirmación real a través del
# sistema de permisos de Claude Code (permissionDecision: "ask"), en vez de
# depender de que el modelo decida pedirla por su cuenta.
#
# Requiere: bash, jq. Ver INSTALL.md si tu entorno no los tiene.
#
# Límites (ver scripts/README.md): son patrones regex sobre el texto del
# comando, no un parser de shell. No ve indirección (eval, variables,
# python -c), y un texto que contenga el patrón (mensaje de commit, grep)
# también dispara la confirmación.

input=$(cat)

# Sin jq no se puede evaluar el comando: se pide confirmación (falla cerrado)
# en vez de dejar pasar todo en silencio.
ask_nojq() {
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Guardian Asimov: jq no está instalado, por lo que este comando no se puede evaluar. Confirmá manualmente o instalá jq (ver INSTALL.md)."}}'
  exit 0
}
command -v jq >/dev/null 2>&1 || ask_nojq

command=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Si no se pudo leer el comando (input inesperado), no bloquear — dejar que
# siga el flujo normal de permisos.
[ -z "$command" ] && exit 0

has() { printf '%s' "$command" | grep -Eiq "$1"; }

hit=""

# rm con flag recursivo Y flag forzado, en cualquier forma u orden
# (-rf, -fr, -r -f, --recursive --force, etc.).
if has '(^|[^[:alnum:]_-])rm[[:space:]]' \
   && has '[[:space:]](-[a-z]*r[a-z]*|--recursive)([[:space:]]|$)' \
   && has '[[:space:]](-[a-z]*f[a-z]*|--force)([[:space:]]|$)'; then
  hit=1
fi

# DELETE FROM sin WHERE (alineado con SKILL.md:
# "DELETE masivos sin WHERE acotado").
if has 'DELETE[[:space:]]+FROM' && ! has 'WHERE'; then
  hit=1
fi

# Patrones de "Operaciones críticas" — deben mantenerse alineados con la
# lista de SKILL.md. Cualquier cambio a esa lista
# debería reflejarse acá también.
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
  reason="Guardian Asimov (enforcement técnico): este comando coincide con la lista de operaciones críticas (irreversibles o de alto impacto) del framework (ver SKILL.md). Necesita confirmación real del usuario antes de ejecutarse, incluso si el modelo decidió proceder solo. Comando detectado: ${command}"
  jq -n --arg reason "$reason" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: $reason
    }
  }'
fi
exit 0
