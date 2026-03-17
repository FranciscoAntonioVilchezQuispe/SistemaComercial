# Guía de Restauración de Base de Datos - Sistema Comercial

Esta carpeta contiene la secuencia oficial y consolidada para restaurar la base de datos PostgreSQL desde cero, asegurando la integridad referencial y el cumplimiento con SUNAT.

## Secuencia Maestra de Restauración (00-07)

Para una restauración completa, ejecute los scripts en el siguiente orden exacto:

1.  **`00_init_schemas.sql`**: Crea los esquemas (`configuracion`, `ventas`, `compras`, `catalogo`, `inventario`, `identidad`, `contabilidad`).
2.  **`01_base_schema.sql`**: Define la estructura base de las tablas principales (Importado de pg_dump).
3.  **`02_bootstrap_sunat.sql`**: Garantiza la existencia de tablas críticas SUNAT y añade restricciones de integridad (FKs) y valores por defecto.
4.  **`03_base_data.sql`**: Carga los datos maestros iniciales del sistema.
5.  **`04_delta_schema.sql`**: Aplica cambios estructurales (deltas) generados por las migraciones de EF Core.
6.  **`05_sunat_master_data.sql`**: Puebla los catálogos SUNAT, reglas matriz, tipos de operación y series de comprobantes (F001, B001, etc.).
7.  **`06_sunat_improvements_views.sql`**: Crea las vistas del esquema `vistas` optimizadas para el frontend y catálogos de notas (NC/ND).
8.  **`07_sync_ef_history.sql`**: Sincroniza la tabla `__EFMigrationsHistory` para que coincida con el estado actual del esquema.

---

## Herramientas de Automatización

Se recomienda usar el **DbSeeder** ubicado en el Backend para ejecutar la secuencia completa automáticamente:

```powershell
# Ejecutar desde el directorio del DbSeeder
dotnet run -- RESET
```

## Archivo y Diagnóstico

Los scripts temporales, de depuración o inspección se encuentran en la subcarpeta `archive/`. No deben usarse para procesos de restauración estándar.

---
**Nota**: Basado en PostgreSQL 15+.
