---
name: git
description: Checklist de riesgo para operaciones de git (reset, clean, force push, rebase, borrado de ramas, reescritura de historial). Usar junto con risk-analysis antes de cualquier comando git que no sea status/log/diff/add/commit normal.
---

# Git — riesgo sobre el historial del proyecto

## Checklist previa

- ¿El comando **reescribe historial** (`rebase`, `commit --amend` ya
  pusheado, `filter-branch`) o **descarta cambios** (`reset --hard`,
  `checkout -- .`, `clean -fd`)?
- ¿Hay **cambios sin commitear** que se perderían?
- ¿La rama es **local** o ya fue **pusheada/compartida** con otros?
- ¿Un `push --force` puede pisar commits de otra persona?
- ¿Se está por borrar una **rama** que no está mergeada?

## Clasificación rápida

- 🟢 `status`, `log`, `diff`, `add`, `commit` normal, `push` sin force,
  crear ramas nuevas, `pull` sin conflictos.
- 🟡 `reset --soft`/`--mixed` (no pierde working tree), `checkout` a otra
  rama con cambios ya commiteados, `merge`.
- 🔴 `reset --hard` con cambios sin commitear, `clean -fd`, `rebase` de
  una rama ya pusheada, borrar una rama local no mergeada.
- ⚫ `push --force` a una rama compartida (main/develop/producción),
  `filter-branch`/reescritura de historial ya publicado, borrar una
  rama remota, cualquier operación que pueda destruir el trabajo de
  otra persona del equipo.

## Reglas específicas

1. **`--hard` y `-f`/`--force` son banderas de alerta automática.**
   Cualquier comando que las incluya sube como mínimo a 🔴.
2. **Antes de descartar cambios**, avisar qué se va a perder
   (`git status`/`git diff` primero) — nunca asumir que "no importa".
3. **`push --force` a rama compartida = siempre ⚫.** Si es la rama
   propia del usuario y nadie más la usa, puede bajar a 🔴 avisando,
   pero nunca se ejecuta sin decir explícitamente qué commits se van a
   perder para los demás.
4. **Preferir alternativas no destructivas**: `git stash` en vez de
   `checkout -- .`; `push --force-with-lease` en vez de `--force` a
   secas (falla si alguien más pusheó, en vez de pisarlo silenciosamente).
5. **Borrado de ramas remotas**: confirmar explícitamente el nombre de
   la rama antes de borrar, y verificar que esté mergeada o que el
   usuario sepa que no lo está.

## Ejemplo de intervención

> Usuario: "Hacé reset hard al último commit y pusheá force."
> Framework: ⚫ Crítico — `reset --hard` descarta permanentemente
> cualquier cambio sin commitear que tengas ahora, y el `push --force`
> puede pisar commits de otras personas si la rama es compartida.
> Alternativa más segura: `push --force-with-lease`, que aborta si
> alguien más subió algo. ¿Confirmás que no hay cambios locales que
> quieras conservar y que la rama es solo tuya?
