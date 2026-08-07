# Uso

El framework no se "invoca" manualmente en general — Claude Code lo
consulta solo cuando la tarea coincide con la descripción de alguno de
los módulos en `skills/`. Igual, se puede pedir explícitamente:

- *"Corré un análisis Guardian Asimov antes de hacer esto."*
- *"¿Qué riesgo tiene esta operación según el framework?"*

## Flujo típico

1. El usuario pide una acción con efectos reales (editar, borrar,
   ejecutar, pushear, etc.).
2. Claude Code identifica que aplica `risk-analysis` (y el módulo de
   dominio correspondiente: `git`, `filesystem`, `database`, etc.).
3. Evalúa las ocho dimensiones de riesgo y clasifica: 🟢🟡🔴⚫.
4. Según el nivel (y el perfil activo, ver `config/profiles.md`):
   procede, avisa, o pide confirmación con alternativas.
5. Ejecuta (o no) según la respuesta del usuario.

## Ejemplos de decisiones reales

### 🟢 Bajo — procede sin fricción
> Usuario: "Agregá un botón de logout en el navbar."
> Resultado: Claude edita el componente y listo, sin ningún aviso —
> es un cambio de código versionado, acotado, y totalmente reversible.

### 🟡 Medio — avisa y continúa
> Usuario: "Actualizá la versión de React en `package.json`."
> Resultado: "Listo, actualicé de 18.2 a 18.3 — es un cambio menor
> según semver, no debería romper nada, pero corré los tests para
> confirmar." Continúa sin esperar confirmación.

### 🔴 Alto — pide confirmación
> Usuario: "Cambiá el endpoint de autenticación para que use el nuevo
> proveedor."
> Resultado: "Esto afecta el login de todos los usuarios actuales.
> Qué puede pasar: si el nuevo proveedor no está bien configurado,
> nadie puede entrar. Cómo revertirlo: dejo el código viejo comentado
> y versionado por si hay que volver atrás rápido. Alternativa: probarlo
> primero en un usuario de test antes de aplicarlo a todos. ¿Confirmás
> que avance?"

### ⚫ Crítico — nunca ejecuta directo
> Usuario: "Hacé `DROP TABLE orders`, ya no la necesitamos."
> Resultado: "No voy a correr esto directo porque es irreversible y
> `orders` tiene datos productivos. Antes: (1) ¿hay un backup reciente
> de esta tabla? (2) alternativa más segura: renombrarla a
> `orders_deprecated` en vez de borrarla, así queda recuperable por un
> tiempo. ¿Confirmás borrado definitivo, o vamos con el rename?"

## Cambiar de perfil

Ver `config/profiles.md`. Se puede pedir en cualquier momento:
*"A partir de ahora usá el perfil expert para este proyecto."*

## Cuándo el framework NO interviene

- Lectura y explicación de código.
- Generación de texto/borradores que el usuario todavía no pidió
  guardar en un archivo.
- Preguntas conceptuales sin ejecución de nada.

El objetivo es que el framework sea invisible en el 90% del trabajo
normal, y muy presente en el 10% que realmente lo necesita.
