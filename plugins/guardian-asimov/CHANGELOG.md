# CHANGELOG

Formato basado en [Keep a Changelog](https://keepachangelog.com/).
Versionado semántico.

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
