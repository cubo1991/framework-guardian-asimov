# scripts/ y hooks/

`hooks/hooks.json` registra un hook `PreToolUse` que corre
`scripts/guardian-gate.sh` antes de cualquier comando `Bash` o
`PowerShell`.

## Qué hace `guardian-gate.sh`

Lee el comando que Claude Code está por ejecutar y lo compara contra
los mismos patrones de "Operaciones críticas" descriptos en
`skills/risk-analysis/SKILL.md` (`rm -rf`, `git reset --hard`,
`git push --force`, `DROP DATABASE`, `TRUNCATE`, `sudo rm`,
`curl | bash`, `chmod -R 777`, etc.). Si coincide, devuelve
`permissionDecision: "ask"` — lo que dispara el diálogo de permisos
real de Claude Code, no una simple sugerencia de texto.

Efecto según el modo:

- **Sesión interactiva**: el usuario ve el pedido de permiso y decide
  — igual que cualquier otra confirmación de Claude Code, pero
  garantizada por este hook incluso si el modelo "se olvidó" de
  preguntar.
- **Modo no interactivo (`-p`, sin humano disponible)**: al no haber
  quién responda esa confirmación, la acción queda bloqueada por
  default. Ver `tests/scenarios/14-headless-mode-enforcement.md`.

## Requisitos

- `bash` y `jq` deben estar disponibles en el entorno donde corre
  Claude Code. Si `jq` no está instalado, el script falla en modo
  seguro (no bloquea nada — deja el flujo normal de permisos, no
  "cierra" la terminal), pero en ese caso perdés la capa de
  enforcement técnico y solo queda la capa de razonamiento
  (`risk-analysis`). Instalar `jq`: `apt install jq` /
  `brew install jq` / `choco install jq`, según tu sistema.

## Mantener el patrón sincronizado

Si agregás una operación nueva a la lista de "Operaciones críticas" en
`skills/risk-analysis/SKILL.md`, sumá también el patrón correspondiente
en la variable `PATTERN` de `guardian-gate.sh` — son dos listas que
deben mantenerse alineadas a mano, no hay generación automática entre
ellas.

## Alcance actual y limitaciones conocidas

- Cubre comandos de shell (`Bash`/`PowerShell`). No cubre operaciones
  hechas a través de otras herramientas (ej. un MCP server de base de
  datos que ejecuta SQL sin pasar por una terminal) — para eso, la
  única capa activa hoy es la de razonamiento (`skills/database`).
- El script está pensado para bash/Git Bash. En Windows sin Git Bash
  instalado, el hook puede no ejecutarse correctamente — ver
  `ROADMAP.md` para la idea de un port a PowerShell puro.
- Los patrones son heurísticos (regex), no un parser real de shell —
  pueden dar falsos positivos (piden confirmación de más, sin
  problema) pero, más importante, en teoría también falsos negativos
  ante un comando muy ofuscado. No reemplaza el buen juicio, es una
  red de seguridad adicional.
