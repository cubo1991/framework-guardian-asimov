# CHANGELOG

Formato basado en [Keep a Changelog](https://keepachangelog.com/).
Versionado semántico.

## [1.3.1] - 2026-10-20

### Corregido
- **El hook no arrancaba en instalaciones vía marketplace**:
  `guardian-gate.sh` estaba en git como 100644 (sin bit de ejecución),
  Claude Code lo invocaba directo y fallaba con "Permission denied"; como
  ese error no bloquea, los comandos pasaban sin revisión. Ahora
  `hooks.json` lo invoca con `bash "${CLAUDE_PLUGIN_ROOT}/scripts/guardian-gate.sh"`,
  el script quedó en 100755 y se agregó `"onFailure": "block"` (Claude
  Code v2.1.295+) para que un fallo del hook no deje pasar el comando.
- Sin `jq` el hook ya no deja pasar todo en silencio: pide confirmación.
- `rm` recursivo+forzado se detecta en cualquier forma y orden (`-fr`,
  `-r -f`, `--recursive --force`, `/bin/rm`).
- `DELETE FROM ... WHERE ...` ya no dispara la confirmación (alineado con
  la lista de operaciones críticas: solo `DELETE` sin `WHERE`).
- Nuevos patrones: `git push ... +ref`, `DROP SCHEMA/TABLE`,
  `curl|wget ... | sh/python/node/perl/ruby`, `chmod 0777`.

### Agregado
- `tests/hook-corpus.txt` + `tests/run-hook-corpus.sh`: corpus de
  regresión (solo alimenta texto al hook, no ejecuta nada), con
  limitaciones conocidas documentadas como `LIMITE-FN` / `LIMITE-FP`.
- `scripts/guardian-doctor.sh`: autodiagnóstico del hook.

### Cambiado
- Documentación ajustada para no sobreprometer: el hook es una red
  parcial basada en patrones de texto, no una garantía (ver
  `constitution.md` sección 0, `skills/risk-analysis/SKILL.md`,
  escenario 14).

## [1.3.0] - 2026-08-07

### Agregado
- **Capa de enforcement técnico**: `hooks/hooks.json` +
  `scripts/guardian-gate.sh`, un hook `PreToolUse` que intercepta
  comandos de shell antes de ejecutarse y fuerza confirmación real
  (`permissionDecision: "ask"`) para la lista de "Operaciones
  críticas", sin depender de que el modelo decida pedirla.
- `plugins/guardian-asimov/scripts/README.md`: documentación del hook,
  requisitos (`jq`), y limitaciones conocidas.
- Escenario `14-headless-mode-enforcement.md`, que documenta y valida
  el caso real que motivó este cambio.

### Corregido
- **Hallazgo real (reportado por el usuario)**: en modo no interactivo
  (`claude -p`, sin humano disponible para responder), la skill
  `risk-analysis` por sí sola no bloqueaba una operación crítica
  (`rm -rf`) — el modelo, sin nadie a quien preguntarle, intentó
  ejecutarla igual, incluyendo intentos de saltear el sandbox nativo
  de Claude Code. Solo la protección externa del sandbox evitó el
  borrado; el framework instalado no había intervenido. Este release
  agrega la capa de hook que cierra ese hueco: ahora la lista de
  operaciones críticas queda bloqueada por un control técnico
  independiente del razonamiento del modelo.

### Cambiado
- `constitution.md` (sección 0) y `skills/risk-analysis/SKILL.md`:
  documentan explícitamente el modelo de dos capas (razonamiento vía
  skills + enforcement técnico vía hook) y sus límites respectivos.

## [1.2.0] - 2026-08-07

### Agregado
- Módulo `skills/decision-log`: registra automáticamente en
  `decision-log.md` (raíz del proyecto) cada intervención 🟡🔴⚫ una vez
  resuelta por el usuario, y responde a pedidos de resumen del
  historial ("mostrame qué frenó el framework", "auditá esta sesión").
- `risk-analysis`: nuevo Paso 6 — Registrar, que conecta el motor de
  decisión con `decision-log` al cierre de cada intervención.
- Escenario de prueba `13-query-decision-log.md`.
- Ejemplo de uso del log en `USAGE.md`.

## [1.1.0] - 2026-08-07

### Agregado
- Reestructuración como marketplace/plugin instalable de Claude Code
  (`.claude-plugin/marketplace.json` + `plugins/guardian-asimov/`),
  instalable con `/plugin install` en vez de copiar archivos a mano.
- 4 escenarios de prueba nuevos en `tests/scenarios/`, cubriendo los
  módulos que no tenían caso propio: `legal` (09), `privacy` (10),
  `internet` (11) y `emergency` (12).
- `tests/README.md`: explica cómo usar la suite de escenarios para
  validar cambios al framework y como material de onboarding, más una
  tabla de cobertura por módulo.
- Documentación de instalación global (`--scope user`) en `README.md`
  e `INSTALL.md`.

## [1.0.0] - 2026-08-07

### Agregado
- Primera versión del framework: `constitution.md` con las Tres Leyes
  adaptadas y principios rectores.
- Módulo núcleo `skills/risk-analysis` con el proceso de evaluación de
  ocho dimensiones y clasificación 🟢🟡🔴⚫.
- Módulos de dominio: `filesystem`, `database`, `git`, `shell`,
  `security`, `privacy`, `legal`, `internet`.
- Módulo `emergency` para contención y recuperación post-incidente.
- Tres perfiles de configuración: `Paranoid`, `Balanced` (default),
  `Expert` en `config/profiles.md`.
- Documentación de instalación (`INSTALL.md`) y uso (`USAGE.md`) con
  ejemplos reales de intervención por nivel de riesgo.
- `DESIGN.md` con el razonamiento detrás de cada decisión de
  arquitectura.
- Suite inicial de escenarios de prueba en `tests/scenarios/` — casos
  seguros, peligrosos y ambiguos.
