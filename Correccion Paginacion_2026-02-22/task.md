# Solucionar error "PageNumber missing"

- [x] Inspeccionar los controladores en el backend (se encontró en `ProductoEndpoints`, `MarcaEndpoints`, `CategoriaEndpoints` que usan `PagedRequest`).
- [x] Inspeccionar el servicio de productos en el frontend (`servicioProductos.ts` y `servicioMarcas.ts`).
- [x] Implementar solución en backend: Hacer que `PageNumber` y `PageSize` sean opcionales (`int?`) en `PagedRequest.cs` y usar `1` y `10` por defecto al llamar al repositorio.
- [x] Implementar solución en frontend: Asegurar que `servicioProductos.ts` y `servicioMarcas.ts` envíen estos parámetros obligatoriamente si no existen (valor por defecto).
- [x] Verificar la solución probando la llamada API desde el frontend.
