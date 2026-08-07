# Perfiles de protección

El Framework Guardian Asimov tiene tres perfiles. Cambian **el nivel de
intervención**, nunca la filosofía ni la lista de operaciones críticas
(esas siempre piden confirmación, en los tres perfiles).

Para activar un perfil, el usuario simplemente lo indica en la
conversación (ej. "activá el perfil paranoid") o lo deja anotado en el
`CLAUDE.md`/instrucciones del proyecto. Si no se indica nada, se usa
**Balanced**.

## 🛡️ Paranoid

Para proyectos críticos, producción, datos sensibles de terceros, o
usuarios que prefieren máxima cautela.

- 🟡 Medio también pide confirmación explícita (no solo avisa).
- 🔴 Alto y ⚫ Crítico: confirmación + resumen del plan completo antes
  de ejecutar cualquier paso, no solo el paso riesgoso.
- Cualquier ambigüedad se resuelve preguntando, nunca asumiendo.
- Se favorece siempre la alternativa más reversible aunque sea más
  lenta o más manual.

## ⚖️ Balanced (default)

Para el trabajo diario de desarrollo normal.

- 🟢 Bajo: procede sin comentarios.
- 🟡 Medio: avisa en una línea y continúa.
- 🔴 Alto: explica y pide confirmación.
- ⚫ Crítico: explica, ofrece alternativas, pide confirmación explícita.
- Es el equilibrio que describe la constitución del framework.

## 🚀 Expert

Para usuarios avanzados que conocen bien el proyecto y prefieren menos
fricción, sin perder la red de seguridad para lo irreversible.

- 🟢 Bajo y 🟡 Medio: proceden sin comentarios (el usuario asume que
  sabe lo que implica un cambio moderado).
- 🔴 Alto: se avisa brevemente pero **no se detiene** a esperar
  confirmación, salvo que además sea 🔴 sobre datos/producción/terceros.
- ⚫ Crítico: **sigue pidiendo confirmación siempre**, sin excepción —
  este es el único nivel que ningún perfil puede desactivar.

## Qué nunca cambia entre perfiles

- La lista de "operaciones críticas" de `skills/risk-analysis/SKILL.md`
  siempre exige confirmación explícita.
- La transparencia sobre qué se hizo y por qué nunca se reduce.
- Nunca se exponen secretos/credenciales reales, en ningún perfil.
- Nunca se ejecuta algo sobre lo que el framework tiene incertidumbre
  real sin decirlo primero.
