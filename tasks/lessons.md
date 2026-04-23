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

## [2026-04-19] Verificación de Compilación Obligatoria
- **Error**: Entregar código TSX con errores de importación y tipos por no ejecutar el compilador.
- **Lección**: NUNCA dar por terminada una tarea que involucre cambios de código sin ejecutar `tsc` (frontend) o `build` (backend). La "falsa sensación de completitud" es un riesgo para la calidad. He actualizado GEMINI.md para que esta verificación sea un paso obligatorio.

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

---

## [2026-04-19] Scripts SQL - RAISE NOTICE fuera de bloque DO
**Error cometido:** Gemini Flash generó `RAISE NOTICE 'mensaje';` como sentencia SQL standalone en un script de diagnóstico.
**Causa raíz:** `RAISE NOTICE` es PL/pgSQL, no SQL estándar. Solo es válido dentro de un bloque `DO $$ BEGIN ... END $$`. Fuera de ese bloque, PostgreSQL lanza `ERROR: syntax error at or near "RAISE"`.
**Regla para el futuro:** Al generar scripts SQL de diagnóstico (`.sql`) que corren en DBeaver o psql, usar solo comentarios SQL (`-- texto`) para separadores entre queries. Si se necesita RAISE NOTICE para logging, envolver TODO el script en un `DO $$ BEGIN ... END $$`.
**Archivos afectados:** `scripts/diagnostico_seguridad.sql`
**Proyecto:** Identidad (scripts de BD)

---

## [2026-04-19] Prompts Multi-Agente - Pedir output completo del archivo
**Error cometido:** Los agentes de Gemini Flash aplicaron correctamente todos los cambios, pero no crearon el archivo de plan en `tasks/planes/` (no se incluyó ese requerimiento en el prompt).
**Causa raíz:** El prompt no especificó crear un archivo de plan — los agentes solo hacen lo que se les pide explícitamente.
**Regla para el futuro:** En prompts para agentes de implementación, agregar siempre al final: "Crea un archivo `tasks/planes/YYYY-MM-DD_nombre.md` con el resumen de lo que implementaste." Esto habilita que `/revisar-implementacion` tenga contexto del plan original.
**Archivos afectados:** `tasks/planes/` (vacío)
**Proyecto:** General (proceso multi-agente)

---
## [2026-04-20] — Bloqueo de preLaunchTask por caracteres especiales
**Error cometido:** La depuración Full Stack se bloqueaba esperando a que el servidor de desarrollo del Frontend estuviera listo.
**Causa raíz:** El `endsPattern` del `problemMatcher` en `tasks.json` incluía el carácter especial `➜`, el cual se corrompía (`Ô×£`) al ser redireccionado por PowerShell a un archivo de log debido a la codificación UTF-16LE. Al no haber coincidencia exacta, VS Code esperaba indefinidamente.
**Regla para el futuro:** Evitar el uso de caracteres especiales (flechas, símbolos ANSI) en las expresiones regulares de `problemMatchers` para tareas en segundo plano. Usar patrones de texto plano más genéricos y estables como `Local:\\s+http://localhost:\\d+/`.
**Archivos afectados:** `.vscode/tasks.json`
**Proyecto:** Frontend / VS Code Config


---

## [2026-04-19] Frontend — Doble Toast por Desconocimiento del Interceptor Global
**Error cometido:** Al agregar manejo específico de error 403 en `PaginaRoles.tsx`, se generaba un doble toast: el interceptor Axios en `src/lib/axios.ts` ya muestra "No tienes permisos para realizar esta acción" para TODO error 403, y el componente añadía un segundo toast encima.
**Causa raíz:** Flash no leyó el interceptor global antes de agregar lógica de manejo de errores al componente.
**Regla para el futuro:** En planes que pidan manejo de errores HTTP en componentes frontend, incluir SIEMPRE `src/lib/axios.ts` en las referencias de código obligatorias. Si el interceptor ya maneja el código HTTP, el componente solo debe manejar errores que el interceptor NO cubra, o usar `_skipToast: true` para suprimir el toast global.
**Archivos afectados:** `PaginaRoles.tsx`, `src/lib/axios.ts`
**Proyecto:** Frontend

---
## [2026-04-20] — Filtrado dinámico de menús (rutas.tsx + RutaProtegida)

**Error cometido 1:** Flash usó `codigoPermiso="PROVEEDORES"` para las rutas `proveedores/*` en `rutas.tsx`. Ese código no existe en el JWT — el Gateway mapea `/api/proveedores` al grupo `COMPRAS`.
**Causa raíz:** Flash infirió el código desde el nombre de la URL en lugar de consultar el mapeo del Gateway.
**Regla para el futuro:** Los planes que asignen `codigoPermiso` a rutas frontend DEBEN incluir una tabla explícita de "ruta URL → codigoPermiso correcto", derivada del bloque de mapeo en `Gateway.API/Program.cs`. No dejar que Flash infiera el código desde el nombre de la ruta.
**Archivos afectados:** `rutas.tsx`
**Proyecto:** Frontend

**Error cometido 2:** `RutaProtegida.tsx` implementó el check de `codigoPermiso` solo con `permisos.includes(...)`, omitiendo el patrón de submenú `permisos.some(p => p.startsWith(...) && p.endsWith(":VER"))` que sí estaba en `usePermiso.ts` y `Sidebar.tsx`.
**Causa raíz:** Flash copió la lógica exacta en Sidebar pero al reescribir `RutaProtegida` omitió la segunda condición.
**Regla para el futuro:** Cuando el plan define una función de validación de permisos, incluir la nota: "La lógica de verificación DEBE ser idéntica en `usePermiso.ts`, `RutaProtegida.tsx` y `Sidebar.tsx`. Si una usa el patrón `tieneSubMenu`, todas deben usarlo."
**Archivos afectados:** `RutaProtegida.tsx`
**Proyecto:** Frontend

**Error cometido 3:** Flash colocó `import { RutaProtegida }` en el medio del archivo `rutas.tsx` (después de todos los imports lazy), causando error TS2300 de identificador duplicado al intentar moverlo al tope.
**Causa raíz:** Flash agregó el import donde le pareció conveniente en lugar de al tope del archivo.
**Regla para el futuro:** Especificar en los planes que agreguen imports: "Todo import estático debe ir al tope del archivo, antes de cualquier declaración de constante o componente."
**Archivos afectados:** `rutas.tsx`
**Proyecto:** Frontend

---
## [2026-04-22] — Sistema de Permisos: Estructura real de la BD

**Error cometido:** El plan asumió que los permisos en BD son `identidad.permisos (codigo, nombre, id_modulo)`. La tabla real tiene columnas diferentes y los permisos granulares vienen de `roles_menus` → `roles_menus_permisos` → `tipos_permiso`.
**Causa raíz:** El plan generó SQL basado en supuestos del esquema sin verificar la estructura real.
**Regla para el futuro:** El flujo real para agregar permisos es: (1) insertar en `identidad.menus` (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre) → (2) insertar en `identidad.roles_menus` (id_rol, id_menu) → (3) insertar en `identidad.roles_menus_permisos` (id_rol_menu, id_tipo_permiso) para tipos VER, CREAR, EDITAR, ELIMINAR. Los permisos del JWT se calculan como `{menu.codigo}:{tipo_permiso.codigo}`.
**Archivos afectados:** `Codigo/BaseDeDatos/Scripts/permisos_cajas_turnos.sql`
**Proyecto:** BD

## [2026-04-22] — Gateway: Nuevas rutas de API requieren mapeo explícito

**Error cometido:** Gemini Flash implementó correctamente el backend y el frontend pero no agregó el mapeo de `/api/turnos` y `/api/cajas` al middleware de permisos del Gateway.
**Causa raíz:** El plan especificaba los códigos de permiso pero no recordó que el GATEWAY también necesita el mapeo explícito de URL a código de menú.
**Regla para el futuro:** Cuando se creen nuevas rutas de API, SIEMPRE actualizar `Gateway.API/Program.cs` en la sección "Seguridad Granular Permisos" con el bloque `else if (pathLower.StartsWith("/api/nueva-ruta")) menuCodigo = "CODIGO";`. Sin este mapeo el endpoint queda sin protección granular.
**Archivos afectados:** `Gateway.API/Program.cs`
**Proyecto:** Gateway

## [2026-04-23] Moq - CS0854 y Delegados de MediatR
- **Error cometido:** Intentar usar Mock<RequestHandlerDelegate<T>> y verificar su invocaci�n con Verify(x => x()).
- **Causa ra�z:** RequestHandlerDelegate en versiones recientes de MediatR tiene un par�metro CancellationToken opcional. Moq no puede generar �rboles de expresi�n con argumentos opcionales (Error CS0854). Adem�s, mocar delegados directamente es menos intuitivo que mocar interfaces.
- **Regla para el futuro:** Para testear IPipelineBehavior, usar una lambda simple (ct) => { flag = true; return Task.FromResult(result); } como par�metro 
ext. Es m�s robusto y evita errores de compilaci�n por argumentos opcionales.
- **Archivos afectados:** ComportamientoValidacionTests.cs`r
- **Proyecto:** Nucleo.Tests

## [2026-04-23] Versiones de IdentityModel (Conflictos NU1605)
- **Error cometido:** Usar versiones disparatadas (7.6.0 vs 8.14.0) de paquetes IdentityModel.
- **Causa ra�z:** System.IdentityModel.Tokens.Jwt 7.x puede tener dependencias transitivas que exigen 8.x de Microsoft.IdentityModel.Tokens, causando Downgrade detectado.
- **Regla para el futuro:** Al usar paquetes de identidad de Microsoft, asegurar que TODOS compartan la misma versi�n mayor (preferiblemente la m�s reciente estable, e.g., 8.14.0) para evitar conflictos de restauraci�n de NuGet.
- **Archivos afectados:** Nucleo.Tests.Shared.csproj`r

