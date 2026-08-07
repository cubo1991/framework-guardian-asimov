# Framework Guardian Asimov

Una capa de gobernanza y análisis de riesgos para Claude Code. Analiza
toda acción con efectos reales antes de ejecutarla, y decide si procede
sola, si avisa, o si se detiene a pedir confirmación — sin frenar el
trabajo normal.

No es una skill suelta: es un framework modular de skills + documentos
que se instala en un proyecto y queda disponible para Claude Code cada
vez que trabaja ahí.

## Por qué existe

Un agente que puede editar código, correr comandos de shell, tocar bases
de datos y hacer git push tiene mucho poder. Guardian Asimov es la capa
que se pregunta, antes de cada acción con consecuencias reales: *¿esto
puede salir mal, para quién, y qué tan grave sería?* — y actúa en
consecuencia.

## Estructura

```
framework-guardian-asimov/
├── constitution.md          # Filosofía y principios (fuente de verdad)
├── VERSION
├── CHANGELOG.md
├── DESIGN.md                 # Decisiones de diseño y por qué
├── ROADMAP.md                # Mejoras futuras propuestas
├── config/
│   └── profiles.md           # Perfiles Paranoid / Balanced / Expert
├── skills/
│   ├── risk-analysis/        # Motor de decisión — el núcleo
│   ├── filesystem/           # Archivos y carpetas
│   ├── database/             # Bases de datos
│   ├── git/                  # Control de versiones
│   ├── shell/                # Comandos de terminal
│   ├── security/             # Secretos, credenciales, superficie de ataque
│   ├── privacy/              # Datos personales y de terceros
│   ├── legal/                 # Licencias y propiedad intelectual
│   ├── internet/             # Llamadas de red y servicios externos
│   └── emergency/            # Qué hacer cuando algo ya salió mal
└── tests/
    └── scenarios/            # Casos de prueba: seguros, peligrosos, ambiguos
```

Cada módulo en `skills/` es independiente: agregar uno nuevo no requiere
tocar los existentes. Ver `DESIGN.md` para el razonamiento completo de
esta arquitectura.

## Instalación

Ver `INSTALL.md`.

## Uso

Ver `USAGE.md` para ejemplos reales de cómo interviene el framework en
distintos escenarios.

## Filosofía en una frase

Elegir siempre la alternativa menos riesgosa que igual cumple el
objetivo, avisando cuando corresponde y deteniéndose solo cuando el
riesgo lo amerita — nunca por default, nunca en silencio.
