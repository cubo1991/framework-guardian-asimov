# CHANGELOG

Formato basado en [Keep a Changelog](https://keepachangelog.com/).
Versionado semántico.

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
