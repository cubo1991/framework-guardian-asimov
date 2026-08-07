---
name: decision-log
description: Mantiene un registro acumulativo de las decisiones que tomó el Framework Guardian Asimov durante el trabajo en el proyecto (intervenciones de riesgo Medio, Alto o Crítico). Usar (1) automáticamente, agregando una entrada, cada vez que risk-analysis clasifique una acción como 🟡🔴⚫ y el usuario decida cómo proceder; (2) cuando el usuario pida ver el historial, con frases como "mostrame el log de decisiones", "qué frenó el framework últimamente", "resumime los riesgos de esta sesión" o "auditá lo que hicimos hoy".
---

# Decision Log — historial de intervenciones

Este módulo complementa a `risk-analysis`: mientras ese motor decide
*en el momento* qué hacer con una acción riesgosa, este módulo se
encarga de que esa decisión quede **registrada** para poder revisarla
después — por el propio usuario, por un compañero de equipo, o por
vos mismo en una sesión futura.

No reemplaza la intervención en el chat (el aviso/confirmación sigue
pasando igual, en línea, como siempre) — el log es un registro
adicional en paralelo, silencioso, que no agrega fricción a la
conversación.

## Cuándo escribir una entrada

Automáticamente, cada vez que `risk-analysis` clasifique una acción
como 🟡 Medio, 🔴 Alto o ⚫ Crítico **y el usuario ya haya respondido**
(confirmó, rechazó, o eligió una alternativa). No se registra:

- Riesgo 🟢 Bajo (no hay intervención real que registrar).
- El momento del aviso en sí — se espera la resolución, para que la
  entrada quede completa con lo que finalmente pasó.

## Dónde vive el archivo

`decision-log.md` en la raíz del proyecto donde se está trabajando (no
dentro de la carpeta del plugin). Si no existe, se crea la primera vez
que hace falta escribir una entrada, con el encabezado mínimo:

```markdown
# Decision Log — Framework Guardian Asimov

Registro de intervenciones de riesgo Medio, Alto o Crítico.
```

Si el proyecto usa control de versiones, este archivo puede
versionarse (da contexto histórico útil al equipo) o excluirse vía
`.gitignore` si el usuario prefiere mantenerlo local — no asumir, y si
surge la duda, preguntar una sola vez y no volver a interrumpir por
esto.

## Formato de cada entrada

```markdown
## [YYYY-MM-DD HH:MM] Nivel — resumen corto de la acción

- **Módulo(s)**: git, filesystem, ...
- **Qué se pidió**: descripción breve de la acción solicitada
- **Riesgo detectado**: una línea con el motivo de la clasificación
- **Alternativa ofrecida**: si hubo una (o "ninguna" si no aplicaba)
- **Resolución**: confirmado / rechazado / se usó la alternativa / se
  pidió más información
```

Ejemplo real:

```markdown
## [2026-08-07 15:12] 🔴 Alto — cambio de proveedor de autenticación

- **Módulo(s)**: security
- **Qué se pidió**: cambiar el endpoint de login para usar un nuevo proveedor
- **Riesgo detectado**: afecta el login de todos los usuarios actuales
- **Alternativa ofrecida**: probar primero con un usuario de test
- **Resolución**: confirmado, se aplicó a todos directamente
```

Mantener cada entrada corta — 4-5 líneas. El log es para escanear
rápido, no para reconstruir la conversación entera.

## Cuándo leer y resumir el log

Ante un pedido del usuario tipo "mostrame el log", "qué se frenó
últimamente", "auditá esta sesión/semana/proyecto":

1. Leer `decision-log.md`.
2. Si no existe todavía, decirlo directamente ("todavía no hay
   entradas registradas en este proyecto") en vez de inventar
   contenido.
3. Si existe, resumir — no pegar el archivo completo salvo que el
   usuario pida verlo entero. Priorizar: cuántas entradas hay, cuántas
   fueron Crítico vs Alto vs Medio, y si hay algún patrón (ej. "la
   mayoría de las intervenciones fueron por operaciones de git en la
   rama main").
4. Si el usuario pide filtrar por fecha, módulo o nivel, hacerlo sobre
   el contenido ya leído.

## Qué NO hace este módulo

- No es un sistema de auditoría de seguridad externo ni de
  cumplimiento normativo — es una bitácora simple para uso del propio
  usuario/equipo.
- No registra el contenido completo de archivos, comandos, ni datos
  sensibles — solo el resumen de la decisión. Si la acción en sí
  involucraba un secreto o dato sensible, el log no debe contener ese
  valor, solo la mención de que existía el riesgo (ver `skills/security`
  y `skills/privacy`).
- No reemplaza `skills/emergency` — si algo ya salió mal, ese es el
  módulo que guía la contención; el log solo deja constancia de que
  pasó, después de resuelto.
