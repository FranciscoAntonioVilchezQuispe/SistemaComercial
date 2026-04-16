# Guía Maestra de Base de Datos - Sistema Comercial (Actualizada 2026-04-16)

Esta carpeta contiene la secuencia oficial y consolidada para inicializar, restaurar o actualizar la base de datos PostgreSQL del ecosistema **Sistema Comercial**. Se ha simplificado la estructura para reducir la cantidad de scripts individuales y facilitar el mantenimiento.

---

## 🚀 Escenario A: Instalación desde Cero (Nueva Base de Datos)

Si vas a desplegar el sistema en un entorno limpio, sigue este orden estrictamente:

1.  **01_BASE_SISTEMA_COMERCIAL.sql**: **RECOMENDADO.** Script consolidado que crea todos los esquemas, tablas base con auditoría UTC y carga los datos maestros iniciales (Ubigeos, Series de Comprobantes, Unidades de Medida).
    *   *Incluye los antiguos scripts 00 al 06.*

2.  **02_EVOLUCION_Y_SUNAT.sql**: **CRÍTICO.** Aplica todas las normalizaciones in-place, vistas del sistema, correcciones de métodos de pago y la implementación completa de **SUNAT UBL 2.1** (NC/ND, Anulaciones).
    *   *Incluye los antiguos scripts 07 al 14 y todas las migraciones de microservicios.*

3.  **03_ESTABILIZACION_Y_KARDEX.sql**: **NUEVO.** Configura la tabla maestra de tipos de movimiento para el Kardex, ajusta comportamientos de stock para notas de crédito/débito y realiza limpiezas de datos transaccionales para pruebas.
    *   *Incluye los scripts 15 al 17.*

---

## 🔄 Escenario B: Restauración de Estado Actual (Respaldo)

Si necesitas restaurar la base de datos a un estado histórico, consulta la carpeta `archive/`:

1.  **archive/dump-sistema_comercial-202604021759.sql**: Volcado completo al 2 de abril de 2026.

---

## 📂 Estructura de la Carpeta

- **01_BASE_SISTEMA_COMERCIAL.sql**: Cimiento del sistema.
- **02_EVOLUCION_Y_SUNAT.sql**: Actualizaciones de lógica y cumplimiento tributario.
- **03_ESTABILIZACION_Y_KARDEX.sql**: Configuración avanzada de inventario y stock.
- **mantenimiento/**: Contiene herramientas de diagnóstico, consultas (`VERIF_*.sql`) y validadores de reglas SUNAT.
- **archive/**: Historial de scripts individuales y volcados (dumps) de seguridad.
- **SCRIPTS_GUIDE.md**: Esta guía de referencia.

---

## ⚙️ Estándares Técnicos

- **Motor**: PostgreSQL 15+
- **Codificación**: UTF-8 (Se recomienda validar mediante PowerShell si hay errores de lectura).
- **Zona Horaria**: America/Lima (UTC-5) para visualización | **Interno**: UTC (`timestamptz`).
- **SUNAT**: Cumplimiento con Catálogo 51 y UBL 2.1.

---
**Atención**: Antes de ejecutar actualizaciones en entornos de producción, asegúrate de tener un backup reciente en la carpeta `archive/`.
