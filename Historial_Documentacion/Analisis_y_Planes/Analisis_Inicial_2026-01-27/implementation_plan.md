# Plan de Implementación - Módulo Series y Tipos de Comprobante

## Objetivo

Implementar la gestión de **Series de Comprobante** y crear la entidad maestra **Tipo de Comprobante**, incorporando reglas de negocio para el movimiento de inventario (Kardex).

## ⚠️ User Review Required

> [!IMPORTANT]
> Se creará la entidad `TipoComprobante` que no existía en el código. Se agregarán campos para definir el comportamiento en Inventario.

## Proposed Changes

### Backend (`Configuracion.API`)

#### [NEW] [TipoComprobante.cs](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Backend/src/Configuracion.API/Configuracion.API.Domain/Entidades/TipoComprobante.cs)

- Entidad maestra.
- Propiedades: `Codigo` (SUNAT), `Nombre` (Factura, Boleta), `MueveStock` (bool), `TipoMovimiento` (Enum: Salida, Entrada, Depende).
  - _Nota_: La lógica exacta de "Venta resta, Compra suma" se manejará en los módulos de Venta/Compra, pero el Tipo debe indicar _si_ afecta stock.

#### [MODIFY] [ConfiguracionDbContext.cs](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Backend/src/Configuracion.API/Configuracion.API.Infrastructure/Datos/ConfiguracionDbContext.cs)

- Agregar `DbSet<TipoComprobante> TiposComprobante`.

#### [MODIFY] [SerieComprobante.cs](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Backend/src/Configuracion.API/Configuracion.API.Domain/Entidades/SerieComprobante.cs)

- Agregar Propiedad de Navegación `TipoComprobante`.

#### [NEW] [TipoComprobanteRepositorio.cs](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Backend/src/Configuracion.API/Configuracion.API.Infrastructure/Repositorios/TipoComprobanteRepositorio.cs)

- Repositorio para CRUD de tipos.

#### [NEW] [TipoComprobanteEndpoints.cs](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Backend/src/Configuracion.API/Configuracion.API.API/Endpoints/TipoComprobanteEndpoints.cs)

- Endpoints CRUD.

#### [MODIFY] [SerieComprobanteEndpoints.cs](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Backend/src/Configuracion.API/Configuracion.API.API/Endpoints/SerieComprobanteEndpoints.cs)

- Implementar CRUD completo.

### Frontend (`src/features/configuracion`)

#### [NEW] [Series y Tipos]

- Tipos: `SerieComprobante`, `TipoComprobante`.
- Servicios: `servicioSeries.ts`, `servicioTiposComprobante.ts`.
- Hooks: Hooks para ambas entidades.
- UI:
  - `PaginaSeries.tsx`: Tabs o Sección para gestionar Tipos y luego Series asociadas.
  - `SerieForm.tsx`.
  - `TipoComprobanteForm.tsx` (con checks para reglas de stock).

#### [MODIFY] [rutas.tsx](file:///e:/ProyectosNuevos/SistemaComercial/Codigo/Frontend/src/configuracion/rutas.tsx)

- Ruta `/configuracion/comprobantes` (Gestión unificada de tipos y series).

## Verification Plan

1. Crear Tipo "Factura" (MueveStock=true).
2. Crear Serie "F001" para el Tipo "Factura".
3. Verificar que se guardan y listan correctamente.
