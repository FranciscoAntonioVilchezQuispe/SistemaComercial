# Plan de Trabajo - Sistema Comercial (Retail/Mayorista)

## Fase 1: Planificación y Arquitectura ✅

- [x] Definir Módulos del Sistema
- [x] Seleccionar Stack Tecnológico (Backend/Frontend) <!-- Completado: .NET 8 + React -->
- [x] Diseñar Modelo de Datos (ERD - Entidad Relación) <!-- Completado: Script SQL generado -->

## Fase 2: Generación de Código y Estructura ✅

- [x] Scaffolding de Directorios (Backend/Frontend)
- [x] Implementar BuildingBlocks (.NET)
- [x] Implementar Microservicio Catálogo (Template Completo)
  - [x] Endpoints CRUD Producto
  - [x] Configuración EF Core (SnakeCase, Auditoría Automática)
  - [x] Estandarización de Respuestas (Wrappers)
- [x] Implementar Base Frontend (React + Vite)
  - [x] Solución de conflictos de tipos y compilación (React Query, Store)
- [x] Configuración Base de Datos (EF Core Migrations - Schema: catalogo)
- [ ] Configuración Docker y Documentación <!-- Pendiente: Docker no disponible -->

## Fase 3: Refactorización de Arquitectura de Datos ✅ (NUEVO)

- [x] **Sistema de Tablas Maestro-Detalle**
  - [x] Diseño de entidades TablaGeneral y TablaGeneralDetalle
  - [x] Creación de proyectos Identidad.API (Domain, Infrastructure, API)
  - [x] Configuración de IdentidadDbContext
  - [x] Migración EF Core para esquema configuracion e identidad

- [x] **Refactorización de Entidades del Dominio**
  - [x] Tipos: 10 entidades migradas (Cliente, Venta, Compra, Producto, Proveedor, etc.)
  - [x] Estados: 6 entidades migradas (Venta, Cotizacion, Caja, OrdenCompra, AsientoContable, Compra)
  - [x] Total: 18 columnas convertidas de VARCHAR a BIGINT

- [x] **Scripts SQL de Base de Datos**
  - [x] 01_init_tablas_generales.sql (Creación + 13 categorías + 50 valores)
  - [x] 02_migrate_tipos_estados.sql (Migración de 12 tablas en 6 esquemas)
  - [x] README.md con documentación completa
  - [x] Ejecución y verificación exitosa en PostgreSQL

- [x] **Integridad Referencial**
  - [x] 18 Foreign Keys creadas hacia tablas_generales_detalle
  - [x] Índices optimizados para consultas
  - [x] Constraints únicos (id_tabla, codigo)

## Fase 4: Desarrollo de Módulos (MVP) - EN PROGRESO

- [x] **Módulo de Inventario**
  - [x] Entidades del dominio (MovimientoInventario refactorizado)
  - [x] Endpoints CRUD (Backend Implementado)
  - [x] **Sincronización Migraciones** (Baselined)
  - [x] Lógica de negocio (CQRS + Control Stock)
- [/] **Módulo de Ventas (Retail/POS)**
  - [x] Entidades del dominio (Venta, Cotizacion, Caja refactorizadas)
  - [x] Endpoints CRUD
  - [x] Endpoints CRUD
  - [x] **Sincronización Migraciones** (Baselined)
  - [x] Lógica de negocio (MediatR implementado para creación)
- [/] **Módulo de Clientes**
  - [x] Entidades del dominio (Cliente refactorizado)
  - [x] Endpoints CRUD
  - [x] **Sincronización Migraciones** (Baselined)
  - [ ] Lógica de negocio (Pendiente acciones complejas)

- [x] **Módulo de Compras**
  - [x] Entidades del dominio (Compra, OrdenCompra, Proveedor refactorizados)
  - [x] Endpoints CRUD
  - [x] **Sincronización Migraciones** (Baselined)
  - [x] Lógica de negocio (MediatR implementado para creación)

- [/] **Módulo de Contabilidad**
  - [x] Entidades del dominio (AsientoContable, PlanCuenta refactorizados)
  - [x] Endpoints CRUD
  - [ ] Lógica de negocio (Pendiente generador de asientos)

## Fase 5: Próximos Pasos Inmediatos

- [ ] **Actualización de DTOs y Lógica de Negocio**
  - [x] **Prioridad Alta:** Refactorizar DTOs de Módulo Inventario para usar IDs de catálogos
  - [x] Validar existencia de catálogos en CommandHandlers (usando gRPC, HTTP o lógica compartida)
  - [x] Refactorizar Módulos de Ventas y Compras (DTOs y Endpoints)
  - [x] Implementar CommandHandlers para Ventas y Compras (Opcional/Siguiente fase)

- [x] **Integración de Inventario Automático (Ventas/Compras)**
  - [x] [Ventas] Implementar `VentaCreadaEvento` y `VentaCreadaIntegracionHandler`
  - [x] [Ventas] Crear `IInventarioServicio` (HttpClient)
  - [x] [Compras] Implementar `CompraCreadaEvento` y `CompraCreadaIntegracionHandler`
  - [x] [Compras] Crear `IInventarioServicio` (HttpClient)
  - [x] Configurar `IHttpClientFactory` en `Program.cs` de ambos servicios

- [x] **Endpoints de Catálogos (MIGRADO A CONFIGURACION.API)**
  - [x] Crear microservicio `Configuracion.API` (Puerto 5002)
  - [x] Migrar entidades (TablaGeneral, Empresa, etc.) y DbContext
  - [x] Implementar Endpoints: GET /api/catalogos

- [x] **Integración Frontend (Re-priorización)**
  - [x] Consolidar Axios multi-instance (`src/lib/axios.ts`)
  - [x] Crear `catalogoService.ts` genérico para consumir `/api/catalogos`
  - [x] Implementar Hook `useCatalogo` genérico
  - [x] Implementar componente `SelectorCatalogo` reutilizable
  - [x] Refactorizar `ProductoForm` para usar el nuevo selector
  - [x] Actualizar Listas de Ventas y Compras para mostrar nombres de catálogos

## Fase 6: Integración Contable y Futuro

- [ ] Diseño de integración contable
- [ ] Reportes y Analytics

## Fase 7: Implementación Masiva de Endpoints por Esquema 🚀 (NUEVO)

- [x] **Esquema: catalogo** (Orden: 1/8)
  - [x] `ProductoEndpoints` (Completado)
  - [x] `CategoriasEndpoints` (Completado)
  - [x] `MarcasEndpoints` (Completado)
  - [x] `UnidadesMedidaEndpoints` (Completado)
  - [x] `ImagenesProductoEndpoints` (Completado)
  - [x] `ListasPreciosEndpoints` (Completado)
  - [x] `VariantesProductoEndpoints` (Completado)

- [x] **Esquema: clientes** (Orden: 2/8)
  - [x] `ClientesEndpoints`
  - [x] `ContactosClienteEndpoints`

- [x] **Esquema: compras** (Orden: 3/8)
  - [x] `ProveedoresEndpoints`
  - [x] `OrdenesCompraEndpoints`
  - [x] `ComprasEndpoints`

- [x] **Esquema: configuracion** (Orden: 4/8)
  - [x] `CatalogosEndpoints` (Completado en Configuracion.API)
  - [x] `EmpresaEndpoints`
  - [x] `SucursalEndpoints`
  - [x] `ImpuestoEndpoints`
  - [x] `MetodoPagoEndpoints`
  - [x] `SerieComprobanteEndpoints`

- [x] **Esquema: inventario** (Orden: 5/8)
  - [x] `AlmacenesEndpoints`
  - [x] `StockEndpoints`
  - [x] `MovimientosInventarioController`

- [x] **Esquema: ventas** (Orden: 6/8)
  - [x] `CajaEndpoints`
  - [x] `VentaEndpoints`
  - [x] `CotizacionEndpoints`

- [x] **Esquema: contabilidad** (Orden: 7/8)
  - [x] `PlanCuentaEndpoints`
  - [x] `CentroCostoEndpoints`

- [x] **Esquema: identidad** (Orden: 8/8)
  - [x] `UsuarioEndpoints`
  - [x] `RolEndpoints`
  - [x] `PermisoEndpoints`

---

## ✅ Fase de Endpoints Completada

Todos los esquemas han sido implementados con sus respectivos endpoints:

- ✅ catalogo
- ✅ clientes
- ✅ compras
- ✅ configuracion
- ✅ inventario
- ✅ ventas
- ✅ contabilidad
- ✅ identidad

---

## 📊 Resumen de Catálogos Implementados

| ID  | Código                     | Categoría                      | Valores |
| --- | -------------------------- | ------------------------------ | ------- |
| 1   | TIPO_DOCUMENTO             | Tipos de Documento             | 4       |
| 2   | TIPO_COMPROBANTE           | Tipos de Comprobante           | 4       |
| 3   | TIPO_CLIENTE               | Tipos de Cliente               | 3       |
| 4   | TIPO_MOVIMIENTO_CAJA       | Tipos de Movimiento Caja       | 4       |
| 5   | TIPO_PRODUCTO              | Tipos de Producto              | 3       |
| 6   | TIPO_MOVIMIENTO_INVENTARIO | Tipos de Movimiento Inventario | 5       |
| 7   | TIPO_CUENTA_CONTABLE       | Tipos de Cuenta Contable       | 5       |
| 8   | ESTADO_VENTA               | Estados de Venta               | 3       |
| 9   | ESTADO_COTIZACION          | Estados de Cotización          | 5       |
| 10  | ESTADO_CAJA                | Estados de Caja                | 2       |
| 11  | ESTADO_ORDEN_COMPRA        | Estados de Orden Compra        | 4       |
| 12  | ESTADO_ASIENTO             | Estados de Asiento             | 3       |
| 13  | ESTADO_PAGO                | Estados de Pago                | 5       |

**Total: 13 categorías, 50 valores**

---

## Fase 8: Hoja de Ruta Desarrollo Frontend 🎨 (NUEVO)

### 1. Módulo de Catálogo (Finalización) - **COMPLETO**

- [x] Implementar Mantenimiento de Categorías (Lista/Formulario)
- [x] Implementar Mantenimiento de Marcas (Lista/Formulario)
- [ ] Mejorar Tabla de Productos (Filtros, Paginación)

### 2. Módulo de Compras

- [x] Implementar Gestión de Proveedores
- [x] Crear Formulario de Compra (Ingreso de Mercadería)
- [x] Lista de Compras Realizadas

### 3. Módulo de Inventario

- [x] Implementar Gestión de Almacenes
- [ ] Visualizar Stock Actual
- [ ] Visualización de Movimientos de Inventario
- [ ] Reporte de Kardex de Producto

### 4. Módulo de Clientes

- [ ] Directorio de Clientes (CRUD)
- [ ] Historial de Ventas por Cliente

### 5. Módulo de Ventas (POS & Gestión)

- [ ] Finalizar Punto de Venta (POS) - Integración Total
- [ ] Gestión de Ventas (Anulación, Reimpresión)
- [x] Gestión de Marcas
- [x] Gestión de Unidades de Medida
- [x] Gestión de Listas de Precios
- [ ] Gestión de Variantes de Producto (Opcional)

### 6. Configuración e Identidad - **EN PROGRESO**

- [x] **Tablas Generales (Catálogos)**
  - [x] CRUD de Tablas Generales (Maestro)
  - [x] CRUD de Detalles (Valores)
- [x] **Empresa** (Gestión de Datos Corporativos - Registro Único)
  - [x] Backend Endpoints
  - [x] Frontend Página y Servicios
- [x] **Sucursales** (CRUD de Establecimientos)
  - [x] Backend (Repository DELETE y Endpoints CRUD completo)
  - [x] Frontend (Tipos, Servicios, Hooks, UI)
- [x] **Impuestos** (CRUD de Tasas: IGV, IVA, etc.)
  - [x] Backend (CRUD Completo)
  - [x] Frontend (Tipos, Servicios, Hooks, UI)
- [x] **Métodos de Pago** (CRUD Efectivo, Tarjeta, etc.)
  - [x] Backend (CRUD Completo)
  - [x] Frontend (Tipos, Servicios, Hooks, UI)
- [x] **Series y Tipos de Comprobante** (CRUD Numeración Facturación)
  - [x] Backend (Tipos + Series, integración Kardex)
  - [x] Frontend (Gestión Unificada con Tabs)
- [ ] **Gestión de Usuarios y Permisos** (Identidad)

---

**Última actualización**: 2026-01-28  
**Estado general**: 🔵 Desarrollo de Frontend iniciado conforme a hoja de ruta
