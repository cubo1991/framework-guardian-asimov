# CHANGELOG

Formato basado en [Keep a Changelog](https://keepachangelog.com/).
Versionado semántico.

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
