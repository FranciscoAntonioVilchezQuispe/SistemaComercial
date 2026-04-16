# Historial de Sesión: Estandarización Global de Fechas (UTC-5 Lima)

**Fecha:** 2026-04-13
**Modelo:** Antigravity

## 🎯 Objetivo
Eliminar las inconsistencias horarias en el Kardex y documentos comerciales causadas por el uso de UTC (GMT+0) en un entorno comercial peruano (UTC-5). Se buscó garantizar que toda transacción generada después de las 19:00 horas no "salte" al día siguiente.

## 🛠️ Cambios Realizados

### Backend (.NET / C#)
- **Núcleo Común**: 
    - Se creó `DateTimeConstants.cs` y `DateTimeHelper.cs` en `Nucleo.Comun.Domain`. 
    - `DateTimeHelper.ObtenerAhoraLima()` es ahora la fuente de verdad única para la hora actual.
    - Se actualizó `EntidadBase.cs` para usar este helper en las propiedades `FechaCreacion` y `FechaActualizacion`.
- **Manejadores de Comandos**:
    - Se refactorizaron los manejadores de **Ventas**, **Compras** e **Inventario** (Traslados, Kardex, Periodos) para reemplazar `DateTime.UtcNow` por `DateTimeHelper.ObtenerAhoraLima()`.
    - Se eliminaron llamadas a `.ToUniversalTime()` en fechas comerciales (Emisión, Vencimiento).
- **Infraestructura**:
    - Se actualizaron los `DbContext` de Ventas, Compras y Contabilidad para forzar la auditoría en la hora de Lima durante `SaveChangesAsync`.
    - Se ajustó el `ManejoExcepcionesMiddleware` para que el `timestamp` de error sea coherente con la hora local.

### Frontend (React / TS)
- **Utilidades**: Se creó `src/lib/datetime.ts` con la configuración centralizada de `America/Lima` y helpers como `getCurrentDateTime()`, `formatDateForAPI()` y `getCurrentPeriod()`.
- **Componentes UI**: Se desplegó un `DatePicker` unificado basado en `date-fns` y `react-day-picker`, reemplazando los inputs nativos de tipo "date".
- **Formularios**:
    - Refactorización total de `PaginaKardexReporte.tsx` y `PaginaKardexPeriodos.tsx`.
    - Refactorización de `CompraForm.tsx` y `OrdenCompraForm.tsx` para usar el nuevo `DatePicker` y el helper de tiempo.
- **Gobernanza (Linting)**:
    - Se instaló y configuró **ESLint v9 (Flat Config)**.
    - Se implementó la regla `no-restricted-syntax` para prohibir `new Date()` y `.toISOString()` directo, obligando al uso del estándar del proyecto.

## ✅ Verificación
- Se ejecutó `npm run lint` en el frontend, capturando y corrigiendo múltiples instanciaciones directas de `Date`.
- Se verificó que el Kardex ahora genera registros con la fecha local correcta incluso en horario nocturno.

## 📜 Script de Corrección SQL (PostgreSQL)
Para corregir los registros que "saltaron" de fecha antes de esta implementación:

```sql
DO $$
BEGIN
    -- Corregir movimientos del 13 de abril que debieron ser del 12 (desfase UTC)
    UPDATE inventario.kardex_movimientos
    SET 
        fecha_movimiento = '2026-04-12',
        fecha_hora_compuesta = fecha_hora_compuesta - INTERVAL '5 hours',
        periodo = '2026-04'
    WHERE fecha_movimiento = '2026-04-13'
      AND hora_movimiento < '05:00:00'; -- Registros creados entre 00:00 y 05:00 UTC (19:00 - 00:00 LIMA)

    RAISE NOTICE 'Registros de Kardex corregidos.';
END $$;
```
