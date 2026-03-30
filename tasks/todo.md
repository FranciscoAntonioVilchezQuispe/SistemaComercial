# TODO: SistemaComercial

## Tareas Completadas ✅
- [x] Corregir errores de compilación en Backend (Inventario.API, Configuracion.API). <!-- id: 1 -->
- [x] Resolver error `TypeError: .map is not a function` en Frontend. <!-- id: 2 -->
- [x] Estandarizar acceso a `.datos` en componentes de búsqueda y formularios. <!-- id: 3 -->
- [x] Corregir lógica de eliminación de compras (Reversión de ValorTotal y Anulación de Kardex). <!-- id: 4 -->
- [x] Corregir esquema de base de datos para `Sucursal` (Backend) <!-- id: 7 -->
- [x] Corregir error de sintaxis en `DialogoFinalizarVenta.tsx` (Frontend) <!-- id: 8 -->
- [x] Reparar importación rota de `reglasDocumentoService` (Frontend) <!-- id: 9 -->
- [x] Implementar Sistema de Ubigeo Recursivo (Backend Dapper + Frontend Select Cascada). <!-- id: 12 -->
- [x] Integrar Ubigeos en Dashboard y Menú de Configuración (PaginaUbigeos). <!-- id: 13 -->
- [x] Generar Carga masiva de Ubigeos (2115 registros) desde CSV con ID corregido. <!-- id: 14 -->
- [x] Implementar reversión de stock en eliminación/anulación (Bloque 1).
- [x] Sincronizar Cliente-Proveedor con switch "Agregar a" (Bloque 2).
- [x] Implementar FluentValidation y correlativos atómicos (Bloque 3).
- [x] Estandarizar PagedResponse y UI Premium POS (Bloque 4).
- [x] Corregir padding de 8 dígitos para documentos SUNAT.
- [x] BUG FIX: Resolver error de Npgsql DateTime UTC en `VentasDbContext.cs`. <!-- id: 15 -->
- [x] Verificar persistencia de `SeriesComprobante` tras el fix. <!-- id: 16 -->
- [x] Refrescar stock en UI (invalidar caché de productos tras venta). <!-- id: 17 -->
- [x] Corregir envío de pagos para cálculo de `saldo_pendiente`. <!-- id: 18 -->
- [x] Corregir Operación SUNAT y persistencia en Formulario de Compras (Fix UTC). <!-- id: 19 -->
- [x] Sincronizar esquema `ventas.detalle_venta` (Añadir columnas de auditoría). <!-- id: 20 -->
- [x] Corregir IDs de catálogo en `CrearVentaManejador.cs` (Magic Numbers Fix). <!-- id: 21 -->
- [x] Implementar normalización recursiva de fechas UTC en `VentasDbContext`. <!-- id: 22 -->
- [x] Refactorizar a Enums centralizados (`EstadoVenta`, `EstadoPago`, `TipoMovimiento`). <!-- id: 23 -->
- [x] Estabilización Global de Base de Datos (Auditoría en Esquemas: Ventas, Catalogo, Inventario, Contabilidad). <!-- id: 24 -->
- [x] Unificación y Organización de Scripts SQL en Carpeta Central. <!-- id: 25 -->
- [x] **Frontend: Sincronización Integral de Enums y Tipado de Datos**. <!-- id: 27 -->
- [x] **Frontend: Implementación de Vista Previa de Comprobante (Modal Ticket)**. <!-- id: 28 -->
- [x] **Frontend: Validación de Esquema Venta (fechaEmision, totalVenta)**. <!-- id: 29 -->

## Tareas Pendientes 🚀
- [ ] Implementar recálculo retroactivo de saldos de Kardex tras anulación. <!-- id: 5 -->
- [ ] Refactorizar el resto de módulos (Ventas, Contabilidad) al nuevo estándar `PagedResponse`. <!-- id: 6 -->
- [ ] Resolver los 26 errores restantes de TypeScript detectados durante el build. <!-- id: 10 -->
- [ ] Realizar prueba de flujo completo: Crear Venta -> Generar Comprobante -> Validar Stock. <!-- id: 11 -->
- [x] Herramientas: Botón de consulta SUNAT (Simulado)
- [x] Estabilización: Reseteo de secuencias en PostgreSQL
- [x] Documentación: Actualización de lessons.md y decisions.md
- [ ] Mantenimiento: Crear archivo Maestro de Inicialización SQL. <!-- id: 26 -->

### NUEVAS TAREAS — SESIÓN ACTUAL

#### BLOQUE 1: Reversión de Stock en Eliminación/Anulación [COMPLETADO]
- [x] Analizar implementación de movimientos (Entradas/Salidas).
- [x] Verificar si la eliminación ya contempla reversión (Inventario.API).
- [x] Implementar `AnularVentaComando` con reversión de stock.
- [x] Asegurar transaccionalidad y validación de estado previo.

#### BLOQUE 2: "Agregar a Proveedor" en Formulario de Clientes [COMPLETADO]
- [x] Analizar lógica actual en `ProveedorForm.tsx`.
- [x] Implementar switch "Agregar a Proveedor" en `ClienteForm.tsx`.
- [x] Implementar validación de duplicados simétrica.
- [x] Mapear campos entre entidades y verificar persistencia.

#### BLOQUE 3: Validaciones con FluentValidation [COMPLETADO]
- [x] Verificar `AbstractValidator<T>` en DTOs/Commands existentes.
- [x] Implementar validadores para (Ventas, Compras, Clientes, Proveedores).
- [x] Aplicar reglas SUNAT (RUC 11, DNI 8, Series F/B).
- [x] Eliminar Data Annotations de lógica de negocio.

#### BLOQUE 4: Ajustes en Módulo de Ventas [COMPLETADO]
- [x] **4.1** Combos dinámicos para Estado, Estado Pago y Moneda (Usando Hooks).
- [x] **4.2** Zero-padding (8 dígitos) para campo `numero`.
- [x] **4.3** Corregir cálculo de `saldo_pendiente` e incluir `monto_pagado`.
- [x] **4.4** Generar Serie/Correlativo atómicamente en el guardado (backend).
- [x] **4.5** Pantalla de éxito premium animada con Framer Motion.

#### ESTABILIZACIÓN Y CORRECCIÓN DE FLUJOS [COMPLETADO]
- [x] Refrescar stock en UI (invalidar caché de productos tras venta).
- [x] Corregir envío de pagos para cálculo de `saldo_pendiente`.
- [x] Corrección de migraciones EF Core (Ventas y Compras)
- [x] Ejecución de `dotnet ef database update` para ambos contextos
- [x] Sincronización de scripts SQL manuales en `Codigo/BaseDeDatos/Scripts/`
- [x] Actualización de `SCRIPTS_GUIDE.md`
- [ ] Implementación de lógica de negocio para Notas en el Backend (en progreso)

#### BLOQUE 5: Estabilización Interfaz de Ventas y Enums [COMPLETADO]
- [x] Centralizar enums en `src/compartido/enums` (Sincronizados con Backend).
- [x] Refactorizar `PaginaVentas.tsx` para usar enums y tipado estricto en DataTable.
- [x] Actualizar componentes auxiliares (`TablaVentas`, `DetalleVentaModal`, `SearchComprobante`) con nuevos nombres de propiedades.
- [x] Robustecer utilidades de `fecha.ts` y `moneda.ts` para manejar nulos/NaN.
- [x] Implementar modal de vista previa de comprobantes con estilos de impresión.

## Revisión Final
- [x] Compilación total de la solución (Backend).
- [x] Verificación de persistencia en BD para eliminación de compras.
- [x] Carga exitosa del módulo POS sin errores de importación dinámica.
- [x] Verificación de tipos Frontend con `tsc` (0 errores).
- [x] Sincronización visual de estados (Badges) basada en IDs oficiales.
