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

## [2026-03-28] BE-001: Enums Centralizados para Estados de Dominio
- **Contexto**: Los microservicios de Ventas e Inventario utilizaban "Magic Numbers" inconsistentes con la base de datos.
- **Decisión**: Crear una jerarquía de Enums en `Nucleo.Comun.Domain` para todos los catálogos compartidos (Tablas Generales).
- **Justificación**: Garantiza una única fuente de verdad tipada, elimina errores de "ID no encontrado" y facilita el mantenimiento global.

## [2026-03-28] BE-002: Normalización Recursiva de Fechas UTC
- **Contexto**: Errores persistentes de Npgsql (`DateTimeKind.Unspecified`) en campos de fecha que no heredaban de `EntidadBase`.
- **Decisión**: Refactorizar el interceptor de `SaveChangesAsync` en los DbContexts para recorrer recursivamente todas las propiedades `DateTime`/`DateTime?` de todas las entidades rastreadas.
- **Justificación**: Solución definitiva "fire-and-forget" para la compatibilidad de zonas horarias en PostgreSQL sin requerir mapeos manuales por cada propiedad.

## [2026-03-29] BE-003: Auditoría Global Obligatoria en Base de Datos
- **Contexto**: El modelo de datos heredado de `EntidadBase` en .NET requiere campos de auditoría que no siempre existían en las tablas creadas manualmente en PostgreSQL.
- **Decisión**: Forzar la existencia de `fecha_modificacion` y `usuario_modificacion` en todas las tablas de negocio de todos los esquemas mediante scripts de estabilización.
- **Justificación**: Evitar excepciones de persistencia (`DbUpdateException`) y garantizar trazabilidad de cambios en todas las entidades del sistema de forma uniforme.

## [2026-03-29] FE-003: Centralización de Enums Sincronizados
- [Contexto]: Diferentes componentes de ventas y compras utilizaban enums locales o valores "mágicos" (1, 2, 3) desincronizados del backend.
- [Decisión]: Mover todos los enums a `src/compartido/enums` y sincronizar sus IDs numéricos con los del Backend Domain.
- [Justificación]: Garantiza coherencia visual (Badges de colores) y lógica en todo el sistema. Elimina errores de visualización "muda" y simplifica el mantenimiento global ante cambios en el maestro de Tablas Generales.
- [Consecuencia]: Los componentes ahora dependen de un único contrato, reduciendo drásticamente la probabilidad de bugs por inconsistencia entre el Frontend y los microservicios.
