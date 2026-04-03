# 📖 Lecciones Aprendidas

## [2026-03-27] Estandarización de Paginación
- **Patrón**: Al migrar a `PagedResponse<T>`, el frontend DEBE acceder a la propiedad `.datos` del objeto de respuesta. Intentar mapear directamente sobre la respuesta causará un `TypeError`.
- **Prevención**: Usar el patrón `response.datos || response.data || []` en servicios compartidos para asegurar compatibilidad mientras se completa la migración de todos los microservicios.

## [2026-03-27] Backend - EF Core & Migraciones "Nucleares"
- **Desafío**: Las migraciones fallan si existen restricciones físicas con nombres distintos a los esperados por EF Core (ej: DB creada manualmente).
- **Lección**: Usar bloques `DO $$ ... END $$` (PostgreSQL) para buscar dinámicamente nombres de PKs/FKs en `pg_constraint` y eliminarlas antes de intentar recrearlas. Esto garantiza resiliencia en entornos "sucios".

## [2026-03-27] Frontend - Vite & Módulos
- **Importaciones Dinámicas**: El error `TypeError: error loading dynamically imported module` suele ocultar fallos de sintaxis JSX (ej: etiquetas `div` sin cerrar). Un `npx tsc --noEmit` es el mejor diagnóstico.
- **Alias y Rutas**: Preferir alias absolutos (`@configuracion/...`) sobre rutas relativas profundas para evitar errores de resolución en el servidor de desarrollo cuando la arquitectura de carpetas es compleja.

## [2026-03-27] Integridad en Eliminación de Registros
- **Stock**: Eliminar una compra requiere revertir la `CantidadActual` y actualizar el `ValorTotal` / `CostoPromedio` en el Inventario para mantener consistencia contable.
- **Kardex**: Toda eliminación de movimiento físico debe acompañarse de la anulación del registro en el Kardex Valorizado.

## [2026-03-27] PostgreSQL - Conflictos de Esquema y Vistas
- **Historial de Migraciones**: En entornos multiesquema (Clientes, Compras, etc.), es CRÍTICO configurar `MigrationsHistoryTable("__ef_migrations_history", "nombre_esquema")` en `Program.cs`. De lo contrario, los microservicios colisionarán al intentar crear la tabla global en el esquema público o intentarán recrearlas si ya existen.
- **Dependencia de Vistas**: PostgreSQL (Error `0A000`) NO permite alterar el tipo de dato (`AlterColumn`) de una columna si ésta es utilizada por una `VIEW` o `MATERIALIZED VIEW`. 
    - **Solución Elegante**: Si el cambio de tipo no es crítico, omitir la instrucción `AlterColumn` de la migración. Si es obligatorio, la migración debe orquestar el `DROP VIEW CASCADE`, realizar el cambio, y luego recrear la vista.
- **Estrategia Baselining**: Cuando una base de datos ya tiene tablas creadas y EF Core intenta recrearlas, la solución más limpia es vaciar el método `Up()` de las migraciones iniciales y marcar manualmente la migración como aplicada en el historial.

## [2026-03-27] PostgreSQL - Herencia y Restricciones de Columna
- **Herencia de EntidadBase**: Al usar `EF Core` con una clase base (ej: `EntidadBase` con `Id`), si la entidad hija sobrescribe el `Id` (ej: `Ubigeo` con `Codigo` como PK), la columna `Id` del padre sigue existiendo en el esquema de la tabla de PostgreSQL como una columna física obligatoria (`NOT NULL`).
- **Error 23502**: Ocurre al cargar datos manualmente (Scripts SQL) sin incluir la columna `Id` mapeada. **Solución**: Incluir siempre el valor numérico incremental en el `INSERT` para satisfacer la restricción de integridad del esquema heredado.

## [2026-03-27] Scripts SQL - Codificación y PowerShell
- **UTF-16 vs UTF-8**: Scripts generados por ciertas herramientas de exportación (como `full_script.sql`) pueden venir en `UTF-16LE` (Unicode), lo que causa errores de lectura en herramientas estándar.
- **Conversión**: Usar `Get-Content -Encoding Unicode | Out-File -Encoding utf8` para normalizar los archivos antes de intentar unificarlos o leerlos programáticamente.

## [2026-03-28] Edición Masiva de Código y Sintaxis JSX
- **Peligro**: Al usar herramientas de edición masiva (como `multi_replace_file_content` o `replace_file_content`), incluir inadvertidamente números de línea o fragmentos mal cerrados rompe la estructura del árbol de componentes de React.
- **Lección**: Siempre realizar una limpieza de los fragmentos a reemplazar, asegurando que no contengan metadatos de la herramienta de visualización (`view_file`).
- **Verificación**: Ejecutar `npx tsc --noEmit` inmediatamente después de cambios estructurales en el frontend para identificar errores de anidamiento (`JSX element ... has no corresponding closing tag`) antes de que se propaguen.

## [2026-03-28] Estabilización de Base de Datos y Enums
- **Magic Numbers**: El uso de IDs hardcodeados (ej: `IdEstadoPago = 40`) es extremadamente frágil. En este proyecto, los IDs del backend no coincidían con los de la semilla de la BD (donde `Pendiente` era 49). 
- **Solución**: Centralizar todos los estados en Enums dentro de `Nucleo.Comun.Domain` para garantizar una única fuente de verdad tipada.
- **Esquemas de Detalle**: Las tablas de detalle (ej: `detalle_venta`) deben incluir siempre columnas de auditoría (`activado`, `fecha_creacion`) si la entidad hereda de `EntidadBase`. De lo contrario, EF Core fallará al intentar mapear o insertar estos campos obligatorios.

## [2026-03-28] Normalización UTC — ValueConverters vs SaveChangesAsync
- **Patrón anterior**: Interceptar `SaveChangesAsync` y recorrer recursivamente todas las propiedades `DateTime` era funcional pero frágil.
- **Patrón definitivo**: Usar `ConfigureConventions` con `ValueConverter<DateTime, DateTime>` para normalizar automáticamente DateTimeKind.Utc en **todos** los DbContexts. Es global, no invasivo y no requiere lógica manual por entidad.

## [2026-03-29] Estabilización Global de Esquema
- **Desafío**: Múltiples tablas en esquemas `ventas`, `catalogo`, `inventario` y `contabilidad` fueron creadas manualmente sin las columnas de auditoría (`fecha_modificacion`, `usuario_modificacion`). Esto causaba errores de persistencia en el backend debido al contrato de `EntidadBase`.
- **Lección**: La herencia en el backend DEBE ser replicada fielmente en la base de datos física. Un script dinámico que recorra todos los esquemas de negocio es la forma más eficiente de estabilizar un sistema con desincronización de esquemas.
- **Herramienta**: Usar bloques `DO $$ ... END $$` con `information_schema` garantiza que la corrección sea idempotente y segura para producción.

## [2026-03-29] Frontend - Estabilización de UI y Sincronización de Enums
- **Datos Inconsistentes**: El uso de utilidades de formateo robustas en `fecha.ts` y `moneda.ts` (manejando `NaN`, `null` y `undefined`) es CRÍTICO para evitar que la UI "explote" ante datos de BD incompletos o mal calculados.
- **DataTable & Tipado**: Exportar la interfaz `DataTableColumn<T>` desde el componente base permite un tipado estricto en el consumidor. Sin esto, TypeScript infiere `accessorKey` como `string` genérico, rompiendo la seguridad de tipos de la tabla.
- **Sincronización de Enums**: Los IDs de los enums en el Frontend (ej. `EstadoVenta.Completada = 29`) DEBEN ser copias exactas de los Enums del Backend (Domain). Usar IDs genéricos (1, 2, 3) es una trampa de mantenimiento que causa que los colores de los Badges o la lógica de negocio fallen de forma silenciosa.
- **Propiedades de API**: Al refactorizar interfaces de API (ej. `Venta`), se debe realizar un barrido completo de componentes auxiliares (`Modales`, `Buscadores`) para actualizar los nombres de propiedades (`fecha` -> `fechaEmision`). Ignorar esto deja el sistema en un estado de "error en cascada".

## [2026-03-30] Consolidación de Tablas entre Esquemas
- **Problema**: La tabla `metodos_pago` existía duplicada en los esquemas `ventas` y `configuracion`, con estructuras y datos divergentes.
- **Lección**: Las entidades de catálogo compartido (métodos de pago, tipos de documento, monedas) deben vivir EXCLUSIVAMENTE en el esquema `configuracion`. Los microservicios consumidores (Ventas, Compras) las referencian con `ExcludeFromMigrations()` en su DbContext.
- **Patrón de migración**: Al consolidar una tabla entre esquemas, el flujo correcto es:
  1. Crear la tabla destino (migración EF Core o `CREATE TABLE`).
  2. Insertar datos semilla en la nueva tabla.
  3. Actualizar FKs existentes en tablas dependientes (mapear IDs por código, no por valor numérico).
  4. Eliminar la tabla legacy con `DROP TABLE ... CASCADE`.
- **Error común con EF Core**: Si la tabla original nunca existió físicamente en el esquema esperado, `RenameTable` falla con `42P01`. En esos casos, sustituir manualmente por `CreateTable` en el archivo `.cs` de la migración.
- **Prevención**: Antes de crear una tabla nueva, SIEMPRE verificar que no exista una equivalente en otro esquema. El principio es: **una tabla, un esquema, una fuente de verdad**.

## [2026-03-30] Auditoría UBL 2.1 — Hallazgos en Notas de Crédito/Débito
- **Cálculos en frontend**: El handler `CrearNotaCreditoManejador.cs` acepta `subtotal`, `igv` y `total` directamente del DTO del frontend sin recalcular ni validar. Esto viola la regla de GEMINI.md de "cálculos en backend, nunca en frontend". Se detectó además un **bug**: `subtotal` y `total` usan el mismo campo (`d.totalItem`), resultando en valores idénticos.
- **Numeración insegura**: NC/ND aceptan `numero` del DTO frontend (`Numero = dto.Numero`) sin correlativo automático. Difiere del patrón correcto de `ventas.ventas` que usa `ObtenerSiguienteCorrelativoAsync`.
- **Datos del cliente no validados**: El handler copia `ClienteTipoDoc/NroDoc/RazonSocial` del DTO del frontend en vez de la venta referenciada. Esto permite datos manipulados.
- **FK sin constraint**: `id_tipo_nota` en ambas tablas NC/ND es un `bigint NOT NULL` sin `REFERENCES` declarado en el DDL. No hay integridad referencial.
- **Sin efecto en venta**: Al crear una NC de anulación total (tipo 01/06), el handler NO actualiza `id_estado`, `fecha_anulacion` ni `saldo_pendiente` de la venta referenciada.
- **IGV hardcodeado**: Valor `18.00m` como default en entidades `NotaCredito.cs:L77` y `NotaDebito.cs:L77`.
- **Motivos parciales en frontend**: `ModalCrearNotaSunat.tsx` solo muestra 3/13 motivos NC y 2/6 ND, aunque el enum tiene todos los valores definidos.
- **Lección general**: Al auditar un módulo para cumplimiento normativo, revisar **handlers + entidades + DDL + frontend** como un todo integral. Los problemas no se limitan a una capa.

## [2026-03-30] Investigación de Catálogos SUNAT — Reutilización vs Creación
- **Hallazgo**: Antes de crear tablas nuevas para catálogos SUNAT, siempre verificar las existentes. En este proyecto:
  - `configuracion.tipo_afectacion_igv` ya cubre Cat.07 (21 registros completos).
  - `configuracion.tipo_operacion_sunat` ya cubre Cat.51 (21 registros).
  - `catalogo.unidades_medida` ya cubre Cat.03 (10 registros, faltan 4 menores).
  - `configuracion.impuestos` ya cubre Cat.05 parcialmente (falta 9995 y 9999).
  - `configuracion.motivo_nota_credito` ya cubre Cat.09 (13 registros completos).
  - `configuracion.motivo_nota_debito` ya cubre Cat.10 (6 registros completos).
- **Principio**: Solo crear tablas en el schema `sunat` para entidades genuinamente nuevas (no cubiertas): `cat_estado_cpe`, `log_envio_cpe`.
- **Consistencia de nombres**: Cuando una columna existe en múltiples tablas con nombres distintos (`codigo_hash_cdr` vs `hash_cdr`), estandarizar al nombre más corto y claro (`hash_cdr`) en todas las tablas.
