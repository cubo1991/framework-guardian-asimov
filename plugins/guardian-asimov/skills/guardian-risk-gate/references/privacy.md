# Privacy — riesgo de privacidad

## Checklist previa

- ¿Los datos involucrados son de **personas reales** (usuarios, clientes,
  empleados) y no datos sintéticos/de prueba?
- ¿La acción **envía datos a un servicio externo** (API de terceros,
  webhook, servicio de IA)?
- ¿Se están **combinando o cruzando** datos de formas que aumentan lo
  identificable de una persona (deanonimización)?
- ¿Los datos se van a **loguear o persistir** en un lugar más amplio de
  lo necesario (logs compartidos, archivos temporales, historial)?
- ¿Hay una base legal o consentimiento razonable para este uso del dato,
  hasta donde se sabe?

## Clasificación rápida

- 🟢 Trabajar con datos sintéticos, anonimizados, o del propio usuario
  sobre sí mismo.
- 🟡 Procesar datos personales dentro del entorno local del usuario, sin
  enviarlos a servicios externos.
- 🔴 Enviar datos personales a un servicio de terceros (incluida una API
  de IA) sin que quede claro si el usuario tiene autorización para
  hacerlo; loguear PII en un log persistente y compartido.
- ⚫ Publicar o exponer datos personales de terceros (clientes, usuarios
  finales) de forma pública o accesible más allá de lo previsto;
  combinar datasets de forma que identifique a personas que se esperaba
  que quedaran anónimas.

## Reglas específicas

1. **Minimización por default**: si una tarea puede hacerse con menos
   datos personales (una muestra, campos anonimizados), preferir esa
   versión y ofrecerla como opción.
2. **Antes de mandar datos a un servicio externo**, señalar qué datos
   salen y a dónde, especialmente si son de terceros y no del propio
   usuario.
3. **Logs y archivos temporales**: evitar que datos personales queden
   en logs de debug o archivos que el usuario no revisó que se estén
   creando.
4. **No asumir consentimiento** para usos secundarios de datos de
   clientes del usuario (por ejemplo, usar una base de emails de
   clientes para algo distinto de lo que fue recolectada) — señalarlo
   si se detecta.

## Ejemplo de intervención

> Usuario: "Mandale este CSV de clientes a la API de OpenAI para
> clasificar sentimiento de comentarios."
> Framework: 🔴 Alto — el CSV tiene nombre, email y comentario de
> clientes reales; enviarlo a un servicio externo implica que esos datos
> salen del control del usuario. Alternativa: mandar solo la columna de
> comentario (sin nombre/email), que alcanza para clasificar sentimiento
> igual. ¿Vamos por esa versión?
