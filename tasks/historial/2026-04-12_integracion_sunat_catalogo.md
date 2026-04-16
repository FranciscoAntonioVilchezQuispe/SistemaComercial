# Historial de Sesión — 2026-04-12

## Objetivo
Integrar los maestros de SUNAT (Afectación IGV y Tipos de Tributo) con la entidad `Producto` en el esquema de Catálogo, permitiendo una configuración fiscal robusta y automatizada según el estándar UBL 2.1.

## Cambios Realizados

### Backend (.NET Core)
1.  **Entidades**: 
    - Se agregaron `IdTipoAfectacionIgv` e `IdTipoTributo` a la entidad `Producto.cs`.
2.  **Infraestructura**:
    - Se mapearon las nuevas columnas en `CatalogoConfiguracion.cs`.
    - Se actualizó `ProductoRepositorio.cs` para incluir los `JOINs` hacia el esquema `configuracion` en las consultas de detalle y listado paginado.
3.  **DTOs**:
    - Se actualizaron `ProductoDto`, `ProductoListDto` y `ProductoDetalleDto` para exponer los nuevos campos fiscales.
4.  **Base de Datos**:
    - Generación y aplicación de la migración `AsociacionSunatProducto`.
    - Se aplicó "blindaje" en el script de migración usando `DROP CONSTRAINT IF EXISTS` y `DROP INDEX IF EXISTS` para evitar fallos por inconsistencias en los nombres automáticos de PostgreSQL.

### Frontend (React + TS)
1.  **Tipos**:
    - Se actualizaron las interfaces de `ProductoResumen`, `ProductoDetalle` y `ProductoFormData` en `catalogo.types.ts`.
2.  **Componentes**:
    - `ProductoForm.tsx`: Se agregaron los selectores de **Afectación IGV** y **Tipo de Tributo**.
    - Se implementó lógica de autoselección: al marcar "Gravado", el sistema preselecciona automáticamente el código "10" (Gravado) y el tributo "1000" (IGV).
3.  **Hooks**:
    - Integración de `useAfectacionesIgv` y `useTiposTributo`.

## Lecciones Aprendidas
- **Migraciones en PostgreSQL**: Los nombres físicos de las restricciones (PK/FK) y los índices pueden variar respecto al snapshot de EF Core si hubo refactorizaciones previas. Es vital usar bloques `Sql` con validaciones de existencia (`IF EXISTS`) para asegurar que la migración se aplique sin errores.
- **Dapper & Schemas**: Al realizar joins entre esquemas (ej: `catalogo` y `configuracion`), se debe asegurar que el usuario de base de datos tenga los permisos necesarios y especificar siempre el nombre completo del esquema.

## Verificación
- Compilación exitosa del backend.
- Migración aplicada sin errores tras el blindaje.
- El formulario de productos en el frontend refleja correctamente los catálogos de SUNAT.
