---
name: security
description: Checklist de riesgo de seguridad — exposición de secretos, tokens, claves, credenciales, superficie de ataque, dependencias vulnerables, configuración insegura. Usar junto con risk-analysis siempre que una acción pueda tocar archivos de configuración sensibles, imprimir output que podría contener secretos, agregar dependencias, o modificar controles de acceso/autenticación.
---

# Security — riesgo de seguridad

## Checklist previa

- ¿La acción puede **imprimir, loguear o mostrar** el contenido de un
  `.env`, archivo de claves, token, o variable con secretos?
- ¿Se está por **commitear** un archivo que podría tener secretos?
- ¿Se agrega una **dependencia nueva**? ¿De una fuente confiable?
- ¿Se modifica algo de **autenticación, autorización o control de
  acceso** (permisos, roles, CORS, validación de input)?
- ¿La acción **reduce** una protección existente (deshabilitar una
  validación, bajar un nivel de logging de seguridad, abrir un puerto)?

## Clasificación rápida

- 🟢 Leer código de seguridad para entenderlo/explicarlo sin exponer
  valores reales; agregar una dependencia muy conocida y ya usada en el
  proyecto.
- 🟡 Agregar una dependencia nueva no usada antes en el proyecto;
  modificar validación de input de forma que la endurece.
- 🔴 Modificar lógica de autenticación/autorización; debilitar una
  validación existente; loggear datos potencialmente sensibles (aunque
  no sean secretos "duros").
- ⚫ Imprimir o commitear un secreto real (token, API key, contraseña,
  clave privada); deshabilitar una protección de seguridad sin
  reemplazo; exponer un `.env` o archivo de credenciales.

## Reglas específicas

1. **Nunca imprimir el contenido completo de un archivo que puede tener
   secretos** (`.env`, `*.pem`, `credentials.json`, etc.) — si hace falta
   verificar que existe o tiene el formato esperado, mostrar solo las
   claves/nombres de variable, nunca los valores.
2. **Antes de un commit, revisar si hay secretos** en los archivos
   agregados (patrones tipo `API_KEY=`, `-----BEGIN PRIVATE KEY-----`,
   tokens largos). Si aparece algo así, avisar y sugerir `.gitignore` /
   variables de entorno en vez de commitear.
3. **Dependencias nuevas**: mencionar brevemente si son de bajo
   mantenimiento, muy nuevas, o con vulnerabilidades conocidas si esa
   información está disponible; no es necesario auditar a fondo cada
   vez, pero sí una revisión rápida de sanidad.
4. **Nunca debilitar una protección "para que ande más fácil"** (por
   ejemplo, deshabilitar verificación de certificados TLS, bajar
   permisos de un endpoint) sin explicar el trade-off y confirmar.
5. **Principio de menor privilegio**: cuando el usuario pide dar acceso o
   permisos, sugerir el mínimo necesario salvo que pida explícitamente
   más.

## Ejemplo de intervención

> Usuario: "Mostrame el `.env` para ver si la variable está bien puesta."
> Framework: 🟡 Medio — en vez de mostrar el archivo completo (podría
> tener otras claves sensibles), te muestro solo el nombre de esa
> variable puntual y si tiene valor asignado, sin imprimir el valor.
> ¿Sirve así o necesitás ver el valor real?
