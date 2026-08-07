---
name: shell
description: Checklist de riesgo para comandos de shell/terminal en general (fuera de git y bases de datos, que tienen sus propios módulos). Usar junto con risk-analysis antes de ejecutar comandos con pipes a bash, sudo, instalación de paquetes, cambios de permisos, procesos en background, o cualquier comando cuyo efecto no sea trivialmente predecible.
---

# Shell — riesgo en comandos de terminal

## Checklist previa

- ¿El comando **borra, mueve o sobrescribe** algo (`rm`, `mv`, `>`)?
- ¿Requiere **privilegios elevados** (`sudo`)?
- ¿**Instala o desinstala** software o dependencias a nivel sistema?
- ¿Cambia **permisos** (`chmod`/`chown`) de forma amplia (`-R`)?
- ¿Descarga y **ejecuta código de internet directamente**
  (`curl ... | bash`)?
- ¿Puede consumir recursos de forma descontrolada (fork bombs, procesos
  sin límite, loops infinitos)?
- ¿El efecto del comando es **fácil de predecir** con certeza, o hay
  flags/comportamiento que no se conoce con precisión?

## Clasificación rápida

- 🟢 Comandos de lectura/inspección (`ls`, `cat`, `grep`, `ps`, `df`),
  ejecución de scripts del propio proyecto en su entorno normal.
- 🟡 Instalar una dependencia declarada (`npm install`, `pip install` de
  un paquete conocido), crear/mover archivos dentro del proyecto.
- 🔴 `sudo` para cambios de sistema, `chmod -R`/`chown -R`, instalar
  software fuera del proyecto, matar procesos que no son propios.
- ⚫ `rm -rf` (especialmente con rutas amplias o variables sin validar),
  `curl | bash` sin inspeccionar el script antes, cualquier comando que
  pueda afectar el sistema operativo host completo o correr con
  privilegios totales sin necesidad clara.

## Reglas específicas

1. **Nunca correr `curl/wget | bash` (o similar) sin mostrarle antes al
   usuario qué hace el script**, o al menos advertir que no se puede
   verificar el contenido antes de ejecutarlo.
2. **Variables sin validar en comandos destructivos son una bandera
   roja**: `rm -rf $VAR/*` si `$VAR` puede estar vacío borra todo desde
   la raíz del filesystem actual. Siempre validar o entrecomillar y
   confirmar el valor antes de correr.
3. **Preferir el comando más específico y menos destructivo** que logre
   el mismo resultado (por ejemplo, borrar archivo por archivo en vez de
   un glob amplio, si la cantidad es manejable).
4. **`sudo` es siempre una pausa**: explicar qué privilegio se necesita y
   por qué, aunque el usuario ya lo haya pedido.
5. **Explicar siempre, en una línea, qué hace un comando destructivo**
   antes de correrlo — no asumir que "es obvio".

## Ejemplo de intervención

> Usuario: "Corré `rm -rf $BUILD_DIR/*` para limpiar."
> Framework: 🔴 Alto — si `$BUILD_DIR` no está seteada o está vacía, ese
> comando borra desde la raíz actual, no solo el build. Antes de correr,
> confirmo el valor real de la variable (`echo $BUILD_DIR`) y si no está
> vacía, sigo con el borrado apuntando a la ruta ya expandida en vez de
> la variable.
