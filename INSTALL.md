# Instalación

## Opción A — Skills de Claude Code (recomendada)

1. Copiar la carpeta `skills/` de este framework a la carpeta de skills
   de tu proyecto en Claude Code (normalmente `.claude/skills/` dentro
   del repo, o la carpeta de skills de usuario si querés que aplique a
   todos tus proyectos).

   ```
   cp -r framework-guardian-asimov/skills/* /ruta/a/tu/proyecto/.claude/skills/
   ```

2. Copiar `constitution.md` y `config/profiles.md` a la raíz de
   `.claude/` del proyecto (o donde tu setup de Claude Code cargue
   contexto persistente), para que la filosofía general esté siempre
   disponible aunque no se dispare ningún módulo puntual.

3. (Opcional pero recomendado) Referenciar la constitución desde tu
   `CLAUDE.md` del proyecto, agregando una línea como:

   ```markdown
   ## Framework Guardian Asimov
   Este proyecto usa el Framework Guardian Asimov para análisis de riesgo.
   Ver .claude/constitution.md y .claude/skills/risk-analysis/SKILL.md.
   Perfil activo: Balanced (ver .claude/config/profiles.md para cambiarlo).
   ```

4. Listo. Claude Code detecta las skills automáticamente por su
   `description` en el frontmatter y las consulta cuando una tarea
   coincide (borrar archivos, git, bases de datos, etc.).

## Opción B — Solo como documento de referencia

Si no querés usar el mecanismo de skills, se puede pegar
`constitution.md` + `skills/risk-analysis/SKILL.md` directamente en las
instrucciones de sistema/proyecto de Claude Code. Perdés la carga
progresiva (todo queda siempre en contexto) pero funciona igual como
guía de comportamiento.

## Verificar que está activo

Pedile a Claude Code algo levemente riesgoso pero no destructivo, por
ejemplo: *"Borrá la carpeta `dist/`."* — debería avisar brevemente el
riesgo (🟡/🔴 según el estado del proyecto) en vez de borrar sin decir
nada. Si no pasa nada de eso, revisar que las skills se hayan copiado a
la ruta correcta y que el frontmatter (`name`/`description`) esté
intacto.

## Actualizar

Reemplazar la carpeta `skills/` completa por la versión nueva y revisar
`CHANGELOG.md` para ver qué cambió. `config/profiles.md` conviene
revisarlo manualmente si tenías un perfil custom, porque un `cp -r` lo
pisaría.
