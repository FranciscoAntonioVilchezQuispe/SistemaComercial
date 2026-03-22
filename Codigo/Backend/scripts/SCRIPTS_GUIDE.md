# Guía de Restauración de Base de Datos - Sistema Comercial

Esta carpeta contiene la secuencia oficial y consolidada para restaurar la base de datos PostgreSQL desde cero, asegurando la integridad referencial y el cumplimiento con SUNAT.

## Secuencia Maestra de Restauración Consolidada (01-04)

Para una restauración completa, ejecute los scripts en el siguiente orden:

1.  **`01_esquema_completo.sql`**: Define todos los esquemas, tablas base, tablas SUNAT y correcciones estructurales.
2.  **`02_datos_maestros.sql`**: Carga menús, permisos, catálogos SUNAT, productos demo y registros semilla para clientes/proveedores.
3.  **`03_vistas_sistema.sql`**: Crea las vistas del esquema `vistas` optimizadas para el frontend.
4.  **`04_sincronizacion_ef.sql`**: Sincroniza la tabla `__EFMigrationsHistory` con el estado consolidado.

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
