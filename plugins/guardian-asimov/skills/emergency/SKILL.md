---
name: emergency
description: Qué hacer cuando algo ya salió mal — se ejecutó una acción riesgosa por error, se perdieron datos, se rompió el proyecto o se expuso un secreto. Usar inmediatamente después de detectar que una acción tuvo una consecuencia no deseada, para contener el daño y guiar la recuperación, en vez de seguir avanzando sobre el problema.
---

# Emergency — contención y recuperación

Este módulo se activa **después** de que algo salió mal — no reemplaza
la prevención de `risk-analysis`, la complementa para el caso en que la
prevención falló o no se pudo evitar el daño.

## Primer paso siempre: detener y diagnosticar

Ante la señal de que algo salió mal (error inesperado, archivo
faltante, build roto, dato perdido, secreto expuesto):

1. **Parar** — no seguir ejecutando más acciones sobre el mismo sistema
   hasta entender el alcance del problema.
2. **Decir claramente qué pasó**, sin minimizar ni exagerar.
3. **Evaluar el alcance real** antes de proponer una solución (¿es
   recuperable? ¿cuánto se perdió? ¿hay una copia en algún lado?).

## Playbooks por tipo de incidente

### Pérdida de archivos/código
- Revisar si está en git (`git reflog`, stash, ramas) — muchas
  "pérdidas" son recuperables desde el historial.
- Revisar backups del sistema o del editor (autosave, `.bak`).
- Si es irrecuperable, decirlo directamente y ayudar a reconstruir lo
  posible a partir de lo que sí queda (logs, documentación, memoria de
  la conversación).

### Base de datos dañada
- Si hay backup: guiar la restauración paso a paso, confirmando el
  backup correcto antes de sobrescribir el estado actual dañado.
- Si no hay backup: evaluar si los datos se pueden reconstruir desde
  otra fuente (logs de aplicación, caché, sistema externo).

### Secreto/credencial expuesta
- Prioridad inmediata: **rotar la credencial** (generar una nueva e
  invalidar la vieja) — esto importa más que "limpiar" el lugar donde
  se expuso, porque una vez vista no se puede garantizar que no fue
  copiada.
- Después, remover el secreto del lugar donde quedó expuesto (código,
  logs, historial de git si corresponde).

### Producción rota
- Priorizar **volver al último estado funcional conocido** (rollback)
  sobre intentar arreglar en caliente, salvo que el rollback también
  sea riesgoso.
- Comunicar el estado real: qué está roto, desde cuándo, qué se está
  haciendo.

### Push force que pisó trabajo ajeno
- Buscar el commit perdido vía `reflog` en la máquina de quien lo tenía,
  si es posible.
- Avisar cuanto antes a las personas afectadas — cuanto más tiempo pasa,
  más difícil es recuperar si alguien más siguió trabajando encima.

## Principio general de este módulo

En una emergencia, la prioridad cambia de "prevenir" a "contener y
recuperar el máximo posible", pero la transparencia total con el usuario
se mantiene igual o más estricta que en el flujo normal: nunca ocultar
ni suavizar el alcance real de un incidente.
