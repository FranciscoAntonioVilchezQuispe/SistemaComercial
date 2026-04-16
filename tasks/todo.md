# Registro de Tareas — Sistema Comercial

> [!IMPORTANT]
> Este archivo es acumulativo. NUNCA borrar sesiones anteriores.
> Las nuevas sesiones se agregan al final del archivo.

---
## Sesiones Previas (Resumen según Historial)
- [x] Sincronización y Normalización del Kardex (2026-04-12)
- [x] Ordenamiento Cronológico Permanente (2026-04-12)
- [x] Secuencialidad y Formateo de Kardex (2026-04-12)
- [x] Corrección de Ventana Horaria Estricta (2026-04-12)
- [x] Corrección de Códigos SUNAT e Impacto de Notas (2026-04-12)
- [x] Valorización de NC al Costo Promedio (2026-04-12)

---
## Sesión 2026-04-12 — Corrección Vista Previa Venta
- [x] Investigar campos faltantes en DB y DTOs
- [x] Definir cambios en Backend y Frontend
- [x] Actualizar `VentaDetalleDto.cs` (DireccionCliente)
- [x] Modificar `VentaRepositorio.cs` (SQL & COALESCE)
- [x] Actualizar tipos en Frontend (`ventas.types.ts`)
- [x] Corregir `ModalVistaPreviaVenta.tsx` (SUNAT & Cliente)
- [x] Verificación final de la visualización

---
## Sesión 2026-04-12 — Restauración de Reglas y Blindaje de Historial
- [x] Restaurar protocolos de gestión de sesiones en `GEMINI.md`
- [x] Blindar archivos de `tasks/` contra sobrescritura en `GEMINI.md`
- [x] Re-formatear `todo.md` como registro acumulativo
- [ ] Generar walkthrough final

---
## Sesión 2026-04-13 — Corrección de Cálculos en Guardado de Venta
- [x] Investigar lógica de cálculo en `CrearVentaManejador.cs`
- [x] Corregir asunción de "Precio con IGV" vs "Precio sin IGV"
- [x] Validar acumulación de Subtotal, IGV y Total
- [x] Verificar mapeo de columnas en la entidad `Venta`
- [x] Pruebas de guardado y validación de resultados

---
## Sesión 2026-04-12 — Implementación de Tablas Maestras SUNAT (CRUD)
- [x] Crear entidad `TipoAfectacionIgv` y `TipoTributo` (Backend)
- [x] Implementar repositorios y endpoints Minimal API
- [x] Desarrollar interfaz de usuario CRUD en el frontend
- [x] Implementar sistema de inicialización automática de códigos SUNAT
- [x] Registrar rutas y menú de navegación
- [x] Generar documentación y walkthrough

---
## Sesión 2026-04-12 — Corrección de Componente Alert y Página de Tributos
- [x] Investigar error en `PaginaTiposTributo.tsx` (Componente `Alert` faltante)
- [x] Crear componente `Alert` faltante en `src/componentes/ui/alert.tsx`
- [x] Verificar importación y renderizado en `PaginaTiposTributo.tsx`
- [x] Verificar importación en `PaginaAfectacionIgv.tsx`
- [x] Generar historial y walkthrough de la sesión

---
## Sesión 2026-04-12 — Integración SUNAT en Catálogo de Productos
- [x] Actualizar entidad `Producto.cs` con campos `IdTipoAfectacionIgv` e `IdTipoTributo`
- [x] Configurar mapeo EF Core en `CatalogoConfiguracion.cs`
- [x] Actualizar DTOs de Lista y Detalle (`ProductoDto`, `ProductoListDto`, `ProductoDetalleDto`)
- [x] Sincronizar consultas Dapper en `ProductoRepositorio.cs` con JOINS hacia esquema `configuracion`
- [x] Crear y aplicar migración robusta `AsociacionSunatProducto` (con blindaje contra errores de constraints)
- [x] Actualizar tipos de frontend en `catalogo.types.ts`
- [x] Integrar selectores de SUNAT en `ProductoForm.tsx` con lógica de autoselección
- [x] Verificación de compilación y persistencia de datos

---
## Sesión 2026-04-12 — Corrección de Mapeo SUNAT en Ventas
- [x] Investigar causa raíz del error 42703 en logs de ventas
- [x] Corregir mapeo de `TipoAfectacionIgvRef` (id -> id_afectacion)
- [x] Implementar `TipoTributoRef` para completar soporte fiscal
- [x] Actualizar `VentasDbContext` con nuevas referencias
- [x] Verificar compilación de la solución

---
## Sesión 2026-04-13 — Estandarización Global de Fechas (Backend + Frontend)
- [x] Diseñar arquitectura centralizada de fechas (Peru Time UTC-5)
- [x] Implementar `DateTimeConstants` y `DateTimeHelper` en `Nucleo.Comun`
- [x] Crear utilidad `datetime.ts` en Frontend
- [x] Implementar componente `DatePicker` unificado
- [x] Refactorizar microservicios para eliminar `DateTime.UtcNow` directo
- [x] Refactorizar frontend para eliminar `new Date()` y formatos hardcodeados
- [x] Configurar ESLint v9 restrictivo (Prohibir new Date())
- [x] Verificación final cross-layer

---
## Sesión 2026-04-13 — Auditoría y Estandarización Global (Variables y Constantes)
- [x] Análisis exhaustivo de hardcoding en la solución (18.00m, localhost:5000)
- [x] Centralización Fiscal: Crear FiscalConstants (BE) y fiscal.config (FE)
- [x] Refactorizar cálculos de IGV en microservicios y formularios web
- [x] Configuración de Red: Implementar .env y refactorizar axios.ts con Vite
- [x] Auditoría Centralizada: Implementar DbContextAuditHelper en Nucleo.Comun
- [x] Refactorizar todos los DbContext para usar auditoría automática
- [x] Limpieza Masiva: Eliminar UtcNow manual en Endpoints y Repositorios
- [x] Verificación final e informes (Walkthrough y Task finalizados)

---
## Sesión 2026-04-13 — Estabilización Final y Compilación Total
- [x] Ejecutar `dotnet build` global y corregir errores de sintaxis y namespaces
- [x] Resolver advertencias de TypeScript en Frontend (`tsc`)
- [x] Corregir desajustes de interfaces y modelos (`VentaResumen`, `ClienteResumen`)
- [x] Refactorizar componente `DatePicker` con soporte para `disabled`
- [x] Limpiar importaciones y variables obsoletas en toda la solución
- [x] Validar compilación exitosa (0 errores BE / tsc exitoso FE)
- [x] Actualizar documentación de Skill y Reglas Globales (GÈMINI.md)

---
## Sesión 2026-04-13 — Implementación de Notas de Crédito y Débito (Compras y Ventas)
- [x] Backend: Ventas.API - Endpoints de Detalle (GET /api/notas/credito/{id})
- [x] Backend: Ventas.API - Refactorizar CrearNotaDebitoManejador
- [x] Backend: Compras.API - Listado de Notas (GET /api/compras/notas)
- [x] Backend: Compras.API - Endpoints de Detalle (GET /api/compras/notas/credito/{id})
- [x] Backend: Compras.API - Refactorizar CrearNotaCreditoCompraManejador
- [x] Backend: Compras.API - Refactorizar CrearNotaDebitoCompraManejador
- [x] Frontend: Componente VistaPreviaNotaSunat (Shared)
- [x] Frontend: Ventas - Integración de Detalles en PaginaNotas
- [x] Frontend: Compras - Servicio de Notas y PaginaNotasCompra
- [x] Frontend: Navegación y Rutas para Compras
- [x] Verificación de flujo completo y refactorización de cálculos

---
## Sesión 2026-04-15 — Análisis de Páginas del Módulo de Inventario
- [x] Analizar `PaginaKardexPeriodos.tsx`
- [x] Analizar `PaginaKardexReporte.tsx`
- [x] Analizar `PaginaMovimientos.tsx`
- [x] Analizar `PaginaStock.tsx`
- [x] Analizar `PaginaTraslados.tsx`
- [x] Presentar explicación detallada al usuario

---
## Sesión 2026-04-15 — Implementación del Módulo de Reportes (Fase 1)
- [x] Planificar arquitectura del módulo de reportes
- [x] Crear Hub de Reportes en el Frontend
- [x] Fase 4: Reportes de Compras (Proveedores)
    - [x] Backend: Implementar `ObtenerComprasPorProveedorAsync` en `CompraRepositorio` (Compras.API)
    - [x] Backend: Exponer endpoint en `ReportesComprasEndpoints`
    - [x] Frontend: Crear hook `useReporteComprasProveedor`
    - [x] Frontend: Implementar `PaginaReporteComprasProveedor`
    - [x] Frontend: Registrar rutas y actualizar `PaginaReportesHub`
- [x] Implementar Reporte de Stock Crítico (Inventario)
- [x] Implementar Reporte de Ranking de Productos (Ventas)
- [x] Implementar Reporte de Top Clientes (Ventas)
- [x] Corrección de errores de compilación backend y frontend
- [x] Verificación de integridad total (Backend Build / Frontend Build)
- [x] Generar walkthrough y actualizar historial
- [x] Implementar Exportación a Excel en los Reportes
    - [x] Instalar dependencia `xlsx`
    - [x] Actualizar componente `ExportadorTabla.tsx` con soporte Excel
    - [x] Integrar exportador en los reportes de Ventas e Inventario
    - [x] Verificar funcionamiento y compilación

---
## Sesión 2026-04-16 — Limpieza y Unificación de Scripts de Base de Datos
- [x] Analizar y clasificar todos los archivos `.sql` en `Codigo\BaseDeDatos\Scripts`
- [x] Identificar scripts redundantes y candidatos a eliminación
- [x] Unificar scripts de evolución recientes (15, 16, 17) en un nuevo script secuencial (03)
- [x] Organizar herramientas de verificación en una carpeta de `mantenimiento/`
- [x] Normalizar codificación UTF-8 de los archivos esenciales
- [x] Actualizar la guía maestra `SCRIPTS_GUIDE.md`
- [x] Ejecutar la limpieza (eliminación y movimiento de archivos)
- [x] Generar reporte final de la estructura de base de datos

---
## Sesión 2026-04-16 — Implementación de Autenticación JWT y Módulo Vendedor
### Fase 1: Identidad.API (JWT)
- [x] Crear comandos y manejadores de Login y Refresh.
- [x] Entidad RefreshToken e infraestructura JWT.
- [x] Endpoints Minimal API (AuthEndpoints).

### Fase 2: Gateway.API (Enforcement)
- [x] Middleware YARP JWT y headers enrutamiento (`X-User-Id`, `X-User-Roles`).

### Fase 3: Ventas.API (Turnos y Caja)
- [x] Crear entidades TurnoVendedor y CierreTurno.
- [x] Actualizar `Venta` vinculando `TurnoVendedorId`.
- [x] Migración de base de datos en EF Core.
- [x] Comandos y Query para abrir, cerrar y visualizar el turno actual.

### Fase 4: Frontend (Auth y Vendedor)
- [ ] Feature Auth (Token, Context, Redirects).
- [ ] Feature Vendedor, layouts y protegido.
- [ ] Rutas separadas y controladas.

### Fase 5: Identidad.API (Administración)
- [ ] CRUD y gestión de Roles, Usuarios y Trabajadores.
---
## Sesión 2026-04-16 — Estabilización del Módulo de Identidad
- [x] Corregir enrutamiento en Gateway.API (YARP) para `/api/auth/`
- [x] Refactorizar `LoginManejador` y `RefreshTokenManejador` para usar `IToReturn`
- [x] Estandarizar respuestas en `AuthEndpoints.cs` (códigos 401, 200, 500)
- [x] Sincronizar esquema de base de datos (Creación manual de `identidad.refresh_tokens`)
- [x] Resetear contraseña de administrador a `Admin123!`
- [x] Verificar flujo completo de login (Exitosa obtención de JWT y Refresh Token)
- [x] Actualizar `authService.ts` en frontend para manejar el wrapper de respuesta
- [x] Generar walkthrough y documentación de la sesión
---
## Sesión 2026-04-16 — Sincronización de Autenticación y Corrección de Error 401
- [x] Identificar desajuste de `Issuer` y `Audience` en JWT
- [x] Alinear configuración de JWT en `Identidad.API` y `Gateway.API`
- [x] Refactorizar middleware de Gateway para devolver JSON (Corrección error parsing XML)
- [x] Verificar acceso exitoso a `/api/usuarios` con token válido
- [x] Generar walkthrough y actualizar historial

---
## Sesión 2026-04-16 — Reestructuración de Identidad y Autorización Granular
- [x] Establecer relación obligatoria 1:1 Usuario-Trabajador (DB e Infra)
- [x] Refactorizar `CrearUsuarioCommand` con validación de personal vinculable
- [x] Implementar sistema de permisos granulares (MENU:ACCION)
- [x] Actualizar Gateway con middleware de autorización dinámica y granular
- [x] Desarrollar Matriz de Permisos en el Frontend (Menus vs Tipos)
- [x] Implementar Diálogo de Creación de Usuario con selector de trabajador
- [x] Corregir flujo de JWT para incluir reclamaciones de permisos aplanados
- [x] Verificar compilación total de la solución (0 errores)
- [x] Generar documentación, historial y walkthrough de la sesión
