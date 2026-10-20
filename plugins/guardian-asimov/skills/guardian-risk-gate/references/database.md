# Database — riesgo sobre datos persistentes

## Checklist previa

- ¿La operación es de **lectura pura** (`SELECT`) o **modifica** datos
  (`INSERT`/`UPDATE`/`DELETE`/DDL)?
- ¿Corre contra una base de **desarrollo/staging** o **producción**?
- ¿El `UPDATE`/`DELETE` tiene un `WHERE` acotado y verificado, o puede
  afectar más filas de las esperadas?
- ¿Existe un **backup reciente** antes de una operación destructiva?
- ¿La migración es **reversible** (tiene `down`) o irreversible (dropea
  columnas/tablas con datos)?
- ¿Hay **transacción** disponible para poder hacer rollback si algo sale
  mal?

## Clasificación rápida

- 🟢 `SELECT`, `EXPLAIN`, consultas de solo lectura, migraciones aditivas
  reversibles en un entorno de desarrollo local.
- 🟡 `UPDATE`/`DELETE` acotados con `WHERE` verificado en desarrollo;
  migraciones aditivas en staging/producción con `down` disponible.
- 🔴 `UPDATE`/`DELETE` en producción; migraciones que alteran tipos o
  renombran columnas con datos existentes; operaciones sin transacción
  en datos que importan.
- ⚫ `DROP DATABASE`, `DROP TABLE`, `TRUNCATE`, `DELETE` sin `WHERE` (o
  con `WHERE` que cubre todo), migraciones destructivas en producción,
  cualquier operación irreversible sin backup confirmado.

## Reglas específicas

1. **Nunca ejecutar DDL/DML destructivo directo en producción** sin
   backup confirmado y confirmación explícita del usuario, sin
   excepción de perfil.
2. **Preferir simular antes de ejecutar**: correr el `SELECT` equivalente
   al `WHERE` de un `UPDATE`/`DELETE` primero, para mostrar cuántas filas
   se van a afectar, antes de correr la versión destructiva.
3. **Preferir transacciones** cuando el motor las soporta, para poder
   hacer `ROLLBACK` si el resultado no es el esperado.
4. **Migraciones**: siempre preferir un cambio aditivo (agregar columna
   nullable) sobre uno destructivo (dropear/renombrar) cuando el
   objetivo final se puede lograr en dos pasos seguros.
5. **Nunca asumir que "dev" significa "sin importancia"** — si el usuario
   no aclaró el entorno, preguntar antes de correr algo destructivo.

## Ejemplo de intervención

> Usuario: "Borrá los usuarios inactivos de la tabla `users`."
> Framework: ⚫ Crítico — un `DELETE` sobre `users` es irreversible si no
> hay backup. Antes de borrar: (1) ¿tenés backup reciente de esta base?
> (2) te muestro primero cuántas filas matchean "inactivo" con un
> `SELECT COUNT(*)` antes de borrar nada. ¿Seguimos así?
