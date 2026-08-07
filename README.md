# Framework Guardian Asimov

Capa de gobernanza y análisis de riesgos para Claude Code. Analiza toda
acción con efectos reales antes de ejecutarla, y decide si procede sola,
si avisa, o si se detiene a pedir confirmación — sin frenar el trabajo
normal.

Este repositorio es, a la vez, **el marketplace** y **el plugin**: se
instala directamente en Claude Code con `/plugin install`, sin copiar
archivos a mano.

## Instalación rápida

Desde Claude Code, en cualquier proyecto:

```
/plugin marketplace add <owner>/framework-guardian-asimov
/plugin install guardian-asimov@guardian-asimov-marketplace
```

(Reemplazá `<owner>` por tu usuario/organización de GitHub una vez que
subas este repo.)

Con eso alcanza — las skills quedan disponibles y Claude Code las
consulta solo cuando corresponde, según el `description` de cada una.
Para actualizar a una versión nueva más adelante:

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

## Estructura del repositorio

```
framework-guardian-asimov/              # raíz del marketplace
├── .claude-plugin/
│   └── marketplace.json                # catálogo — lista el plugin de abajo
└── plugins/
    └── guardian-asimov/                # el plugin en sí
        ├── .claude-plugin/
        │   └── plugin.json             # manifest del plugin
        ├── constitution.md             # filosofía y principios (fuente de verdad)
        ├── VERSION / CHANGELOG.md / DESIGN.md / ROADMAP.md
        ├── config/
        │   └── profiles.md             # Paranoid / Balanced / Expert
        ├── skills/
        │   ├── risk-analysis/          # motor de decisión — el núcleo
        │   ├── filesystem/  ├── database/  ├── git/  ├── shell/
        │   ├── security/    ├── privacy/   ├── legal/ ├── internet/
        │   └── emergency/              # contención post-incidente
        └── tests/
            └── scenarios/              # casos seguros, peligrosos, ambiguos
```

Cada módulo en `skills/` es independiente: agregar uno nuevo no
requiere tocar los existentes. Ver `plugins/guardian-asimov/DESIGN.md`
para el razonamiento completo de esta arquitectura.

## Uso

Ver `plugins/guardian-asimov/USAGE.md` para ejemplos reales de cómo
interviene el framework en distintos escenarios.

## Filosofía en una frase

Elegir siempre la alternativa menos riesgosa que igual cumple el
objetivo, avisando cuando corresponde y deteniéndose solo cuando el
riesgo lo amerita — nunca por default, nunca en silencio.
