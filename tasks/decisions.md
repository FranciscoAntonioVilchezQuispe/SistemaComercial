# 🏛️ Decisiones Arquitectónicas

## [2026-03-27] Estándar de Respuesta Paginada
- **Contexto**: El backend devolvía listas planas e inconsistentes.
- **Decisión**: Estandarizar todas las listas paginadas a un objeto `PagedResponse<T>` que contenga `{ datos: T[], total: number, pageNumber: int, pageSize: int }`.
- **Justificación**: Facilita la implementación de la paginación en el servidor y optimiza la carga del frontend `DataTable`.

## [2026-03-27] Reversión de Stock en Eliminación
- **Contexto**: La eliminación de compras solo restaba cantidad.
- **Decisión**: Implementar reversión completa de `CantidadActual`, `ValorTotal` y `CostoPromedio` en la tabla `inventario.stock`.
- **Justificación**: Evitar descuadres entre inventario físico y valorizado contable.

## [2026-03-27] DB-001: Estrategia de Migraciones "Nucleares"
- **Contexto**: `DbContextModelSnapshot` desincronizado con base de datos manual (`sucursal` vs `sucursales`).
- **Decisión**: Usar bloques PL/pgSQL dinámicos en las migraciones para limpiar restricciones de nombre desconocido antes de aplicar las de EF Core.
- **Consecuencia**: Mayor resiliencia ante esquemas externos alterados.

## [2026-03-27] DB-002: Aislamiento de Historial por Esquema
- **Contexto**: Los microservicios de `Clientes` y `Compras` compartían el historial global de EF Core, causando errores de "Relación ya existe".
- **Decisión**: Configurar `UseNpgsql(..., o => o.MigrationsHistoryTable("__ef_migrations_history", "esquema"))` en `Program.cs`.
- **Justificación**: Aislamiento total de migraciones por dominio funcional, permitiendo despliegues independientes a pesar de compartir una misma base de datos.

## [2026-03-27] DB-003: Sincronización mediante Baselining
- **Contexto**: EF Core intentaba recrear tablas existentes en `Clientes` y `Compras` debido a desincronización de snapshots.
- **Decisión**: Vaciar los métodos `Up()` de las migraciones iniciales y registrar manualmente el ID en el historial.
- **Justificación**: Es la forma más limpia de estabilizar el flujo de migraciones sin borrar datos existentes en PostgreSQL.

## [2026-03-27] FE-001: Consolidación de Alias de Configuración
- **Contexto**: Importaciones rotas entre `src/configuracion` y `src/features/configuracion`.
- **Decisión**: Alias `@configuracion` exclusivamente para `src/configuracion/` y `@features/configuracion` para el módulo específico. Prohibido el uso de rutas relativas de más de 2 niveles.
- **Consecuencia**: Claridad en la procedencia de servicios y hooks compartidos.

## [2026-03-27] FE-002: Normalización SUNAT UBL 2.1
- **Contexto**: Los perfiles de Clientes y Proveedores carecían de campos técnicos obligatorios.
- **Decisión**: Implementar sección "Información SUNAT" unificada en el frontend (React) con validaciones Zod y tipado estricto.
- **Justificación**: Cumplimiento normativo y mejora de la calidad de datos maestros.
