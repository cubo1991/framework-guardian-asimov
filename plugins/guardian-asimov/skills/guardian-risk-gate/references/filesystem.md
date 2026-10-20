# Filesystem — riesgo sobre archivos y carpetas

## Checklist previa

- ¿La operación **borra** o **sobrescribe** contenido existente sin que
  el usuario lo haya pedido explícitamente para ese archivo puntual?
- ¿Afecta **más archivos** de los que el usuario mencionó (glob amplio,
  carpeta entera, `find ... -delete`)?
- ¿El archivo tiene **valor** que no es obvio recrear (código no
  versionado, datos generados, config manual, archivo subido por el
  usuario)?
- ¿Hay backup, versión en git, o alguna copia previa?
- ¿La operación es **reversible** (papelera, git) o **permanente**?

## Clasificación rápida

- 🟢 Crear un archivo nuevo; editar un archivo versionado en git con
  cambios acotados y pedidos explícitamente.
- 🟡 Sobrescribir un archivo completo (no un edit puntual) aunque esté
  en git; renombrar/mover archivos.
- 🔴 Borrar un archivo no versionado o sin backup; operaciones sobre
  varios archivos a la vez sin listar cuáles.
- ⚫ Borrado recursivo (`rm -rf`, borrar una carpeta completa), borrar
  o sobrescribir backups, borrar algo fuera del directorio de trabajo
  del proyecto.

## Reglas específicas

1. **Preferir el cambio mínimo.** Un `str_replace`/edit puntual es
   siempre mejor que reescribir el archivo entero, aunque el resultado
   final sea "el mismo": reescribir pierde formato, comentarios,
   permisos, y aumenta la superficie de error.
2. **Nunca borrar sin listar qué se borra.** Antes de un borrado
   múltiple, mostrar la lista real de archivos afectados (`ls`/`find`
   en modo dry-run), no solo el patrón.
3. **Preferir mover a un `.bak`/papelera sobre borrar** cuando el
   usuario no fue explícito en que quiere borrado permanente.
4. **Fuera del proyecto = siempre confirmar.** Cualquier ruta que
   escape del directorio de trabajo actual (`../`, rutas absolutas del
   home, `/etc`, etc.) sube automáticamente a 🔴 como mínimo.
5. **Archivos grandes o binarios** (assets, media, dumps): confirmar
   antes de sobrescribir, porque no son fáciles de reconstruir a mano.

## Ejemplo de intervención

> Usuario: "Limpiá la carpeta `build/` y `dist/`."
> Framework: 🟡 Medio — `dist/` y `build/` suelen ser artefactos
> regenerables (se recrean con el build), así que borrarlos es de bajo
> riesgo real, pero aviso igual: si alguno tiene algo hecho a mano que
> no está en git, se pierde. ¿Confirmás que ambas carpetas son 100%
> generadas por build?
