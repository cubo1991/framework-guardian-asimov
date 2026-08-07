# DESIGN.md — decisiones de diseño

## Por qué skills modulares y no un solo archivo

Un único archivo gigante con todas las reglas tiene dos problemas: (1)
siempre está en contexto, incluso cuando la tarea es "leé este archivo y
explicame qué hace" — puro ruido; (2) mantenerlo es frágil, cualquier
cambio en la sección de git puede pisar accidentalmente la de bases de
datos si todo vive junto.

Separar en skills por dominio (`filesystem`, `git`, `database`, ...)
aprovecha la carga progresiva: Claude Code solo trae al contexto el
módulo relevante para la tarea actual, según el `description` del
frontmatter. Esto es más escalable y más barato en tokens, y permite que
cada módulo evolucione (o se agregue uno nuevo) sin tocar los demás —
principio de abierto/cerrado aplicado a documentación de comportamiento.

## Por qué `risk-analysis` es el núcleo y no un módulo más

Los módulos de dominio (`git`, `filesystem`, etc.) dan **checklists
específicas** — qué mirar en ese dominio puntual. Pero la lógica de
"cómo pasar de una checklist a una decisión" (clasificar, elegir acción,
formatear el aviso) es la misma para todos los dominios. Ponerla una
sola vez en `risk-analysis` evita duplicar la misma lógica de decisión
diez veces y que se desincronicen entre sí.

## Por qué la constitución es un documento aparte de las skills

`constitution.md` no tiene frontmatter de skill (no dispara
automáticamente) porque es más una referencia de fondo que un
disparador de acción — se espera que se cargue una vez al iniciar el
proyecto (vía `CLAUDE.md`/instrucciones de proyecto), no que se
re-consulte en cada tarea. Las skills operativas son las que hacen el
trabajo pesado en el momento.

## Por qué tres perfiles y no una escala continua

Una escala continua (ej. "nivel de paranoia del 1 al 10") suena más
flexible pero en la práctica nadie recuerda qué significa "nivel 6", y
es difícil de documentar de forma consistente. Tres perfiles con nombre
y semántica clara (`Paranoid`/`Balanced`/`Expert`) son más fáciles de
razonar, comunicar y auditar. Si en el futuro se necesita más
granularidad, es más fácil partir de estos tres que de una escala
arbitraria (ver `ROADMAP.md`).

## Por qué las operaciones críticas no varían por perfil

Si `expert` pudiera saltarse confirmación en operaciones irreversibles
(DROP DATABASE, force push a main, rm -rf), el framework dejaría de
cumplir su función principal para el único tipo de daño que no tiene
vuelta atrás. La velocidad que gana `expert` es en fricción para
riesgos medios/altos reversibles, nunca en la red de seguridad para lo
irreversible.

## Por qué un módulo `emergency` separado de `risk-analysis`

`risk-analysis` es preventivo: corre antes de actuar. `emergency` es
reactivo: corre cuando la prevención falló (o no se pudo evitar el daño
por una causa externa). Mezclarlos hubiera hecho el módulo de
prevención más largo y confuso; separarlos deja cada uno enfocado en un
momento distinto del ciclo de vida de una acción.

## Sobre el "no busques minimizar el número de archivos"

Se priorizó tener un archivo por responsabilidad clara (un dominio, una
skill) sobre comprimir todo en menos archivos. El costo es más archivos
para navegar; el beneficio es que cada uno se puede leer, entender y
modificar de forma aislada, que es lo que hace sostenible un proyecto
a varios años y con múltiples colaboradores.

## Qué se agregó más allá del pedido original

- **`emergency`**: el pedido cubre bien la prevención, pero un framework
  de gobernanza maduro necesita también un playbook de contención para
  cuando la prevención no alcanza (bugs, errores humanos, fallas
  externas). Se agregó porque es la contraparte natural de
  `risk-analysis` y evita que, ante un incidente real, el agente
  improvise sin guía.
- **Principio de "ninguna suposición bajo incertidumbre" como regla
  explícita y transversal**, no solo mencionado una vez — se repite en
  la constitución y en `risk-analysis` porque es, en la práctica, la
  falla más común de un agente bien intencionado: rellenar huecos de
  información con el escenario más conveniente en vez de preguntar.
