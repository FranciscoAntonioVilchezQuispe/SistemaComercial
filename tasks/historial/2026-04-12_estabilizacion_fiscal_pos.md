# Sesión 2026-04-12: Estabilización Fiscal y POS

## Objetivo
Finalizar la integración de maestros SUNAT en el flujo de ventas, resolver errores de mapeo en base de datos detectados en logs y asegurar la correcta visualización de precios en el Punto de Venta (POS).

## Cambios Técnicos

### Backend (Ventas.API)
- **Corrección de Error 42703 (PostgreSQL)**: Se identificó que la entidad `TipoAfectacionIgvRef` intentaba mapear el ID a una columna inexistente `id`. Se corrigió a `id_afectacion` para coincidir con el esquema real de `configuracion`.
- **Implementación de `TipoTributoRef`**: Se añadió la entidad de referencia para el Catálogo 05 de SUNAT, permitiendo validaciones robustas de tributos en el manejador de ventas.
- **Validación Profunda**: Se actualizó `CrearVentaManejador` para recalcular impuestos y desglosar subtotales (Gravado, Exonerado, Inafecto) consultando directamente las tablas maestras, garantizando integridad fiscal.

### Backend (Catalogo.API)
- **Bug Fix de Precios**: Se detectó una omisión en `ProductoRepositorio.ObtenerPaginadoAsync` donde no se seleccionaba `precio_venta_publico`. Se corrigió la sentencia SQL para restaurar la visibilidad de precios en el grid del POS.

### Frontend
- **Desglose Fiscal**: Se actualizaron las utilidades de cálculo (`calculos.ts`) y el estado del carrito (`useCarrito.ts`) para soportar los múltiples subtotales requeridos por SUNAT.
- **UI POS**: Se modificó `DialogoFinalizarVenta.tsx` para mostrar el desglose de importes detallado al usuario antes de la confirmación final.

## Resultados
- Los productos en el POS ahora muestran sus precios reales configurados.
- Las ventas se guardan con un desglose fiscal preciso y validado contra la base de datos.
- Se eliminaron las excepciones de SQL por columnas inexistentes durante el proceso de persistencia.

## Archivos Modificados
- [Ventas.API] `TipoAfectacionIgvRef.cs`, `TipoTributoRef.cs`, `VentasDbContext.cs`, `CrearVentaManejador.cs`
- [Catalogo.API] `ProductoRepositorio.cs`
- [Frontend] `calculos.ts`, `useCarrito.ts`, `CarritoCompras.tsx`, `DialogoFinalizarVenta.tsx`
