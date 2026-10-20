# Framework Guardian Asimov

Capa de gobernanza y análisis de riesgos para Claude Code. Analiza toda
acción con efectos reales antes de ejecutarla, y decide si procede sola,
si avisa, o si se detiene a pedir confirmación — sin frenar el trabajo
normal.

Este repositorio es, a la vez, **el marketplace** y **el plugin**: se
instala directamente en Claude Code con `/plugin install`, sin copiar
archivos a mano.

## Instalación rápida (por proyecto)

Desde Claude Code, en el proyecto donde lo quieras usar — son **dos
comandos separados**, cada uno con su propio Enter, no se pegan juntos:

```
/plugin marketplace add cubo1991/framework-guardian-asimov
```

Esperá a que confirme que agregó el marketplace, y recién ahí:

```
/plugin install guardian-asimov@guardian-asimov-marketplace
```

Con eso alcanza — las skills quedan disponibles solo en ese proyecto,
y Claude Code las consulta cuando corresponde, según el `description`
de cada una.

## Instalación global (todos tus proyectos)

Si no querés repetir la instalación en cada proyecto, agregá `--scope
user` al primer comando — así el marketplace queda registrado a nivel
de tu usuario, no atado a la carpeta donde lo corriste:

```
/plugin marketplace add cubo1991/framework-guardian-asimov --scope user
```

Escribilo completo en una sola línea (no lo escribas dentro del cuadro
interactivo de "Add Marketplace" — ese cuadro solo acepta la fuente
`owner/repo`, sin flags). Cuando confirme, instalá el plugin igual que
antes:

```
/plugin install guardian-asimov@guardian-asimov-marketplace
```

Al quedar en scope `user`, no hace falta repetir el `marketplace add`
en cada proyecto nuevo — ya está disponible para vos en cualquiera.
Para confirmar que quedó global:

```
/plugin marketplace list --json
```

Deberías ver `guardian-asimov-marketplace` sin estar atado a una
carpeta puntual de proyecto.

## Actualizar

Cada vez que se suban cambios nuevos al repo:

```
/plugin marketplace update guardian-asimov-marketplace
```

Ver `INSTALL.md` para el detalle completo, incluyendo la opción de
instalación manual (sin marketplace) para quien prefiera copiar
archivos directamente.

## Qué es

Un agente que puede editar código, correr comandos de shell, tocar
bases de datos y hacer git push tiene mucho poder. Guardian Asimov es
la capa que se pregunta, antes de cada acción con consecuencias reales:
*¿esto puede salir mal, para quién, y qué tan grave sería?* — y actúa
en consecuencia.

## Dos capas: razonamiento + enforcement técnico

Para la mayoría de las decisiones, Guardian Asimov es una **skill** —
guía de comportamiento que el modelo interpreta y sigue. Eso funciona
bien en una sesión normal, con vos presente para responder. Pero una
skill no es un control técnico: en modo no interactivo (`-p`, sin
humano disponible), un modelo puede decidir seguir adelante igual.

Por eso, para la lista cerrada de "operaciones críticas" (`rm -rf`,
`git push --force`, `DROP DATABASE`, etc.), el framework agrega una
segunda capa: un **hook técnico** (`scripts/guardian-gate.sh`, registrado en `hooks/hooks.json`) que Claude Code ejecuta automáticamente
antes de correr cada comando de shell, y que pide confirmación a través
del sistema de permisos cuando el texto del comando coincide con uno de
sus patrones — sin depender de que el modelo coopere. En modo
desatendido, sin nadie para confirmar, la acción queda sin ejecutar.

### Qué NO hace el hook

Es una red de seguridad parcial, no una garantía:

- Son patrones regex sobre el texto del comando, no un parser de shell.
- No ve indirección: `eval`, variables, `python -c`, scripts descargados.
- No cubre toda la lista de operaciones críticas (p. ej. `find -delete`,
  `git checkout -- .`, `terraform destroy`, `kubectl delete`, tocar
  `.env` o backups) ni acciones hechas por otras herramientas (MCP, edición de archivos).
- Puede marcar comandos inocuos que solo mencionan un patrón (un
  mensaje de commit, un `grep`).
- Probado en Linux; Windows y macOS sin verificar.

La lista medida de lo que detecta y lo que no está en
`plugins/guardian-asimov/skills/guardian-risk-gate/evals/hook-corpus.txt` (se corre con
`bash plugins/guardian-asimov/skills/guardian-risk-gate/evals/run-hook-corpus.sh`).

Ver `references/constitution.md` (sección 0) para el detalle de esta distinción.

## Estructura del repositorio

```
framework-guardian-asimov/              # raíz del marketplace
├── .claude-plugin/
│   └── marketplace.json                # catálogo — lista el plugin de abajo
└── plugins/
    └── guardian-asimov/                # el plugin
        ├── .claude-plugin/plugin.json  # manifest
        ├── VERSION / CHANGELOG.md / DESIGN.md / ROADMAP.md / USAGE.md
        ├── hooks/hooks.json            # registra el hook PreToolUse
        └── skills/
            └── guardian-risk-gate/     # EL skill (carpeta autocontenida)
                ├── SKILL.md            # proceso de decisión
                ├── references/         # checklists por dominio, perfiles, constitución
                ├── scripts/            # hook opcional + autodiagnóstico
                └── evals/              # escenarios y corpus del hook
```

Es un único skill: el proceso vive en `SKILL.md` y los detalles por
dominio se cargan bajo demanda desde `references/` (carga progresiva). Ver `plugins/guardian-asimov/DESIGN.md`
para el razonamiento completo de esta arquitectura.

## Uso

Ver `plugins/guardian-asimov/USAGE.md` para ejemplos reales de cómo
interviene el framework en distintos escenarios.

## Filosofía en una frase

Elegir siempre la alternativa menos riesgosa que igual cumple el
objetivo, avisando cuando corresponde y deteniéndose solo cuando el
riesgo lo amerita — nunca por default, nunca en silencio.
