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

## [2026-04-12] Sincronización Histórica de Kardex — Integridad y Mapeo
- **Mapeo Dapper (Tuplas vs Dynamic)**: El uso de ValueTuples `(long Id, ...)` en Dapper sin `MatchNamesWithUnderscores` es extremadamente frágil. Si los aliases SQL no coinciden exactamente (case-sensitive) o el orden varía, el mapeo falla silenciosamente devolviendo valores por defecto (`0`).
    - **Solución**: Preferir `QueryAsync<dynamic>` o clases DTO planas para lecturas de sistema.
- **Compilación - Orden de Argumentos**: En refactors de métodos con muchos parámetros (ej: `ProcesarDocumento`), es fácil trasponer argumentos del mismo tipo (`string` por `string`, `DateTime` por `DateTime`). C# no detectará el error lógico si los tipos coinciden, pero fallará la lógica de negocio.
    - **Prevención**: Usar argumentos nombrados (`idRef: n.Id, fecha: n.FechaEmision`) en llamadas críticas para mayor claridad y seguridad.
- **Integridad Referencial en Reconstrucciones**: Al reconstruir el Kardex desde tablas de integración (Compras/Ventas del ERP), SIEMPRE validar que los IDs secundarios (Almacén, Tipo Documento) existan en las tablas maestras del sistema actual.
    - **Patrón**: Implementar un remapeo de seguridad al **Almacén Principal** si el ID original es inválido o nulo. Esto evita errores `23503` (FK violation) que detienen procesos masivos de carga.
- **Validaciones de Stock en Sincronización**: Los métodos de creación de movimientos (`CrearMovimientoInventarioManejador`) suelen tener validaciones de stock insuficiente. Estas validaciones deben ser omitibles mediante un flag (`PermitirStockNegativo`) durante sincronizaciones históricas, ya que el historial puede contener baches temporales de stock que se regularizan al final del proceso.

## [2026-04-12] Ordenamiento Cronológico Permanente
- **Lógica Comercial**: En el Kardex Valorizado, el orden de los eventos dentro de un mismo día es crítico. Para evitar saldos negativos ficticios y cumplir con la trazabilidad de SUNAT, se debe seguir el orden: Ingresos (08:00) -> Notas de Ingreso (09:00) -> Salidas (10:00) -> Notas de Salida (11:00).
- **Centralización**: Esta lógica debe vivir en un servicio compartido (`IValidacionReglaSunatService`) para que sea aplicada tanto en sincronizaciones masivas como en registros individuales en tiempo real.

## [2026-04-12] Compilación y Bloqueo de Archivos (IDE/Debugger)
- **Error MSB3021/MSB3027**: En entornos de desarrollo con depuradores activos (ej: VS Code + C# Dev Kit), los archivos `.pdb` y `.dll` suelen quedar bloqueados por procesos como `netcoredbg.exe`.
- **Solución**: Si el script `kill_ports.ps1` no es suficiente, ejecutar `taskkill /F /IM netcoredbg.exe` para liberar los archivos y permitir una compilación limpia.

## [2026-04-12] Secuencialidad y Formateo de Kardex
- **Secuencialidad por Desfase**: Cuando múltiples documentos (ventas) ocurren en la misma fecha sin marca de tiempo precisa, se puede inyectar el correlativo como segundos (`TimeSpan.FromSeconds(Numero % 60)`) para forzar un ordenamiento determinista en el Kardex.
- **Estandarización de Formatos**: Para cumplimiento SUNAT y consistencia visual, los números de documento deben normalizarse (ej. `PadLeft(8, '0')`) en el punto de entrada del dominio (`Manejador`) para asegurar que tanto el registro físico como el Kardex valorizado presenten la misma numeración.

## [2026-04-12] Normalización Horaria Estricta vs. Horas Reales
- **El Problema**: Respetar la hora real de un documento (ej. 15:00) mientras otros se normalizan (ej. 10:00) rompe la secuencia comercial (Venta mañana < Compra tarde), causando saldos negativos en reportes que ordenan por fecha/hora.
- **Solución Senior**: Forzar SIEMPRE la ventana horaria correspondiente (08:00, 09:00, 10:00, 11:00) independientemente de la hora que traiga el documento de origen. Esto garantiza que las compras SIEMPRE precedan a las ventas del mismo día, estabilizando el cálculo de saldos y costos promedios.

## [2026-04-12] Impacto de Stock en Notas de Crédito y Débito
- **Regla de Negocio**: Una Nota de Crédito no tiene un impacto de stock absoluto. Su efecto es **INVERSO** al documento que afecta:
    - NC de Venta (Devolución de Cliente): Debe ser una **ENTRADA** (+) de stock.
    - NC de Compra (Devolución a Proveedor): Debe ser una **SALIDA** (-) de stock.
- **Implementación**: Utilizar una configuración `DEPENDIENTE` en la tabla de comprobantes y delegar en el manejador de inventario la decisión final basada en el `ReferenciaModulo` (VENTAS vs COMPRAS).

## [2026-04-12] Robustez en Migraciones de PostgreSQL (Renames & Constraints)
- **Problema**: EF Core intenta renombrar índices y restricciones (ej: `IX_...` -> `ix_...`) asumiendo que el estado previo coincide exactamente con su snapshot. Si los nombres ya están normalizados o difieren, la migración falla con errores `42704` (no existe restricción) o `42P01` (no existe relación).
- **Lección**: Para migraciones que implican cambios masivos de convenciones de nombres (como pasar de PascalCase a snake_case), es más seguro:
    1.  Usar comandos `Sql` con `DROP CONSTRAINT IF EXISTS` y `DROP INDEX IF EXISTS` para limpiar el terreno antes de recrear.
    2.  Si el "ruido" de renombrado es excesivo y causa bloqueos, simplificar la migración manual en el archivo `.cs` para que solo contenga los cambios estructurales reales (ej: `AddColumn`), permitiendo una aplicación limpia mientras se estabiliza el snapshot.
- **Prevención**: Verificar siempre los nombres físicos en PostgreSQL antes de confiar ciegamente en el scaffold automático de EF Core en proyectos con historiales de esquema complejos.
## [2026-04-12] PostgreSQL - Error 42703 (Undefined Column) en Referencias Cruzadas
- **Problema**: Al crear entidades de referencia para tablas de otros microservicios (usando `ExcludeFromMigrations`), es común heredar la suposición de que la PK se llama `id`. Si la tabla original usa una convención distinta (ej: `id_afectacion`), EF Core lanzará una excepción `42703` al intentar consultar.
- **Lección**: Siempre verificar el DDL o la entidad original del microservicio dueño antes de definir el mapeo `[Column(...)]` en la entidad Ref. No asumir convenciones genéricas para PKs en sistemas con esquemas ya establecidos.
- **Prevención**: Incluir un paso de verificación de "Nombres de Columna Físicos" en el plan de implementación al trabajar con `EntidadesRef`.
