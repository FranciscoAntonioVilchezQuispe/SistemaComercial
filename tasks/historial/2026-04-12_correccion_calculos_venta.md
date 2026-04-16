# Historial de Cambios — Corrección de Cálculos de Venta (Precios con IGV)

**Fecha:** 2026-04-12
**Hito:** Sincronización de reglas tributarias entre Frontend y Backend.

## Problema Detectado
El sistema presentaba discrepancias en el cálculo del total de venta. El POS sumaba un 18% extra a precios que ya incluían IGV, mientras que el backend desglosaba el impuesto pero el frontend no reflejaba los cambios tras el guardado, resultando en una percepción de "Subtotal guardado en el Total".

## Cambios Realizados

### Frontend (POS)
1. **[calculos.ts](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Frontend/src/compartido/utilidades/calculos.ts)**:
    - Se cambió la lógica de `calcularTotalesVenta` de "Suma de IGV" a "Desglose de IGV".
    - Ahora el `Total` es la fuente de verdad y el `Subtotal` (Base) se extrae dividiendo entre 1.18.
2. **[useCarrito.ts](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Frontend/src/features/ventas/hooks/useCarrito.ts)**:
    - Se incluyó la propiedad `esGravado` en la preparación de datos para el cálculo, permitiendo manejar productos exonerados.

### Backend (Microservicio Ventas)
1. **[CrearVentaManejador.cs](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Backend/src/Ventas.API/Ventas.API.Application/Manejadores/CrearVentaManejador.cs)**:
    - Se inyectó `IMapper` para transformar la entidad en DTO de respuesta.
    - Se forzó el mapeo manual de los campos calculados (`SubtotalGravado`, `TotalImpuesto`, `TotalVenta`) al DTO de respuesta para asegurar consistencia inmediata en la UI.
    - Se restauró la estructura de la clase tras una corrupción accidental durante la edición.

## Verificación
- Compilación exitosa del microservicio de ventas a través de `dotnet build`.
- Revisión de la lógica de redondeo (`Math.Round(..., 2)` en Backend y `.toFixed(2)` en Frontend).

## Resultados Esperados
- El total del carrito coincidirá con la suma de los productos si estos incluyen IGV.
- La base imponible y el IGV se mostrarán desglosados correctamente en el resumen.
- La venta guardada en la base de datos coincidirá exactamente con lo mostrado en el POS.
