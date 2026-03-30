# Guía Maestra de Base de Datos - Sistema Comercial (Unificada)

Esta carpeta contiene la secuencia oficial y consolidada para inicializar, restaurar o normalizar la base de datos PostgreSQL del ecosistema **Sistema Comercial**.

---

## 🚀 Escenario A: Base de Datos Nueva (Instalación Limpia)

Si vas a desplegar el sistema en un servidor nuevo o desde cero, utiliza el script unificado:

1.  **`00_SISTEMA_COMERCIAL_UNIFICADO.sql`**: **RECOMENDADO.** Script atómico que crea esquemas, tablas base con auditoría UTC y carga los datos maestros iniciales en un solo paso.

---

## 🔧 Escenario B: Base de Datos Existente (Normalización)

Si ya tienes datos y solo necesitas sincronizar tu base de datos con los últimos cambios del Backend (.NET) y Frontend (TypeScript):

1.  **`11_NORMALIZACION_IN_PLACE.sql`**: **CRÍTICO.** Ejecuta este script para convertir todas las fechas a UTC (`timestamptz`), ampliar campos de usuario a `varchar(100)` y eliminar tablas duplicadas de migraciones sin perder tus datos.

---

## 📜 Secuencia de Ejecución Detallada (Legacy / Módulos)

Para personalizaciones específicas por módulo, utiliza la secuencia numerada:

### Bloque 1: Estructura y Base
*   `01_esquema_completo.sql`: Definición de esquemas y tablas base.
*   `02_datos_maestros.sql`: Carga de catálogos y permisos.
*   `03_vistas_sistema.sql`: Vistas para dashboards.
*   `04_sincronizacion_ef.sql`: Registro de migraciones EF Core.

### Bloque 2: Datos SUNAT y Catálogos
*   `05_carga_ubigeos.sql`: Carga masiva de Departamentos/Provincias/Distritos.
*   `06_datos_series.sql`: Series de comprobantes.
*   `07_tipo_orden_compra.sql`: Catálogo de OC.
*   `08_actualizar_estados_oc.sql`: Normalización de estados.
*   `09_normalizacion_sunat.sql`: Ajustes técnicos tributarios.

### Bloque 3: Estabilización y Notas SUNAT
*   `10_ESTABILIZACION_AUDITORIA_GLOBAL.sql`: Asegura campos de auditoría en tablas manuales.
*   `12_SUNAT_NOTAS_VENTAS.sql`: **NUEVO.** Implementación de NC/ND y anulaciones en Ventas.
*   `13_SUNAT_NOTAS_COMPRAS.sql`: **NUEVO.** Implementación de NC/ND y anulaciones en Compras.

---

## 📂 Mantenimiento y Diagnóstico

- Los scripts de depuración y parches antiguos se encuentran en la subcarpeta `archive/`. 
- **Entorno compatible**: PostgreSQL 15+ 
- **Zona Horaria**: America/Lima (UTC-5) | **Estándar Interno**: UTC (timestamptz)

---
**Nota**: Siempre realiza un backup antes de ejecutar scripts de normalización in-place.
