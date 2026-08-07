# Instalación

## Paso 0 — Subir el repo a GitHub

Este framework ya está estructurado como un marketplace de Claude Code
(`.claude-plugin/marketplace.json` en la raíz + el plugin en
`plugins/guardian-asimov/`). Solo falta subirlo:

```bash
cd framework-guardian-asimov
git init
git add .
git commit -m "Framework Guardian Asimov v1.0.0"
git remote add origin https://github.com/<tu-usuario>/framework-guardian-asimov.git
git push -u origin main
```

Puede ser un repo público o privado — ambos funcionan con
`/plugin marketplace add`.

## Requisito: `jq`

A partir de v1.3.0 el framework incluye un hook técnico
(`hooks/hooks.json` + `scripts/guardian-gate.sh`) que necesita `jq`
disponible en el entorno donde corre Claude Code, para bloquear de
verdad las operaciones críticas (no solo avisar por texto). Si no lo
tenés:

```bash
# macOS
brew install jq
# Debian/Ubuntu
sudo apt install jq
# Windows (con Chocolatey)
choco install jq
```

Si `jq` no está instalado, el framework sigue funcionando igual a nivel
de razonamiento (las skills avisan como siempre), pero pierde la capa
de enforcement técnico — ver `plugins/guardian-asimov/scripts/README.md`.

## Opción A — Instalar como plugin (recomendada)

Desde dentro de Claude Code, en cualquier proyecto donde lo quieras
usar:

```
/plugin marketplace add <tu-usuario>/framework-guardian-asimov
/plugin install guardian-asimov@guardian-asimov-marketplace
```

Si el resumen de instalación dice `Run /reload-plugins to activate.`,
corré ese comando. Listo — las skills quedan disponibles en ese
proyecto (o para tu usuario, según el `--scope` que uses) y Claude Code
las consulta automáticamente cuando la tarea coincide con la
`description` de cada módulo.

### Actualizar a una versión nueva

Cada vez que hagas push de cambios al repo:

```
/plugin marketplace update guardian-asimov-marketplace
```

### Instalar para todo tu usuario en vez de un solo proyecto

Escribí el comando **completo, en una sola línea**, en el prompt de
Claude Code (no lo escribas dentro del cuadro interactivo de
"Add Marketplace" que aparece al tipear solo `/plugin marketplace add`
— ese cuadro espera únicamente la fuente `owner/repo`, sin flags ni el
segundo comando pegado):

```
/plugin marketplace add <tu-usuario>/framework-guardian-asimov --scope user
```

Esperá la confirmación, y recién ahí, en su propio Enter:

```
/plugin install guardian-asimov@guardian-asimov-marketplace
```

Con `--scope user` queda disponible en todos tus proyectos de Claude
Code, no solo en el actual — no hace falta repetir el `marketplace add`
cada vez que abrís un proyecto nuevo. Para confirmarlo:

```
/plugin marketplace list --json
```

### Que tu equipo lo tenga automáticamente

Si trabajás con otras personas en el mismo repo de proyecto (no el del
framework, sino el proyecto donde lo usan), agregá esto a
`.claude/settings.json` del proyecto:

```json
{
  "extraKnownMarketplaces": {
    "guardian-asimov-marketplace": {
      "source": {
        "source": "github",
        "repo": "<tu-usuario>/framework-guardian-asimov"
      }
    }
  },
  "enabledPlugins": {
    "guardian-asimov@guardian-asimov-marketplace": true
  }
}
```

Así, cualquiera que abra ese proyecto con Claude Code recibe el
framework activado automáticamente, sin instalar nada a mano.

## Opción B — Instalación manual (sin marketplace)

Si preferís no usar GitHub o el mecanismo de plugins, se puede seguir
copiando archivos a mano:

```bash
git clone https://github.com/<tu-usuario>/framework-guardian-asimov.git
cp -r framework-guardian-asimov/plugins/guardian-asimov/skills/* .claude/skills/
cp framework-guardian-asimov/plugins/guardian-asimov/constitution.md .claude/
cp -r framework-guardian-asimov/plugins/guardian-asimov/config .claude/
```

Con esta opción no hay auto-update — cada actualización requiere volver
a clonar y copiar.

## Verificar que está activo

Pedile a Claude Code algo levemente riesgoso pero no destructivo, por
ejemplo: *"Borrá la carpeta `dist/`."* — debería avisar brevemente el
riesgo (🟡/🔴 según el estado del proyecto) en vez de borrar sin decir
nada. Si no pasa nada de eso:

- Confirmá que el plugin quedó instalado: `/plugin list` (o revisá
  `.claude/settings.json` si usaste la Opción B).
- Corré `claude plugin validate .` desde la raíz del repo del
  framework para chequear que `marketplace.json` y `plugin.json` estén
  bien formados.

Para verificar específicamente **la capa de enforcement técnico** (el
hook, no solo la skill), corré `/hooks` dentro de Claude Code — debería
listar un `PreToolUse` con matcher `Bash|PowerShell` proveniente de
"Plugin Hooks". Como prueba real, pedile algo como *"borrá esta carpeta
con `rm -rf`"* sobre una carpeta de prueba: debería aparecer un pedido
de permiso real (no solo texto), incluso si en algún momento el modelo
intentara saltearlo.

## Desinstalar / remover el marketplace

```
/plugin marketplace remove guardian-asimov-marketplace
```

Esto también desinstala el plugin. Para solo refrescar sin perder la
instalación, usá `update` en vez de `remove`.
