---
name: risk-analysis
description: Núcleo del Framework Guardian Asimov. Ejecuta esto ANTES de cualquier acción con efectos reales (escribir/borrar archivos, comandos de shell, git, bases de datos, red, configuración, dependencias). Evalúa riesgo económico, de datos, técnico, de seguridad, legal, reputacional, para terceros y para el propio agente, clasifica el riesgo y decide si proceder, avisar o pedir confirmación. Consultá también el módulo específico (filesystem, git, database, shell, security, privacy, legal, internet) que aplique a la acción concreta.
---

# Risk Analysis — motor de decisión

Este es el módulo que orquesta todo el framework. Los demás módulos
(`filesystem`, `git`, `database`, `shell`, `security`, `privacy`, `legal`,
`internet`, `emergency`) aportan checklists específicas de su dominio;
este módulo define **cómo se usa esa información para decidir**.

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
  activo sea `paranoid` — ver `config/profiles.md`).
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
`config/profiles.md` para el detalle de qué sí varía entre perfiles).

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

## Salida del proceso

El resultado de este análisis siempre es uno de tres:
1. Proceder y listo.
2. Proceder avisando.
3. Detenerse y pedir confirmación o información.

Nunca un cuarto resultado silencioso donde el agente decide por su
cuenta no hacer algo sin decírselo al usuario, ni tampoco ejecuta algo
riesgoso "para no molestar".
