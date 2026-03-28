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
