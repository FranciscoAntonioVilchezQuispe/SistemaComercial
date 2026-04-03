# TODO: SistemaComercial

## Tareas Completadas ✅

### Fase 1: Estabilización Backend Inicial
- [x] Corregir errores de compilación en Backend (Inventario.API, Configuracion.API).
- [x] Resolver error `TypeError: .map is not a function` en Frontend.
- [x] Estandarizar acceso a `.datos` en componentes de búsqueda y formularios.
- [x] Corregir lógica de eliminación de compras (Reversión de ValorTotal y Anulación de Kardex).
- [x] Corregir esquema de base de datos para `Sucursal` (Backend).

### Fase 2: Correcciones Frontend
- [x] Corregir error de sintaxis en `DialogoFinalizarVenta.tsx`.
- [x] Reparar importación rota de `reglasDocumentoService`.

### Fase 3: Sistema de Ubigeos
- [x] Implementar Sistema de Ubigeo Recursivo (Backend Dapper + Frontend Select Cascada).
- [x] Integrar Ubigeos en Dashboard y Menú de Configuración (PaginaUbigeos).
- [x] Generar carga masiva de Ubigeos (2115 registros) desde CSV con ID corregido.

### Fase 4: Reversión de Stock y Sincronización
- [x] Implementar reversión de stock en eliminación/anulación.
- [x] Sincronizar Cliente-Proveedor con switch "Agregar a".
- [x] Implementar FluentValidation y correlativos atómicos.
- [x] Estandarizar PagedResponse y UI Premium POS.

### Fase 5: Módulo de Ventas (POS)
- [x] Combos dinámicos para Estado, Estado Pago y Moneda (Usando Hooks).
- [x] Zero-padding (8 dígitos) para campo `numero`.
- [x] Corregir cálculo de `saldo_pendiente` e incluir `monto_pagado`.
- [x] Generar Serie/Correlativo atómicamente en el guardado (backend).
- [x] Pantalla de éxito premium animada con Framer Motion.
- [x] Corregir padding de 8 dígitos para documentos SUNAT.

### Fase 6: Estabilización de Persistencia
- [x] BUG FIX: Resolver error de Npgsql DateTime UTC en `VentasDbContext.cs`.
- [x] Verificar persistencia de `SeriesComprobante` tras el fix.
- [x] Refrescar stock en UI (invalidar caché de productos tras venta).
- [x] Corregir envío de pagos para cálculo de `saldo_pendiente`.
- [x] Corregir Operación SUNAT y persistencia en Formulario de Compras (Fix UTC).
- [x] Corrección de migraciones EF Core (Ventas y Compras).
- [x] Ejecución de `dotnet ef database update` para ambos contextos.

### Fase 7: Refactorización de Dominio
- [x] Sincronizar esquema `ventas.detalle_venta` (Añadir columnas de auditoría).
- [x] Corregir IDs de catálogo en `CrearVentaManejador.cs` (Magic Numbers Fix).
- [x] Implementar normalización recursiva de fechas UTC en `VentasDbContext`.
- [x] Refactorizar a Enums centralizados (`EstadoVenta`, `EstadoPago`, `TipoMovimiento`).

### Fase 8: Estabilización Global de Esquemas
- [x] Estabilización Global de Base de Datos (Auditoría en Esquemas: Ventas, Catalogo, Inventario, Contabilidad).
- [x] Unificación y Organización de Scripts SQL en Carpeta Central.
- [x] Herramientas: Botón de consulta SUNAT (Simulado).
- [x] Estabilización: Reseteo de secuencias en PostgreSQL.

### Fase 9: Frontend — Enums y Vista Previa
- [x] Centralizar enums en `src/compartido/enums` (Sincronizados con Backend).
- [x] Refactorizar `PaginaVentas.tsx` para usar enums y tipado estricto en DataTable.
- [x] Actualizar componentes auxiliares con nuevos nombres de propiedades.
- [x] Robustecer utilidades de `fecha.ts` y `moneda.ts` para manejar nulos/NaN.
- [x] Implementar modal de vista previa de comprobantes con estilos de impresión.

### Fase 10: Consolidación de Métodos de Pago (Unificación de Esquemas)
- [x] Actualizar `MetodoPago.cs` (Ventas.Domain) — Schema `"ventas"` → `"configuracion"`.
- [x] Actualizar `VentasDbContext.cs` — `ExcludeFromMigrations()` para MetodoPago.
- [x] Actualizar `VentaRepositorio.cs` — SQL Join a `configuracion.metodos_pago`.
- [x] Migración EF Core Configuracion (`PluralizarMetodosPago`) — CreateTable.
- [x] Migración EF Core Ventas (`ExcluirMetodosPago`).
- [x] `dotnet ef database update` — Configuracion ✅.
- [x] `dotnet ef database update` — Ventas ✅.
- [x] Seed data en `configuracion.metodos_pago` (4 registros).
- [x] Migrar FK de `ventas.pagos` → `configuracion.metodos_pago`.
- [x] DROP `ventas.metodos_pago` (tabla legacy eliminada).
- [x] Compilación global exitosa (0 errores).

---

## Fase 11: Cumplimiento SUNAT UBL 2.1 — EN PROGRESO 🚀

> Plan de implementación completo en:
> `C:\Users\prueb\.gemini\antigravity\brain\c85c92d8-330d-4c80-9b8b-3b753c8a0754\implementation_plan.md`

### Fase 11-A: Base de Datos (Script SQL idempotente)
- [ ] Crear schema `sunat` + tabla `cat_estado_cpe` con seed data (7 estados)
- [ ] Crear tabla `sunat.log_envio_cpe` con soporte Ventas/NC/ND (constraint XOR)
- [ ] Crear tabla `ventas.venta_cuota_pago` (cuotas de crédito)
- [ ] INSERT registros faltantes en `configuracion.impuestos` (9995 Exportación, 9999 Gratuita)
- [ ] INSERT registros faltantes en `catalogo.unidades_medida` (ZZ, MTQ, DZN, SET)
- [ ] ALTER `ventas.ventas` — campos UBL: `id_tipo_operacion`, `forma_pago`, `hash_cdr`, `hash_cpe`, `xml_generado`, `subtotal_exonerado`, `subtotal_inafecto`, `id_estado_cpe`, `orden_compra_ref`, `id_empresa`, `numero_ticket_sunat`
- [ ] ALTER `ventas.detalle_venta` — campos UBL: `id_afectacion_igv`, `id_tributo`, `id_unidad_medida` FK
- [ ] ALTER `configuracion.tipo_afectacion_igv` — ADD `id_impuesto` FK
- [ ] ALTER `configuracion.tipo_operacion_sunat` — ADD 4 booleans `aplica_*`
- [ ] ALTER `ventas.nota_credito` — campos UBL: `id_tipo_operacion`, `hash_cpe`, `subtotal_gravado/exo/ina`, `id_empresa`, `numero_ticket_sunat`, `id_estado_cpe`
- [ ] ALTER `ventas.nota_debito` — mismas columnas que nota_credito
- [ ] ALTER `ventas.nota_credito_detalle` — campos UBL: `id_afectacion_igv`, `id_tributo`, `precio_unitario_base`, `valor_item`, `descuento_item`, `porcentaje_impuesto`, `numero_linea`, `id_unidad_medida`
- [ ] ALTER `ventas.nota_debito_detalle` — mismas columnas
- [ ] ADD CONSTRAINT `fk_nc_tipo_nota` → `configuracion.motivo_nota_credito(id_motivo)`
- [ ] ADD CONSTRAINT `fk_nd_tipo_nota` → `configuracion.motivo_nota_debito(id_motivo)`
- [ ] PAUSA: Reportar valores `SELECT DISTINCT estado` y `unidad_medida` antes de migrar

### Fase 11-B: Backend (.NET) — Refactor completo
- [ ] Actualizar 6 entidades C#: `Venta`, `DetalleVenta`, `NotaCredito`, `NotaDebito`, `NotaCreditoDetalle`, `NotaDebitoDetalle`
- [ ] Crear 2 entidades nuevas: `VentaCuotaPago`, `EstadoCpe`
- [ ] Corregir IGV hardcodeado `18.00m` en 6 archivos — leer desde `configuracion.impuestos`
- [ ] **Refactorizar `CrearNotaCreditoManejador.cs`:**
  - [ ] Implementar correlativo automático (`ObtenerSiguienteCorrelativoNCAsync`)
  - [ ] Mover cálculos de montos al backend (subtotal_gravado/exo/ina, igv, total)
  - [ ] Copiar datos del cliente desde la venta referenciada (Include → Cliente)
  - [ ] Validar: venta existe + estado Completada + monto NC ≤ total venta
  - [ ] Actualizar venta al crear NC tipo 01/06 (id_estado → Anulada, saldo → 0)
- [ ] **Refactorizar `CrearNotaDebitoManejador.cs`** — mismo patrón que NC
- [ ] Simplificar `NotaCreditoDto.cs` / `NotaDebitoDto.cs` (entrada liviana, salida completa)
- [ ] Agregar endpoints lectura motivos NC/ND desde `configuracion.motivo_nota_*`
- [ ] Agregar endpoints listado paginado NC y ND
- [ ] Agregar endpoints CRUD Estado CPE + lectura Log Envío SUNAT
- [ ] Migraciones EF Core para Ventas y Configuración
- [ ] Compilar y verificar **0 errores**

### Fase 11-C: Frontend (React/TypeScript) — Ventas UBL + NC/ND
- [ ] Actualizar `ventas.types.ts` con campos UBL nuevos
- [ ] Crear `notas.types.ts` con interfaces tipadas NC/ND (`NotaResumen`, `NotaFormData`, `NotaDetalle`)
- [ ] Crear páginas configuración SUNAT (~15 archivos):
  - [ ] `PaginaAfectacionIgv` — CRUD tipo afectación IGV
  - [ ] `PaginaEstadoCpe` — CRUD estados CPE SUNAT
  - [ ] `PaginaLogSunat` — Grid de solo lectura envíos SUNAT
- [ ] Crear páginas listado NC/ND (~12 archivos):
  - [ ] `PaginaNotasCredito` con `TablaNotasCredito` + hooks + servicios
  - [ ] `PaginaNotasDebito` con `TablaNotasDebito` + hooks + servicios
  - [ ] `ModalVistaNotaCredito` — vista previa de NC
  - [ ] `useMotivosNota` — carga dinámica de motivos desde API
- [ ] **Refactorizar `ModalCrearNotaSunat.tsx`:**
  - [ ] Cargar motivos dinámicamente (los 13 NC y 6 ND del catálogo)
  - [ ] Eliminar cálculos del payload (solo enviar idProducto + cantidad)
  - [ ] No enviar serie/numero/cliente (el backend los asigna)
  - [ ] Mostrar serie-número asignada por backend en toast
- [ ] Actualizar `DialogoFinalizarVenta.tsx` (toggle Contado/Crédito, tipo operación, cuotas)
- [ ] Actualizar `TablaVentas.tsx` (columnas Estado SUNAT + Forma Pago + indicador NC/ND)
- [ ] Actualizar `ModalVistaPreviaVenta.tsx` (sección SUNAT + cuotas + IGV dinámico)
- [ ] Tipar `servicioVentas.ts` — reemplazar `any` por interfaces reales en funciones NC/ND
- [ ] Actualizar rutas, menú y navegación
- [ ] Verificar compilación: `npx tsc --noEmit` → **0 errores**

---

## Tareas Pendientes (Post Fase 11) 📋

### Prioridad Alta
- [ ] Realizar prueba de flujo completo: Crear Venta → Generar NC → Validar Stock y Estado.
- [ ] Implementar recálculo retroactivo de saldos de Kardex tras anulación.

### Prioridad Media
- [ ] Crear archivo Maestro de Inicialización SQL (unificar scripts 01-14 en orden).
- [ ] Implementar pruebas automatizadas (xUnit backend, Vitest frontend).
- [ ] Habilitar Swagger/OpenAPI en todos los microservicios.

### Prioridad Baja
- [ ] Implementar CI/CD Pipelines (GitHub Actions o Azure DevOps).
- [ ] Integración de SonarQube para análisis estático de código.
- [ ] Documentación de API para consumo por terceros (Odoo, Android).

---

## Revisión Final
- [x] Compilación total de la solución (Backend) — 0 errores.
- [x] Verificación de persistencia en BD para eliminación de compras.
- [x] Carga exitosa del módulo POS sin errores de importación dinámica.
- [x] Sincronización visual de estados (Badges) basada en IDs oficiales.
- [x] Tabla `metodos_pago` unificada en esquema `configuracion`.
