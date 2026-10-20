#!/bin/bash
# guardian-doctor.sh — autodiagnóstico del hook de Guardian Asimov.
#
# Comprueba, sin ejecutar ningún comando peligroso, que el hook puede arrancar
# tal como lo registra hooks/hooks.json y que responde como se espera.
# Detecta fallas silenciosas (script no invocable, jq ausente, JSON roto).
#
# Uso:  bash scripts/guardian-doctor.sh
# Sale con código 0 si todo está bien y 1 si hay algún problema.

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
gate="$root/scripts/guardian-gate.sh"
hooks="$root/../../hooks/hooks.json"   # hooks.json del plugin (si el skill se usa suelto, no existe)
problems=0

ok()   { printf 'OK    %s\n' "$1"; }
fail() { printf 'FALLA %s\n' "$1"; problems=$(( problems + 1 )); }

# 1. Dependencias
command -v bash >/dev/null 2>&1 && ok "bash disponible" || fail "bash no disponible"
if command -v jq >/dev/null 2>&1; then ok "jq disponible"; else fail "jq NO está instalado: el hook va a pedir confirmación para todo comando (ver INSTALL.md)"; fi

# 2. Archivos
[ -f "$gate" ]  && ok "existe scripts/guardian-gate.sh" || fail "falta scripts/guardian-gate.sh"
if [ -f "$hooks" ]; then ok "existe hooks/hooks.json del plugin"; else echo "AVISO hooks/hooks.json no existe (uso como skill suelto: el hook no está registrado)"; fi

# 3. hooks.json bien formado y con el comando esperado
if command -v jq >/dev/null 2>&1 && [ -f "$hooks" ]; then
  if jq -e . "$hooks" >/dev/null 2>&1; then
    ok "hooks.json es JSON válido"
    cmd=$(jq -r '.hooks.PreToolUse[0].hooks[0].command // empty' "$hooks")
    case "$cmd" in
      bash*) ok "el hook se invoca con 'bash' (no depende del bit de ejecución)" ;;
      *)     fail "el comando del hook no empieza con 'bash': $cmd" ;;
    esac
    [ "$(jq -r '.hooks.PreToolUse[0].hooks[0].onFailure // empty' "$hooks")" = "block" ] \
      && ok "onFailure=block: si el hook falla, el comando se bloquea" \
      || fail "falta onFailure=block en hooks.json: un fallo del hook dejaría pasar el comando"
  else
    fail "hooks.json no es JSON válido"
  fi
fi

# 4. Respuesta del hook (solo pasa texto; no se ejecuta ningún comando)
if [ -f "$gate" ] && command -v jq >/dev/null 2>&1; then
  danger=$(printf '%s' '{"tool_input":{"command":"rm -rf /tmp/guardian-doctor-prueba"}}' | bash "$gate" 2>/dev/null)
  if printf '%s' "$danger" | grep -q '"permissionDecision": *"ask"'; then
    ok "un comando crítico de prueba dispara la confirmación"
  else
    fail "un comando crítico de prueba NO disparó la confirmación"
  fi
  safe=$(printf '%s' '{"tool_input":{"command":"ls -la"}}' | bash "$gate" 2>/dev/null)
  if [ -z "$safe" ]; then
    ok "un comando normal pasa sin pedir confirmación"
  else
    fail "un comando normal disparó una confirmación"
  fi
fi

echo
if [ "$problems" -eq 0 ]; then
  echo "Todo en orden."
  exit 0
fi
echo "Se encontraron $problems problema(s)."
exit 1
