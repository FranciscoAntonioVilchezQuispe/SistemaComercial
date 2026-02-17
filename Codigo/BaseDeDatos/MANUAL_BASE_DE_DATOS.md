# Manual de Mantenimiento de Base de Datos - Sistema Comercial

Este documento describe el procedimiento para inicializar, restaurar y mantener la base de datos `sistema_comercial` utilizando los scripts automatizados.

## 1. Requisitos Previos

- **Tener instalado .NET SDK 6.0 o superior** (para ejecutar `SqlRunner`).
- **PostgreSQL instalado y corriendo** en `localhost:5432`.
- Usuario `postgres` con contraseña `aaAA11++`.
- Estar ubicado en la carpeta: `d:\Proyectos\SistemaComercial\Codigo`.

## 2. Automatización Completa

Para recrear toda la base de datos desde cero (Estructura + Datos de Menús + Permisos + Datos de Configuración + Datos Restaurados del Dump), ejecute el siguiente comando en PowerShell:

```powershell
.\setup_database.ps1
```

Este script realizará los siguientes pasos secuenciales:

1.  **Crear Base de Datos**: Crea `sistema_comercial` si no existe.
2.  **Estructura**: Crea todos los esquemas y tablas (basado en el dump original).
3.  **Menús y Permisos**: Carga la configuración inicial de seguridad.
4.  **Datos de Configuración**: Inserta tipos de comprobantes, impuestos y parámetros que faltaban en el dump original.
5.  **Restauración de Datos**: Limpia las tablas e inserta los datos históricos recuperados del dump (excluyendo registros obsoletos como el `TIPO_COMPROBANTE` antiguo).
6.  **Migración Fase 1**: Aplica los cambios para Kardex Valorizado y Notas Electrónicas.
7.  **Verificación**: Muestra un reporte del conteo de registros por esquema.

## 3. Scripts Individuales (`BaseDeDatos\`)

Si desea ejecutar pasos específicos, puede usar `dotnet run` con la herramienta `SqlRunner`:

| Archivo                          | Descripción                                                                 |
| :------------------------------- | :-------------------------------------------------------------------------- |
| `00_CrearBase.sql`               | Crea la base de datos vacía.                                                |
| `01_Estructura.sql`              | Define esquemas, tablas, secuencias y funciones.                            |
| `02_Datos_Menus.sql`             | Inserta menús del sistema.                                                  |
| `03_Permisos.sql`                | Configura el sistema de permisos granulares.                                |
| `04_Datos_Semilla.sql`           | Inserta datos de prueba básicos (Categorías, Marcas). Útil para desarrollo. |
| `06_Faltantes_Configuracion.sql` | Crea tablas nuevas como `sucursales` y `tipos_comprobantes`.                |
| `07_Datos_Configuracion.sql`     | Inserta datos base para las tablas de configuración.                        |
| `08_Datos_Restaurados.sql`       | Restaura los datos del dump histórico (limpiando tablas primero).           |
| `09_Migracion_Fase1.sql`         | Ajustes de Kardex Valorizado y creación de tablas de Notas.                 |
| `99_Verificacion.sql`            | Consulta el estado actual de las tablas.                                    |

**Ejemplo de ejecución manual:**

```powershell
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\99_Verificacion.sql"
```

## 4. Notas Importantes

- **Conflicto de Datos**: `04_Datos_Semilla.sql` y `08_Datos_Restaurados.sql` pueden tener conflictos de IDs. El script automatizado `setup_database.ps1` ejecuta ambos pero `08` limpia (TRUNCATE) lo que hizo `04` para asegurar que queden los datos "reales" del dump.
- **Limpieza de Permisos**: Existe un script `Backend\scripts\00_limpiar_permisos.sql` que sirve para BORRAR las tablas de identidad. No se usa en la instalación normal.

---

_Generado automáticamente por Antigravity_
