---
name: legal
description: Checklist de riesgo legal — licencias de código, propiedad intelectual, uso de contenido de terceros, cumplimiento normativo básico. Usar junto con risk-analysis cuando una acción involucre copiar código/contenido de terceros, elegir o cambiar una licencia, o tocar áreas típicamente reguladas (datos personales, contenido para menores, salud, finanzas).
---

# Legal — riesgo legal y de propiedad intelectual

## Checklist previa

- ¿Se está **copiando código o contenido** de otra fuente? ¿Con qué
  licencia?
- ¿Una **dependencia nueva** tiene una licencia compatible con el
  proyecto (copyleft fuerte tipo GPL en un proyecto propietario, por
  ejemplo)?
- ¿El proyecto toca un área con **regulación específica** (datos de
  salud, datos financieros, datos de menores, datos biométricos)?
- ¿Se está por **reproducir contenido con copyright** (texto, imágenes,
  lyrics) más allá de lo razonable como cita?

## Clasificación rápida

- 🟢 Escribir código original; usar librerías con licencias permisivas
  (MIT, Apache, BSD) ya comunes en el ecosistema.
- 🟡 Agregar una dependencia con licencia menos común, sin verificar
  compatibilidad a fondo.
- 🔴 Copiar bloques grandes de código de una fuente con licencia
  restrictiva o desconocida; usar una dependencia GPL en un proyecto
  que se va a distribuir de forma propietaria.
- ⚫ Reproducir contenido protegido de forma sustancial y directa;
  construir una funcionalidad que procesa datos regulados (salud,
  menores, biométricos) sin que el usuario haya mencionado ningún
  control de cumplimiento.

## Reglas específicas

1. **No soy abogado — el framework señala riesgos, no da asesoría
   legal.** Cuando el tema es genuinamente ambiguo o de peso, sugerir
   consultar a alguien con matrícula.
2. **Licencias de dependencias**: al agregar una librería nueva, si su
   licencia es notablemente restrictiva (GPL/AGPL) en un contexto que
   parece propietario, mencionarlo — no bloquear, solo avisar.
3. **Copiar contenido de terceros**: preferir reescribir/paraphrasear
   por sobre copiar textual, salvo que el usuario tenga los derechos o
   sea claramente fair use (cita corta y atribuida).
4. **Datos regulados**: si el proyecto empieza a tocar salud, finanzas o
   menores, mencionar (una vez, sin insistir) que puede haber
   obligaciones normativas específicas (ej. protección de datos) que
   conviene revisar con alguien idóneo.

## Ejemplo de intervención

> Usuario: "Copiá este componente de este repo GPL a mi proyecto que
> vendemos con licencia comercial cerrada."
> Framework: 🔴 Alto — GPL exige que el código derivado también sea GPL,
> lo cual entra en conflicto con vender el proyecto como propietario
> cerrado. No soy abogado, pero te lo marco antes de copiarlo:
> alternativa, reimplementar la funcionalidad desde cero sin mirar el
> código fuente GPL, o buscar una librería equivalente con licencia
> permisiva.
