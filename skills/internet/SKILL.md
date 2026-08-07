---
name: internet
description: Checklist de riesgo para acciones de red — llamadas a APIs externas, descargas, envío de datos a servicios de terceros, publicación de contenido público. Usar junto con risk-analysis antes de cualquier request de red que envíe datos del usuario o del proyecto, publique algo, o descargue y ejecute contenido externo.
---

# Internet — riesgo de red y servicios externos

## Checklist previa

- ¿La llamada **envía datos** del usuario/proyecto hacia afuera?
- ¿El servicio externo es **de pago** o puede generar costos por uso
  (rate limits, tiers, llamadas repetidas)?
- ¿Se está **descargando** algo que después se va a ejecutar?
- ¿La acción **publica** contenido públicamente (redes, repos públicos,
  sitios) de forma que después es difícil de retirar del todo?
- ¿El destino de la llamada es **confiable** (dominio conocido, oficial)?

## Clasificación rápida

- 🟢 Consultas de lectura a APIs públicas conocidas sin enviar datos
  sensibles; descargar dependencias desde registries oficiales
  (npm, PyPI, etc.).
- 🟡 Enviar datos no sensibles a un servicio externo conocido; llamadas
  que pueden generar costo bajo y esperado por el usuario.
- 🔴 Enviar datos sensibles o de terceros a un servicio externo;
  llamadas repetidas/en loop a una API de pago sin límite claro;
  descargar contenido de una fuente no verificada.
- ⚫ Publicar contenido públicamente sin confirmación explícita
  (post, commit a repo público, deploy a producción); ejecutar código
  descargado sin inspección; generar gasto significativo o
  potencialmente ilimitado en una API de pago.

## Reglas específicas

1. **Toda acción que publica algo hacia afuera del entorno del usuario
   pasa por confirmación explícita** — esto ya está cubierto por la
   categoría "explicit permission required" de las reglas base de
   Claude, y este framework lo refuerza con el análisis de impacto.
2. **Llamadas en loop a APIs de pago**: estimar y avisar el costo
   aproximado antes de lanzar un proceso que hace muchas llamadas.
3. **Preferir dominios oficiales y ya usados en el proyecto** sobre
   fuentes nuevas no verificadas para descargar dependencias o scripts.
4. **Rate limits y ToS**: si una acción puede violar los términos de uso
   de un servicio (scraping agresivo, automatizar algo que el ToS
   prohíbe), señalarlo antes de proceder.

## Ejemplo de intervención

> Usuario: "Iterá sobre estos 10.000 registros y mandale cada uno a la
> API de traducción de pago."
> Framework: 🔴 Alto — 10.000 llamadas a una API de pago puede generar
> un costo relevante según el pricing del servicio. Antes de lanzarlo:
> ¿tenés una estimación de costo por llamada, o preferís que primero
> corra con una muestra de 20 para validar el resultado antes de las
> 10.000?
