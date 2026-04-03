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

## [2026-03-28] BE-002: Normalización UTC con ValueConverters
- **Contexto**: Errores persistentes de Npgsql (`DateTimeKind.Unspecified`) en campos de fecha.
- **Decisión**: Implementar `ConfigureConventions` con `ValueConverter<DateTime, DateTime>` en todos los DbContexts en lugar de interceptar `SaveChangesAsync`.
- **Justificación**: Solución declarativa y no invasiva que se aplica automáticamente a todas las propiedades DateTime sin requerir recorrido recursivo manual.

## [2026-03-29] BE-003: Auditoría Global Obligatoria en Base de Datos
- **Contexto**: El modelo de datos heredado de `EntidadBase` en .NET requiere campos de auditoría que no siempre existían en las tablas creadas manualmente en PostgreSQL.
- **Decisión**: Forzar la existencia de `fecha_modificacion` y `usuario_modificacion` en todas las tablas de negocio de todos los esquemas mediante scripts de estabilización.
- **Justificación**: Evitar excepciones de persistencia (`DbUpdateException`) y garantizar trazabilidad de cambios en todas las entidades del sistema de forma uniforme.

## [2026-03-29] FE-003: Centralización de Enums Sincronizados
- **Contexto**: Diferentes componentes de ventas y compras utilizaban enums locales o valores "mágicos" desincronizados del backend.
- **Decisión**: Mover todos los enums a `src/compartido/enums` y sincronizar sus IDs numéricos con los del Backend Domain.
- **Justificación**: Garantiza coherencia visual (Badges de colores) y lógica en todo el sistema.
- **Consecuencia**: Los componentes ahora dependen de un único contrato, reduciendo drásticamente la probabilidad de bugs por inconsistencia entre el Frontend y los microservicios.

## [2026-03-30] DB-004: Consolidación de Tablas de Catálogo Compartido
- **Contexto**: La tabla `metodos_pago` existía en dos esquemas (`ventas` y `configuracion`) con datos y estructuras divergentes.
- **Decisión**: Unificar todas las tablas de catálogo compartido (métodos de pago, tipos de comprobante, etc.) exclusivamente en el esquema `configuracion`. Los microservicios consumidores usan `ExcludeFromMigrations()` para referenciar sin recrear.
- **Justificación**: Una sola fuente de verdad elimina inconsistencia de datos entre módulos y simplifica el mantenimiento de la base de datos.
- **Consecuencia**: Las consultas Dapper de otros microservicios deben usar explícitamente el prefijo `configuracion.` en sus JOINs. Las entidades de dominio del consumidor apuntan al esquema externo vía `[Table("tabla", Schema = "configuracion")]`.

## [2026-03-30] BE-004: Mapeos Explícitos de Tabla en ConfiguracionDbContext
- **Contexto**: EF Core generaba nombres de tabla automáticos que no coincidían con los nombres físicos en PostgreSQL, causando errores `42P01`.
- **Decisión**: Declarar explícitamente `.ToTable("nombre_tabla", "esquema")` para TODAS las entidades en `OnModelCreating`, sin depender de convenciones automáticas.
- **Justificación**: Control total sobre la identidad física de las tablas, previniendo errores silenciosos de mapeo cuando las convenciones de EF Core (pluralización, naming) difieren de las convenciones del esquema PostgreSQL existente.

## [2026-03-30] DB-005: Schema `sunat` — Solo para entidades genuinamente nuevas
- **Contexto**: El plan UBL 2.1 proponía crear múltiples tablas en un schema `sunat` nuevo, pero la investigación reveló que la mayoría de los catálogos requeridos ya existían en `configuracion` y `catalogo`.
- **Decisión**: Crear el schema `sunat` solo para `cat_estado_cpe` y `log_envio_cpe`. Reutilizar: `configuracion.tipo_afectacion_igv` (Cat.07), `configuracion.tipo_operacion_sunat` (Cat.51), `catalogo.unidades_medida` (Cat.03), `configuracion.impuestos` (Cat.05), `configuracion.motivo_nota_credito` (Cat.09), `configuracion.motivo_nota_debito` (Cat.10).
- **Justificación**: Evitar duplicación de datos y mantener integridad referencial con las FKs existentes en otras tablas.

## [2026-03-30] BE-005: Nombre estándar `hash_cdr` en todas las tablas
- **Contexto**: `ventas.nota_credito` y `ventas.nota_debito` usan la columna `hash_cdr`, pero el plan original de `ventas.ventas` proponía `codigo_hash_cdr`.
- **Decisión**: Usar `hash_cdr` como nombre estándar en todas las tablas (ventas, NC, ND).
- **Justificación**: Consistencia de nomenclatura entre tablas del mismo dominio. Un nombre más corto y descriptivo.

## [2026-03-30] BE-006: Refactor de handlers NC/ND en fase actual
- **Contexto**: La auditoría reveló 5 hallazgos críticos en `CrearNotaCreditoManejador.cs` y `CrearNotaDebitoManejador.cs`: cálculos desde frontend, numeración insegura, datos cliente no validados, sin validación de montos, sin efecto en venta referenciada.
- **Decisión**: Incluir el refactor completo de ambos handlers en la fase actual (UBL 2.1), no diferirlo a una fase posterior.
- **Justificación**: Los bugs encontrados representan riesgos de integridad de datos que se amplificarían si se agregan campos UBL sin corregir la lógica base. Corregir ahora evita deuda técnica compuesta.
- **Alcance del refactor**:
  1. Correlativo automático (como ventas).
  2. Cálculos de montos en backend (subtotal_gravado/exo/ina, igv, total).
  3. Datos del cliente desde la venta referenciada (no del DTO frontend).
  4. Validaciones: venta existe + estado correcto + monto NC ≤ total venta.
  5. Actualizar venta referenciada al crear NC tipo 01/06 (anulación).

## [2026-03-30] FE-004: Motivos NC/ND desde API, no hardcodeados
- **Contexto**: `ModalCrearNotaSunat.tsx` solo muestra 3 de 13 motivos de NC y 2 de 6 de ND, hardcodeados como `<SelectItem>` en el JSX.
- **Decisión**: Cargar los motivos dinámicamente desde la API de configuración (`configuracion.motivo_nota_credito/debito`) usando un hook dedicado `useMotivosNota`.
- **Justificación**: Mostrar todos los motivos disponibles, permitir que el administrador gestione el catálogo sin modificar código frontend, y mantener consistencia con el patrón de cargar catálogos dinámicamente (ya usado en tipo_comprobante, afectación IGV, etc.).
