# ROADMAP.md — mejoras futuras propuestas

Ideas para futuras versiones, sin comprometer la filosofía central.

## Corto plazo

- **Módulo `dependencies`**: checklist específica para agregar/actualizar
  paquetes (hoy repartida entre `security` y `legal`) — mantenimiento del
  paquete, popularidad, vulnerabilidades conocidas, breaking changes de
  versión mayor.
- **Módulo `infra`**: separar de `shell`/`internet` lo específico de
  infraestructura como código (Terraform, Docker, CI/CD) — riesgos como
  destruir recursos en la nube, cambiar pipelines de deploy.
- **Plantilla de `CLAUDE.md`** lista para pegar, con la sección del
  framework ya redactada, para bajar la fricción de instalación.

## Mediano plazo

- **Perfil por proyecto vs. perfil por sesión**: permitir que el perfil
  activo se declare en `config/profiles.md` de forma persistente por
  proyecto, y también se pueda overridear solo para la sesión actual.
- **Integración con `tests/scenarios/`** como suite real ejecutable
  (hoy son casos documentados en markdown para revisión manual/con
  subagentes) — correrlos automáticamente contra una versión nueva del
  framework antes de adoptarla, para detectar regresiones de criterio.
- **Rotación del `decision-log.md`** (implementado en v1.2.0): si el
  archivo crece mucho con el tiempo, definir una convención de archivo
  por mes/trimestre en vez de un único archivo indefinido.

## Largo plazo

- **Escala de confianza explícita**: hoy la "confianza de la
  evaluación" es parte del razonamiento interno de `risk-analysis`; se
  podría hacer explícita como un cuarto eje reportado al usuario
  ("evalúo esto con confianza media porque no tengo visibilidad de X").
- **Extensión a otros dominios de riesgo** que puedan surgir con el
  tiempo (ej. IA generativa dentro del propio proyecto, contenido
  producido para usuarios finales, riesgos de accesibilidad) si
  aparecen como necesidad recurrente.
- **Modo de auditoría retrospectiva**: correr el framework no antes de
  actuar sino sobre un historial de acciones ya tomadas (ej. un rango de
  commits), para señalar retroactivamente qué operaciones deberían
  haber pasado por confirmación y no lo hicieron.

## Principio para evaluar cualquier propuesta futura

Toda extensión debe poder explicarse en una frase apuntando a alguno de
los principios de `constitution.md`. Si una mejora propuesta no reduce
riesgo real ni mejora la transparencia/reversibilidad, probablemente no
pertenece a este framework sino a otra parte del proyecto.
