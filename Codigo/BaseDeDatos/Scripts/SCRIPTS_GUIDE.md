# Guía Maestra de Base de Datos - Sistema Comercial (Actualizada 2026-04-02)

Esta carpeta contiene la secuencia oficial y consolidada para inicializar, restaurar o actualizar la base de datos PostgreSQL del ecosistema **Sistema Comercial**. Se ha simplificado la estructura para reducir la cantidad de scripts individuales.

---

## 🚀 Escenario A: Instalación desde Cero (Nueva Base de Datos)

Si vas a desplegar el sistema en un entorno limpio, sigue este orden:

1.  **01_BASE_SISTEMA_COMERCIAL.sql**: **RECOMENDADO.** Script consolidado que crea todos los esquemas, tablas base con auditoría UTC y carga los datos maestros iniciales (Ubigeos, Series de Comprobantes, Unidades de Medida).
    *   *Incluye los antiguos scripts 00 al 06.*

2.  **02_EVOLUCION_Y_SUNAT.sql**: **CRÍTICO.** Aplica todas las normalizaciones in-place, vistas del sistema, correcciones de métodos de pago y la implementación completa de **SUNAT UBL 2.1** (NC/ND, Anulaciones).
    *   *Incluye los antiguos scripts 07 al 14 y todas las migraciones de microservicios.*

---

## 🔄 Escenario B: Restauración de Estado Actual (Respaldo)

Si necesitas restaurar la base de datos a su estado exacto más reciente antes de los cambios de hoy:

1.  **dump-sistema_comercial-202604021759.sql**: Este es el volcado (dump) completo de la base de datos con todos los datos previos al proceso de consolidación de scripts.

---

## 📂 Estructura de la Carpeta

- **01_BASE_SISTEMA_COMERCIAL.sql**: Cimiento del sistema.
- **02_EVOLUCION_Y_SUNAT.sql**: Actualizaciones de lógica y cumplimiento tributario.
- **archive/**: Contiene los 29 scripts originales individuales por si se requiere revisar el historial detallado de cambios bloque por bloque.
- **SCRIPTS_GUIDE.md**: Esta guía de referencia.

---

## ⚙️ Estándares Técnicos

- **Motor**: PostgreSQL 15+
- **Codificación**: UTF-8
- **Zona Horaria**: America/Lima (UTC-5) para visualización | **Interno**: UTC (`timestamptz`).
- **SUNAT**: Cumplimiento con Catálogo 51 y UBL 2.1.

---
**Atención**: Antes de ejecutar el script 02_EVOLUCION_Y_SUNAT.sql en entornos de producción con datos reales, asegúrate de tener un backup (como el dump del 2026-04-02).
