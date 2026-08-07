#!/bin/bash
# guardian-gate.sh — Framework Guardian Asimov, capa de enforcement técnico.
#
# Se ejecuta como hook PreToolUse antes de cualquier comando Bash/PowerShell.
# Si el comando coincide con la lista de "operaciones críticas" definida en
# skills/risk-analysis/SKILL.md, fuerza una confirmación real a través del
# sistema de permisos de Claude Code (permissionDecision: "ask"), en vez de
# depender de que el modelo decida pedirla por su cuenta.
#
# Requiere: bash, jq. Ver INSTALL.md si tu entorno no los tiene.

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Si no se pudo leer el comando (input inesperado), no bloquear — dejar que
# siga el flujo normal de permisos.
if [ -z "$command" ]; then
  exit 0
fi

# Patrones de "Operaciones críticas" — deben mantenerse alineados con la
# lista de skills/risk-analysis/SKILL.md. Cualquier cambio a esa lista
# debería reflejarse acá también.
PATTERN='rm[[:space:]]+(-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*|-[a-zA-Z]*f[a-zA-Z]*r[a-zA-Z]*|--recursive[[:space:]]+--force|--force[[:space:]]+--recursive)'
PATTERN="$PATTERN"'|Remove-Item[^|;]*-Recurse[^|;]*-Force'
PATTERN="$PATTERN"'|Remove-Item[^|;]*-Force[^|;]*-Recurse'
PATTERN="$PATTERN"'|git[[:space:]]+reset[[:space:]]+--hard'
PATTERN="$PATTERN"'|git[[:space:]]+clean[[:space:]]+-[a-zA-Z]*f'
PATTERN="$PATTERN"'|git[[:space:]]+push[^|;]*(--force([[:space:]]|$)|[[:space:]]-f([[:space:]]|$))'
PATTERN="$PATTERN"'|git[[:space:]]+push[^|;]*--delete'
PATTERN="$PATTERN"'|git[[:space:]]+branch[[:space:]]+-D'
PATTERN="$PATTERN"'|DROP[[:space:]]+(DATABASE|TABLE)'
PATTERN="$PATTERN"'|TRUNCATE[[:space:]]+TABLE'
PATTERN="$PATTERN"'|DELETE[[:space:]]+FROM'
PATTERN="$PATTERN"'|sudo[[:space:]]+rm'
PATTERN="$PATTERN"'|(curl|wget)[^|;]*\|[[:space:]]*(sudo[[:space:]]+)?(ba)?sh'
PATTERN="$PATTERN"'|chmod[[:space:]]+(-R[[:space:]]+)?777'
PATTERN="$PATTERN"'|dd[[:space:]]+if=.*of=/dev/'
PATTERN="$PATTERN"'|mkfs\.'

if echo "$command" | grep -Eiq "$PATTERN"; then
  reason="Guardian Asimov (enforcement técnico): este comando coincide con la lista de operaciones críticas (irreversibles o de alto impacto) del framework — ver skills/risk-analysis/SKILL.md. Necesita confirmación real del usuario antes de ejecutarse, incluso si el modelo decidió proceder solo. Comando detectado: ${command}"
  jq -n --arg reason "$reason" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: $reason
    }
  }'
else
  exit 0
fi
