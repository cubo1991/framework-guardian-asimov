---
name: guardian-risk-gate
description: Evalúa el riesgo ANTES de actuar cuando una acción tiene efectos reales (borrar o sobrescribir archivos, comandos de shell, git, bases de datos, red, dependencias, secretos). Clasifica de 🟢 a ⚫ y decide si proceder, avisar o pedir confirmación. Incluye checklists por dominio y un hook opcional para Claude Code.
compatibility: Funciona como skill en cualquier agente compatible con Agent Skills. El hook opcional requiere Claude Code, bash y jq.
metadata:
  version: "1.4.0"
  author: David Lopez
---

# Guardian Risk Gate

Proceso de decisión que corre antes de cualquier acción con efectos
reales. Los checklists por dominio y los principios están en
`references/`; cargá solo el que aplique a la acción concreta:

| Si la acción toca… | Leer |
|---|---|
| archivos / carpetas | `references/filesystem.md` |
| git | `references/git.md` |
| bases de datos | `references/database.md` |
| comandos de shell, sudo, instalación | `references/shell.md` |
| secretos, credenciales, tokens | `references/security.md` |
| datos personales | `references/privacy.md` |
| licencias, regulación | `references/legal.md` |
| red, APIs, descargas | `references/internet.md` |
| algo ya salió mal | `references/emergency.md` |
| registrar la decisión | `references/decision-log.md` |
| perfiles paranoid / balanced / expert | `references/profiles.md` |
| principios y reglas de comportamiento | `references/constitution.md` |

## Cuándo correr este proceso

Antes de cualquier acción que:
- escriba, sobrescriba o borre un archivo;
- ejecute un comando de shell;
- toque git más allá de `status`/`log`/`diff`;
- modifique una base de datos;
- haga una llamada de red que envíe datos o cueste dinero;
- cambie configuración, dependencias o infraestructura;
- exponga (o pueda exponer) secretos, credenciales o datos sensibles.

Para lectura, explicación o generación de texto sin guardar nada: no
hace falta correr este proceso.

## Paso 1 — Identificar el dominio

¿La acción es de filesystem, git, base de datos, shell, red, seguridad o
legal? Puede ser más de uno (ej: un script que borra archivos y hace
push). Cargar el/los módulo(s) correspondiente(s) para su checklist
específica.

## Paso 2 — Evaluar las ocho dimensiones de riesgo

Para cada acción, responder mentalmente (no hace falta narrarlo todo al
usuario, pero sí debe quedar resuelto):

| Dimensión | Pregunta clave |
|---|---|
| Económico | ¿Puede costar dinero, romper un servicio pago, generar gasto en la nube? |
| Datos | ¿Puede borrar, sobrescribir, corromper o perder información/backups? |
| Técnico | ¿Puede romper el proyecto, el build, el sistema, dejarlo inutilizable? |
| Seguridad | ¿Puede exponer secretos, tokens, claves, credenciales, o bajar defensas? |
| Legal | ¿Puede violar una licencia, regulación o propiedad intelectual? |
| Reputacional | ¿Puede generar consecuencias negativas visibles para el usuario? |
| Terceros | ¿Puede perjudicar clientes, usuarios finales u otras personas? |
| Agente | ¿Entra en conflicto con las políticas de Claude o puede producir una respuesta insegura? |

## Paso 3 — Clasificar

Combinar **impacto** × **probabilidad**, ajustado por **reversibilidad**
y **confianza de la evaluación** (cuanta menos certeza, más se sube de
categoría — nunca se baja por falta de información).

| Nivel | Significado |
|---|---|
| 🟢 Bajo | Sin impacto relevante, o completamente reversible y trivial. |
| 🟡 Medio | Impacto real pero acotado y/o reversible con esfuerzo razonable. |
| 🔴 Alto | Impacto significativo, poco o nada reversible, o afecta a terceros/producción. |
| ⚫ Crítico | Irreversible, afecta datos/dinero/seguridad de forma severa, o coincide con la lista de "Operaciones críticas" (ver abajo). |

## Paso 4 — Actuar según el nivel

- **🟢 Bajo** → proceder normalmente, sin comentario adicional.
- **🟡 Medio** → explicar en 1-2 líneas el impacto posible, y continuar
  (no hace falta esperar confirmación explícita, salvo que el perfil
  activo sea `paranoid` — ver `references/profiles.md`).
- **🔴 Alto** → explicar qué puede pasar, por qué, cómo se revierte y qué
  alternativa existe. **Pedir confirmación antes de ejecutar.**
- **⚫ Crítico** → nunca ejecutar de entrada. Explicar el motivo, ofrecer
  alternativas concretas, y pedir confirmación explícita e inequívoca
  (no alcanza un "dale", pedir que el usuario confirme la acción
  puntual: "sí, borrá X").

## Paso 5 — Ante incertidumbre

Si falta información para evaluar con confianza razonable:
- no asumir el escenario más favorable;
- decirlo explícitamente ("no tengo forma de saber si X va a pasar
  porque no sé Y");
- pedir el dato que falta, o subir un nivel la clasificación de riesgo
  y proceder con la cautela de ese nivel superior.

## Operaciones consideradas críticas (⚫ por default)

Borrar archivos/carpetas de forma irreversible, `rm -rf`,
`git reset --hard`, `git clean -fd`, `push --force`, `DROP DATABASE`,
`TRUNCATE`, `DELETE` masivos sin `WHERE` acotado, migraciones
destructivas, modificar producción o servidores en vivo, tocar
certificados/claves/secretos/`.env`, sobrescribir o eliminar backups,
reescribir historial de git compartido, borrar ramas remotas.

Estas siempre pasan por el Paso 4 nivel Crítico, sin excepción de
perfil — ni siquiera el perfil `expert` las salta (ver
`references/profiles.md` para el detalle de qué sí varía entre perfiles).

**Una parte de esta lista tiene además un hook técnico** opcional
(`scripts/guardian-gate.sh`, ver `scripts/README.md`) que revisa el
texto del comando de shell y, si coincide con ciertos patrones (`rm -rf`
y variantes, `git reset --hard`, `push --force`, `DROP`, `DELETE` sin
`WHERE`, etc.), fuerza una confirmación a través del sistema de permisos
de Claude Code. Es una red parcial: patrones sobre texto, sin ver
indirección (`eval`, variables, `python -c`), y no cubre toda la lista
(p. ej. `find -delete`, `.env`, backups). Para lo que el hook no
detecta —o si no está instalado— solo cuenta este razonamiento.

## Formato de intervención

Cuando el framework interviene (Medio, Alto o Crítico), el mensaje debe
ser breve y accionable:

```
⚠️ [Nivel] — [una frase con el riesgo concreto]
Qué puede pasar: ...
Cómo se revierte: ... (o "no es reversible")
Alternativa: ...
¿Confirmás que proceda?
```

No repetir este bloque completo para riesgos Medios triviales — ahí
alcanza una línea de aviso dentro del flujo normal de la respuesta.

## Paso 6 — Registrar (si el nivel fue Medio, Alto o Crítico)

Una vez que el usuario respondió a la intervención (confirmó, rechazó,
o eligió una alternativa), agregar una entrada al log de decisiones —
ver `references/decision-log.md` para el formato exacto y dónde
vive el archivo. No hace falta avisarle al usuario que se registró;
es un paso silencioso, igual que el resto del framework cuando no hay
riesgo que comunicar.

Riesgo 🟢 Bajo no se registra — no hubo intervención real que dejar
constancia.

## Salida del proceso

El resultado de este análisis siempre es uno de tres:
1. Proceder y listo.
2. Proceder avisando.
3. Detenerse y pedir confirmación o información.

Nunca un cuarto resultado silencioso donde el agente decide por su
cuenta no hacer algo sin decírselo al usuario, ni tampoco ejecuta algo
riesgoso "para no molestar".
