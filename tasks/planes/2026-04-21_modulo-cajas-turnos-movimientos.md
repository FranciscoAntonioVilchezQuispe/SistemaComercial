# Plan de Implementación: Módulo de Cajas — Movimientos, Arqueo, Historial y Admin

**Fecha:** 2026-04-21
**Generado por:** Claude Code
**Ejecuta:** Antigravity (Gemini Flash)
**Revisa:** Claude Code

---

## Contexto

El módulo de cajas ya tiene las entidades base (`Caja`, `TurnoVendedor`, `CierreTurno`, `MovimientoCaja`) y el flujo básico de apertura/cierre de turno funciona. Sin embargo faltan piezas críticas:

1. **`MovimientoCaja`** no tiene columna `id_turno_vendedor` → no se puede ligar un movimiento a su turno.
2. **`CierreTurno`** no tiene campos de arqueo (`monto_fisico_contado`, `diferencia_arqueo`, `monto_esperado`, `total_ingresos_manuales`, `total_egresos_manuales`).
3. **`CerrarTurnoManejador`** usa IDs hardcodeados para métodos de pago (`p.IdMetodoPago == 1` = Efectivo, etc.) — muy frágil.
4. **`ModalAperturaTurno`** hardcodea las cajas en lugar de cargarlas desde la API.
5. **`ModalCierreTurno`** muestra siempre cero en todos los totales.
6. No existe UI para registrar ingresos/egresos manuales de caja.
7. No existe página de historial de turnos ni CRUD admin de cajas.

Este plan cubre las 5 tareas para dejar el módulo completamente operativo.

---

## Referencias de Código Existente

Leer OBLIGATORIAMENTE antes de empezar cada tarea:

| Archivo | Uso |
|---------|-----|
| `Codigo/Backend/src/Ventas.API/Ventas.API.Domain/Entidades/CierreTurno.cs` | Entidad a modificar en Tarea A |
| `Codigo/Backend/src/Ventas.API/Ventas.API.Domain/Entidades/MovimientoCaja.cs` | Entidad a modificar en Tarea A |
| `Codigo/Backend/src/Ventas.API/Ventas.API.Domain/Entidades/TurnoVendedor.cs` | Entidad de referencia |
| `Codigo/Backend/src/Ventas.API/Ventas.API.Domain/Entidades/Caja.cs` | Entidad a extender en CRUD |
| `Codigo/Backend/src/Ventas.API/Ventas.API.Domain/Entidades/MetodoPago.cs` | Tiene campo `Codigo` (ej: "EFECTIVO") |
| `Codigo/Backend/src/Ventas.API/Ventas.API.Application/Features/Turnos/TurnosManejadores.cs` | Manejadores a modificar |
| `Codigo/Backend/src/Ventas.API/Ventas.API.Application/Features/Turnos/TurnosRequests.cs` | Requests/Commands a extender |
| `Codigo/Backend/src/Ventas.API/Ventas.API.Application/DTOs/TurnosDto.cs` | DTOs a extender |
| `Codigo/Backend/src/Ventas.API/Ventas.API.Application/Interfaces/IVentasDbContext.cs` | Interface del DbContext (ya tiene MovimientosCaja) |
| `Codigo/Backend/src/Ventas.API/Ventas.API.Infrastructure/Datos/VentasDbContext.cs` | DbContext para verificar configuración |
| `Codigo/Backend/src/Ventas.API/Ventas.API.API/Endpoints/CajaEndpoints.cs` | Endpoints a ampliar |
| `Codigo/Backend/src/Ventas.API/Ventas.API.API/Endpoints/TurnosEndpoints.cs` | Endpoints a ampliar |
| `Codigo/Backend/src/Ventas.API/Ventas.API.API/Program.cs` | Para registrar nuevos endpoints |
| `Codigo/Backend/src/Ventas.API/Ventas.API.Infrastructure/Migrations/20260416134956_Add_TurnoVendedor_CierreTurno.cs` | Última migración — modelo para la nueva |
| `Codigo/Frontend/src/features/ventas/servicios/turnoService.ts` | Servicio a extender |
| `Codigo/Frontend/src/features/ventas/tipos/ventas.types.ts` | Tipos `TurnoVendedorDto`, `CierreTurnoDto`, `MovimientoCaja` |
| `Codigo/Frontend/src/features/ventas/componentes/pos/ModalAperturaTurno.tsx` | A reescribir |
| `Codigo/Frontend/src/features/ventas/componentes/pos/ModalCierreTurno.tsx` | A reescribir |
| `Codigo/Frontend/src/features/ventas/paginas/PaginaPOS.tsx` | A modificar |
| `Codigo/Frontend/src/configuracion/rutas.tsx` | Para agregar rutas nuevas |
| `Codigo/Frontend/src/config/menu.tsx` | Para agregar items de menú |
| `Codigo/Frontend/src/config/rutasTitulos.ts` | Para agregar títulos de rutas |

---

## Reglas Críticas para Flash

1. **NUNCA usar `DateTime.UtcNow` directamente** — la conversión a UTC ya está configurada globalmente en `VentasDbContext.ConfigureConventions()` con `DateTimeToUtcConverter`. Usar `DateTime.Now` o `DateTime.UtcNow` es equivalente, pero por consistencia con el proyecto usar `DateTime.UtcNow`.
2. **NUNCA usar `QueryAsync<dynamic>` en Dapper** — siempre DTO tipado plano.
3. **NUNCA disponer (`using`) la conexión del DbContext** — obtenerla así:
   ```csharp
   var connection = _context.Database.GetDbConnection();
   if (connection.State != ConnectionState.Open)
       await connection.OpenAsync();
   ```
4. **En paginación Dapper, siempre `COUNT(*) OVER()`** — nunca dos queries separadas.
5. **`DefaultTypeMap.MatchNamesWithUnderscores = true`** ya está configurado en `Program.cs`. No volver a configurarlo.
6. **No usar Data Annotations para validar lógica** — usar `AbstractValidator<T>` de FluentValidation.
7. **En el Frontend, todos los imports estáticos al TOPE del archivo** — nunca en el medio.
8. **En el Frontend, acceder a respuestas paginadas siempre como `response.datos`**, no `response.data` ni `response` directo.
9. **El interceptor Axios global ya maneja errores HTTP genéricos** (`src/lib/axios.ts`). No duplicar toasts para errores que el interceptor ya cubre.
10. **Codigos de permiso en rutas**: el Gateway mapea `/api/turnos` y `/api/cajas` bajo el grupo `VENTAS`. Los permisos frontend para las nuevas páginas serán: `VEN_TURNOS` (historial) y `VEN_CAJAS` (admin cajas).
11. **NUNCA borrar imports existentes** al modificar archivos — solo agregar los que falten.
12. **Ejecutar `dotnet build` después de cada tarea backend** y `npx tsc --noEmit` después de cada tarea frontend antes de marcar como completa.

---

## Tarea A — Migración EF Core: Nuevos Campos en BD (Agente 1)

**Tiempo estimado:** 25 minutos
**Modo recomendado:** Fast
**Prerequisito:** Ninguno. Esta tarea debe completarse ANTES que B, C, D y E.

### Archivos a crear/modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `Ventas.API.Domain/Entidades/CierreTurno.cs` | MODIFICAR | Agregar 5 nuevas propiedades de arqueo |
| `Ventas.API.Domain/Entidades/MovimientoCaja.cs` | MODIFICAR | Agregar `IdTurnoVendedor` y navegación |
| `Ventas.API.Application/DTOs/TurnosDto.cs` | MODIFICAR | Extender `CierreTurnoDto` con campos de arqueo y agregar `MovimientoListDto` |
| `Ventas.API.Application/Features/Turnos/TurnosRequests.cs` | MODIFICAR | Agregar `MontoFisicoContado` a `CerrarTurnoComando` |

> **NOTA IMPORTANTE:** NO crear la migración EF Core manualmente. Solo modificar las entidades y los DTOs. La migración la ejecutará el desarrollador desde la terminal con `dotnet ef migrations add ...`. El agente solo modifica el código C#.

### Especificación detallada

#### 1. Modificar `CierreTurno.cs`

Agregar estas 5 propiedades DESPUÉS de `CantidadTransacciones` y ANTES de `Observaciones`:

```csharp
[Column("total_ingresos_manuales", TypeName = "decimal(12,2)")]
public decimal TotalIngresosManualles { get; set; }

[Column("total_egresos_manuales", TypeName = "decimal(12,2)")]
public decimal TotalEgresosManualles { get; set; }

[Column("monto_esperado", TypeName = "decimal(12,2)")]
public decimal MontoEsperado { get; set; }

[Column("monto_fisico_contado", TypeName = "decimal(12,2)")]
public decimal MontoFisicoContado { get; set; }

[Column("diferencia_arqueo", TypeName = "decimal(12,2)")]
public decimal DiferenciaArqueo { get; set; }
```

#### 2. Modificar `MovimientoCaja.cs`

Agregar después de `IdCaja`:

```csharp
[Column("id_turno_vendedor")]
public long? IdTurnoVendedor { get; set; }
```

Y agregar la navegación al final de la clase (antes del cierre de `}`):

```csharp
[ForeignKey("IdTurnoVendedor")]
public virtual TurnoVendedor? TurnoVendedor { get; set; }
```

#### 3. Modificar `TurnosDto.cs`

**Extender `CierreTurnoDto`** agregando estas propiedades al final:

```csharp
public decimal TotalIngresosManualles { get; set; }
public decimal TotalEgresosManualles { get; set; }
public decimal MontoEsperado { get; set; }
public decimal MontoFisicoContado { get; set; }
public decimal DiferenciaArqueo { get; set; }
```

**Agregar nueva clase `MovimientoListDto`** al final del archivo:

```csharp
public class MovimientoListDto
{
    public long Id { get; set; }
    public long IdCaja { get; set; }
    public long? IdTurnoVendedor { get; set; }
    public long IdTipoMovimiento { get; set; }
    public string TipoMovimientoNombre { get; set; } = string.Empty;
    public decimal Monto { get; set; }
    public string Concepto { get; set; } = string.Empty;
    public DateTime FechaMovimiento { get; set; }
    public string UsuarioResponsable { get; set; } = string.Empty;
}

public class RegistrarMovimientoRequest
{
    public long IdCaja { get; set; }
    public long? IdTurnoVendedor { get; set; }
    public long IdTipoMovimiento { get; set; }
    public decimal Monto { get; set; }
    public string Concepto { get; set; } = string.Empty;
}

public class TurnoResumenPrevioDto
{
    public long TurnoId { get; set; }
    public decimal MontoApertura { get; set; }
    public decimal TotalVentas { get; set; }
    public decimal TotalEfectivo { get; set; }
    public decimal TotalTarjeta { get; set; }
    public decimal TotalTransferencia { get; set; }
    public decimal TotalOtros { get; set; }
    public decimal TotalIngresosManualles { get; set; }
    public decimal TotalEgresosManualles { get; set; }
    public decimal MontoEsperadoEnCaja { get; set; }
    public int CantidadVentas { get; set; }
    public List<MovimientoListDto> MovimientosManuales { get; set; } = new();
}

public class TurnoHistorialDto
{
    public long Id { get; set; }
    public long CajaId { get; set; }
    public string NombreCaja { get; set; } = string.Empty;
    public long UsuarioVendedorId { get; set; }
    public string NombreVendedor { get; set; } = string.Empty;
    public DateTime FechaInicio { get; set; }
    public DateTime? FechaFin { get; set; }
    public decimal MontoApertura { get; set; }
    public decimal? MontoCierre { get; set; }
    public string Estado { get; set; } = string.Empty;
    public decimal TotalVentas { get; set; }
    public int CantidadTransacciones { get; set; }
    public int Total { get; set; } // Para paginación con COUNT(*) OVER()
}
```

#### 4. Modificar `TurnosRequests.cs`

Agregar `MontoFisicoContado` al `CerrarTurnoComando`:

```csharp
public class CerrarTurnoComando : IRequest<CierreTurnoDto>
{
    public long TurnoVendedorId { get; set; }
    public string? Observaciones { get; set; }
    public long UsuarioVendedorId { get; set; }
    public decimal MontoFisicoContado { get; set; } // NUEVO
}
```

Agregar nuevas queries al final del archivo:

```csharp
public class ObtenerResumenPrevioCierreQuery : IRequest<TurnoResumenPrevioDto>
{
    public long TurnoVendedorId { get; set; }
    public long UsuarioVendedorId { get; set; }
}

public class ObtenerHistorialTurnosQuery : IRequest<Nucleo.Comun.Application.Wrappers.PagedResponse<TurnoHistorialDto>>
{
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 20;
    public long? CajaId { get; set; }
    public string? Estado { get; set; }
    public DateTime? FechaDesde { get; set; }
    public DateTime? FechaHasta { get; set; }
}

public class RegistrarMovimientoCajaComando : IRequest<MovimientoListDto>
{
    public long IdCaja { get; set; }
    public long? IdTurnoVendedor { get; set; }
    public long IdTipoMovimiento { get; set; }
    public decimal Monto { get; set; }
    public string Concepto { get; set; } = string.Empty;
    public long UsuarioId { get; set; }
    public string UsuarioNombre { get; set; } = string.Empty;
}

public class ObtenerMovimientosTurnoQuery : IRequest<List<MovimientoListDto>>
{
    public long TurnoVendedorId { get; set; }
}
```

### Criterio de completitud
- [ ] `CierreTurno.cs` tiene exactamente 5 nuevas propiedades con sus atributos `[Column(...)]`
- [ ] `MovimientoCaja.cs` tiene `IdTurnoVendedor` nullable y su navegación FK
- [ ] `TurnosDto.cs` tiene `CierreTurnoDto` extendido y las 4 nuevas clases
- [ ] `TurnosRequests.cs` tiene `MontoFisicoContado` en `CerrarTurnoComando` y las 4 nuevas clases
- [ ] `dotnet build` compila sin errores en `Ventas.API.Domain` y `Ventas.API.Application`

### ⚠️ Trampas comunes

- **NO crear la migración** — solo modificar el código C#. La migración la crea el dev manualmente.
- Flash podría agregar `using` statements innecesarios — verificar que los namespaces ya existan en el archivo antes de agregar.
- `PagedResponse<T>` está en `Nucleo.Comun.Application.Wrappers` — usar el namespace completo o el `using` que ya exista en el archivo de requests si aplica.
- No olvidar el `using` de `System.Collections.Generic` para `List<MovimientoListDto>` si no está presente.

---

## Tarea B — Backend: Manejadores y Endpoints (Agente 2)

**Tiempo estimado:** 60 minutos
**Modo recomendado:** Fast
**Prerequisito:** Tarea A completada y compilando.

### Archivos a crear/modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `Ventas.API.Application/Features/Turnos/TurnosManejadores.cs` | MODIFICAR | Mejorar `CerrarTurnoManejador`, agregar `ObtenerResumenPrevioCierreManejador`, `ObtenerHistorialTurnosManejador`, `RegistrarMovimientoCajaManejador`, `ObtenerMovimientosTurnoManejador` |
| `Ventas.API.API/Endpoints/TurnosEndpoints.cs` | MODIFICAR | Agregar `GET /resumen-previo/{turnoId}` y `GET /historial` |
| `Ventas.API.API/Endpoints/CajaEndpoints.cs` | MODIFICAR | Agregar `POST /`, `PUT /{id}`, `PATCH /{id}/estado`, `POST /{cajaId}/movimientos`, `GET /{cajaId}/movimientos` |
| `Ventas.API.API/Program.cs` | VERIFICAR | Confirmar que nuevos endpoints estén registrados (probablemente ya están si se usa `MapCajaEndpoints`) |

### Especificación detallada

#### 1. Mejorar `CerrarTurnoManejador` en `TurnosManejadores.cs`

El manejador actual tiene hardcodeados `p.IdMetodoPago == 1/2/3`. Reemplazar por lookup con `Codigo` de `MetodoPago`:

```csharp
public async Task<CierreTurnoDto> Handle(CerrarTurnoComando request, CancellationToken cancellationToken)
{
    var turno = await _context.TurnosVendedor
        .Include(t => t.Ventas)
            .ThenInclude(v => v.Pagos)
        .Where(t => t.Id == request.TurnoVendedorId 
               && t.UsuarioVendedorId == request.UsuarioVendedorId 
               && t.Estado == "ABIERTO")
        .FirstOrDefaultAsync(cancellationToken);

    if (turno == null)
        throw new Exception("Turno no encontrado o ya cerrado.");

    // Cargar métodos de pago para mapear por Código (evitar IDs hardcodeados)
    var metodosPago = await _context.MetodosPago.ToListAsync(cancellationToken);
    var idEfectivo = metodosPago.FirstOrDefault(m => m.Codigo == "EFECTIVO")?.Id ?? 0;
    var idTarjeta = metodosPago.FirstOrDefault(m => m.Codigo == "TARJETA")?.Id ?? 0;
    var idTransferencia = metodosPago.FirstOrDefault(m => m.Codigo == "TRANSFERENCIA")?.Id ?? 0;

    var pagos = turno.Ventas
        .Where(v => v.IdEstado != 61 && v.IdEstado != 64 && v.IdEstado != 65) // excluir anulados
        .SelectMany(v => v.Pagos)
        .ToList();

    decimal totalVentas = turno.Ventas
        .Where(v => v.IdEstado != 61 && v.IdEstado != 64 && v.IdEstado != 65)
        .Sum(v => v.TotalVenta);

    decimal totalEfectivo = pagos.Where(p => p.IdMetodoPago == idEfectivo).Sum(p => p.MontoPago);
    decimal totalTarjeta = pagos.Where(p => p.IdMetodoPago == idTarjeta).Sum(p => p.MontoPago);
    decimal totalTransfer = pagos.Where(p => p.IdMetodoPago == idTransferencia).Sum(p => p.MontoPago);
    decimal totalOtros = pagos
        .Where(p => p.IdMetodoPago != idEfectivo && p.IdMetodoPago != idTarjeta && p.IdMetodoPago != idTransferencia)
        .Sum(p => p.MontoPago);

    // Calcular movimientos manuales del turno
    var movimientosTurno = await _context.MovimientosCaja
        .Where(m => m.IdTurnoVendedor == turno.Id && m.IdPagoRelacionado == null)
        .ToListAsync(cancellationToken);

    // Tipo movimiento INGRESO vs EGRESO: verificar por concepto o por tipo
    // Convenio: IdTipoMovimiento par = INGRESO, impar = EGRESO
    // ALTERNATIVA SEGURA: filtrar por Concepto que inicia con "INGRESO" o "EGRESO"
    // Para este proyecto, usamos la convención de que el frontend enviará el IdTipoMovimiento
    // y necesitamos saber si es entrada o salida. Usamos el monto: positivo = ingreso, negativo = egreso
    // El frontend envía monto siempre positivo; el tipo movimiento determina el signo.
    // Por ahora: asumimos que los movimientos sin pago relacionado son manuales.
    // Ingresos manuales = movimientos con Monto > 0 y sin pago relacionado
    // Egresos manuales = movimientos con Monto < 0 y sin pago relacionado
    decimal totalIngresosManualles = movimientosTurno.Where(m => m.Monto > 0).Sum(m => m.Monto);
    decimal totalEgresosManualles = movimientosTurno.Where(m => m.Monto < 0).Sum(m => Math.Abs(m.Monto));

    // MontoEsperado = apertura + efectivo ventas + ingresos manuales - egresos manuales
    decimal montoEsperado = turno.MontoApertura + totalEfectivo + totalIngresosManualles - totalEgresosManualles;

    turno.FechaFin = DateTime.UtcNow;
    turno.Estado = "CERRADO";
    turno.MontoCierre = request.MontoFisicoContado;

    var cierre = new CierreTurno
    {
        TurnoVendedorId = turno.Id,
        FechaGeneracion = DateTime.UtcNow,
        TotalVentas = totalVentas,
        TotalEfectivo = totalEfectivo,
        TotalTarjeta = totalTarjeta,
        TotalTransferencia = totalTransfer,
        TotalOtros = totalOtros,
        CantidadTransacciones = turno.Ventas.Count(v => v.IdEstado != 61 && v.IdEstado != 64 && v.IdEstado != 65),
        TotalIngresosManualles = totalIngresosManualles,
        TotalEgresosManualles = totalEgresosManualles,
        MontoEsperado = montoEsperado,
        MontoFisicoContado = request.MontoFisicoContado,
        DiferenciaArqueo = request.MontoFisicoContado - montoEsperado,
        Observaciones = request.Observaciones,
        Estado = "CONFIRMADO"
    };

    _context.CierresTurno.Add(cierre);
    await _context.SaveChangesAsync(cancellationToken);

    return new CierreTurnoDto
    {
        Id = cierre.Id,
        TurnoVendedorId = cierre.TurnoVendedorId,
        FechaGeneracion = cierre.FechaGeneracion,
        TotalVentas = cierre.TotalVentas,
        TotalEfectivo = cierre.TotalEfectivo,
        TotalTarjeta = cierre.TotalTarjeta,
        TotalTransferencia = cierre.TotalTransferencia,
        TotalOtros = cierre.TotalOtros,
        CantidadTransacciones = cierre.CantidadTransacciones,
        TotalIngresosManualles = cierre.TotalIngresosManualles,
        TotalEgresosManualles = cierre.TotalEgresosManualles,
        MontoEsperado = cierre.MontoEsperado,
        MontoFisicoContado = cierre.MontoFisicoContado,
        DiferenciaArqueo = cierre.DiferenciaArqueo,
        Observaciones = cierre.Observaciones,
        Estado = cierre.Estado
    };
}
```

#### 2. Agregar `ObtenerResumenPrevioCierreManejador` (nueva clase en el mismo archivo)

```csharp
public class ObtenerResumenPrevioCierreManejador : IRequestHandler<ObtenerResumenPrevioCierreQuery, TurnoResumenPrevioDto>
{
    private readonly IVentasDbContext _context;

    public ObtenerResumenPrevioCierreManejador(IVentasDbContext context)
    {
        _context = context;
    }

    public async Task<TurnoResumenPrevioDto> Handle(ObtenerResumenPrevioCierreQuery request, CancellationToken cancellationToken)
    {
        var turno = await _context.TurnosVendedor
            .Include(t => t.Ventas)
                .ThenInclude(v => v.Pagos)
            .Where(t => t.Id == request.TurnoVendedorId && t.Estado == "ABIERTO")
            .FirstOrDefaultAsync(cancellationToken);

        if (turno == null)
            throw new Exception("Turno no encontrado o ya cerrado.");

        // Verificar que el usuario sea el dueño del turno
        if (turno.UsuarioVendedorId != request.UsuarioVendedorId)
            throw new Exception("No tienes permiso para ver este turno.");

        var metodosPago = await _context.MetodosPago.ToListAsync(cancellationToken);
        var idEfectivo = metodosPago.FirstOrDefault(m => m.Codigo == "EFECTIVO")?.Id ?? 0;
        var idTarjeta = metodosPago.FirstOrDefault(m => m.Codigo == "TARJETA")?.Id ?? 0;
        var idTransferencia = metodosPago.FirstOrDefault(m => m.Codigo == "TRANSFERENCIA")?.Id ?? 0;

        var ventasActivas = turno.Ventas
            .Where(v => v.IdEstado != 61 && v.IdEstado != 64 && v.IdEstado != 65)
            .ToList();
        var pagos = ventasActivas.SelectMany(v => v.Pagos).ToList();

        decimal totalEfectivo = pagos.Where(p => p.IdMetodoPago == idEfectivo).Sum(p => p.MontoPago);
        decimal totalTarjeta = pagos.Where(p => p.IdMetodoPago == idTarjeta).Sum(p => p.MontoPago);
        decimal totalTransferencia = pagos.Where(p => p.IdMetodoPago == idTransferencia).Sum(p => p.MontoPago);
        decimal totalOtros = pagos
            .Where(p => p.IdMetodoPago != idEfectivo && p.IdMetodoPago != idTarjeta && p.IdMetodoPago != idTransferencia)
            .Sum(p => p.MontoPago);

        var movimientosManuales = await _context.MovimientosCaja
            .Where(m => m.IdTurnoVendedor == turno.Id && m.IdPagoRelacionado == null)
            .ToListAsync(cancellationToken);

        decimal totalIngresos = movimientosManuales.Where(m => m.Monto > 0).Sum(m => m.Monto);
        decimal totalEgresos = movimientosManuales.Where(m => m.Monto < 0).Sum(m => Math.Abs(m.Monto));
        decimal montoEsperado = turno.MontoApertura + totalEfectivo + totalIngresos - totalEgresos;

        return new TurnoResumenPrevioDto
        {
            TurnoId = turno.Id,
            MontoApertura = turno.MontoApertura,
            TotalVentas = ventasActivas.Sum(v => v.TotalVenta),
            TotalEfectivo = totalEfectivo,
            TotalTarjeta = totalTarjeta,
            TotalTransferencia = totalTransferencia,
            TotalOtros = totalOtros,
            TotalIngresosManualles = totalIngresos,
            TotalEgresosManualles = totalEgresos,
            MontoEsperadoEnCaja = montoEsperado,
            CantidadVentas = ventasActivas.Count,
            MovimientosManuales = movimientosManuales.Select(m => new MovimientoListDto
            {
                Id = m.Id,
                IdCaja = m.IdCaja,
                IdTurnoVendedor = m.IdTurnoVendedor,
                Monto = m.Monto,
                Concepto = m.Concepto,
                FechaMovimiento = m.FechaMovimiento,
                UsuarioResponsable = m.UsuarioResponsable
            }).ToList()
        };
    }
}
```

#### 3. Agregar `RegistrarMovimientoCajaManejador` (nueva clase en el mismo archivo)

```csharp
public class RegistrarMovimientoCajaManejador : IRequestHandler<RegistrarMovimientoCajaComando, MovimientoListDto>
{
    private readonly IVentasDbContext _context;

    public RegistrarMovimientoCajaManejador(IVentasDbContext context)
    {
        _context = context;
    }

    public async Task<MovimientoListDto> Handle(RegistrarMovimientoCajaComando request, CancellationToken cancellationToken)
    {
        if (request.Monto == 0)
            throw new Exception("El monto no puede ser cero.");

        var movimiento = new MovimientoCaja
        {
            IdCaja = request.IdCaja,
            IdTurnoVendedor = request.IdTurnoVendedor,
            IdTipoMovimiento = request.IdTipoMovimiento,
            Monto = request.Monto, // positivo = ingreso, negativo = egreso
            Concepto = request.Concepto,
            FechaMovimiento = DateTime.UtcNow,
            UsuarioResponsable = request.UsuarioNombre
        };

        _context.MovimientosCaja.Add(movimiento);
        await _context.SaveChangesAsync(cancellationToken);

        return new MovimientoListDto
        {
            Id = movimiento.Id,
            IdCaja = movimiento.IdCaja,
            IdTurnoVendedor = movimiento.IdTurnoVendedor,
            IdTipoMovimiento = movimiento.IdTipoMovimiento,
            Monto = movimiento.Monto,
            Concepto = movimiento.Concepto,
            FechaMovimiento = movimiento.FechaMovimiento,
            UsuarioResponsable = movimiento.UsuarioResponsable
        };
    }
}
```

#### 4. Agregar `ObtenerHistorialTurnosManejador` con Dapper (nueva clase en el mismo archivo)

```csharp
public class ObtenerHistorialTurnosManejador : IRequestHandler<ObtenerHistorialTurnosQuery, Nucleo.Comun.Application.Wrappers.PagedResponse<TurnoHistorialDto>>
{
    private readonly IVentasDbContext _context;

    public ObtenerHistorialTurnosManejador(IVentasDbContext context)
    {
        _context = context;
    }

    public async Task<Nucleo.Comun.Application.Wrappers.PagedResponse<TurnoHistorialDto>> Handle(ObtenerHistorialTurnosQuery request, CancellationToken cancellationToken)
    {
        var connection = _context.Database.GetDbConnection();
        if (connection.State != System.Data.ConnectionState.Open)
            await connection.OpenAsync(cancellationToken);

        var offset = (request.PageNumber - 1) * request.PageSize;

        var whereClause = new System.Text.StringBuilder("WHERE tv.activado = true");
        var parametros = new Dapper.DynamicParameters();
        parametros.Add("pageSize", request.PageSize);
        parametros.Add("offset", offset);

        if (request.CajaId.HasValue)
        {
            whereClause.Append(" AND tv.id_caja = @cajaId");
            parametros.Add("cajaId", request.CajaId.Value);
        }
        if (!string.IsNullOrWhiteSpace(request.Estado))
        {
            whereClause.Append(" AND tv.estado = @estado");
            parametros.Add("estado", request.Estado);
        }
        if (request.FechaDesde.HasValue)
        {
            whereClause.Append(" AND tv.fecha_inicio >= @fechaDesde");
            parametros.Add("fechaDesde", request.FechaDesde.Value);
        }
        if (request.FechaHasta.HasValue)
        {
            whereClause.Append(" AND tv.fecha_inicio <= @fechaHasta");
            parametros.Add("fechaHasta", request.FechaHasta.Value);
        }

        var sql = $@"
            SELECT
                tv.id_turno_vendedor AS Id,
                tv.id_caja AS CajaId,
                c.nombre_caja AS NombreCaja,
                tv.id_usuario_vendedor AS UsuarioVendedorId,
                '' AS NombreVendedor,
                tv.fecha_inicio AS FechaInicio,
                tv.fecha_fin AS FechaFin,
                tv.monto_apertura AS MontoApertura,
                tv.monto_cierre AS MontoCierre,
                tv.estado AS Estado,
                COALESCE(SUM(v.total_venta) FILTER (WHERE v.id_estado NOT IN (61,64,65)), 0) AS TotalVentas,
                COUNT(v.id_venta) FILTER (WHERE v.id_estado NOT IN (61,64,65)) AS CantidadTransacciones,
                COUNT(*) OVER() AS Total
            FROM ventas.turno_vendedor tv
            INNER JOIN ventas.cajas c ON c.id_caja = tv.id_caja
            LEFT JOIN ventas.ventas v ON v.id_turno_vendedor = tv.id_turno_vendedor
            {whereClause}
            GROUP BY tv.id_turno_vendedor, tv.id_caja, c.nombre_caja, tv.id_usuario_vendedor,
                     tv.fecha_inicio, tv.fecha_fin, tv.monto_apertura, tv.monto_cierre, tv.estado
            ORDER BY tv.fecha_inicio DESC
            LIMIT @pageSize OFFSET @offset";

        var rows = (await Dapper.SqlMapper.QueryAsync<TurnoHistorialDto>(connection, sql, parametros)).ToList();
        var total = rows.FirstOrDefault()?.Total ?? 0;

        return new Nucleo.Comun.Application.Wrappers.PagedResponse<TurnoHistorialDto>(
            rows, request.PageNumber, request.PageSize, total);
    }
}
```

#### 5. Agregar `ObtenerMovimientosTurnoManejador` (nueva clase en el mismo archivo)

```csharp
public class ObtenerMovimientosTurnoManejador : IRequestHandler<ObtenerMovimientosTurnoQuery, List<MovimientoListDto>>
{
    private readonly IVentasDbContext _context;

    public ObtenerMovimientosTurnoManejador(IVentasDbContext context)
    {
        _context = context;
    }

    public async Task<List<MovimientoListDto>> Handle(ObtenerMovimientosTurnoQuery request, CancellationToken cancellationToken)
    {
        return await _context.MovimientosCaja
            .Where(m => m.IdTurnoVendedor == request.TurnoVendedorId && m.IdPagoRelacionado == null)
            .OrderBy(m => m.FechaMovimiento)
            .Select(m => new MovimientoListDto
            {
                Id = m.Id,
                IdCaja = m.IdCaja,
                IdTurnoVendedor = m.IdTurnoVendedor,
                IdTipoMovimiento = m.IdTipoMovimiento,
                Monto = m.Monto,
                Concepto = m.Concepto,
                FechaMovimiento = m.FechaMovimiento,
                UsuarioResponsable = m.UsuarioResponsable
            })
            .ToListAsync(cancellationToken);
    }
}
```

#### 6. Modificar `TurnosEndpoints.cs`

Agregar dentro de `MapTurnosEndpoints` DESPUÉS del endpoint `/actual`:

```csharp
group.MapGet("/resumen-previo/{turnoId:long}", async (
    long turnoId,
    [FromHeader(Name = "X-User-Id")] string userIdHeader,
    [FromServices] IMediator mediator) =>
{
    if (!long.TryParse(userIdHeader, out long userId)) return Results.Unauthorized();
    var query = new ObtenerResumenPrevioCierreQuery { TurnoVendedorId = turnoId, UsuarioVendedorId = userId };
    var result = await mediator.Send(query);
    return Results.Ok(result);
})
.WithName("ObtenerResumenPrevioCierre")
.Produces<TurnoResumenPrevioDto>(StatusCodes.Status200OK);

group.MapGet("/historial", async (
    [FromQuery] int pageNumber,
    [FromQuery] int pageSize,
    [FromQuery] long? cajaId,
    [FromQuery] string? estado,
    [FromQuery] DateTime? fechaDesde,
    [FromQuery] DateTime? fechaHasta,
    [FromServices] IMediator mediator) =>
{
    var query = new ObtenerHistorialTurnosQuery
    {
        PageNumber = pageNumber <= 0 ? 1 : pageNumber,
        PageSize = pageSize <= 0 ? 20 : pageSize,
        CajaId = cajaId,
        Estado = estado,
        FechaDesde = fechaDesde,
        FechaHasta = fechaHasta
    };
    var result = await mediator.Send(query);
    return Results.Ok(result);
})
.WithName("ObtenerHistorialTurnos")
.Produces<Nucleo.Comun.Application.Wrappers.PagedResponse<TurnoHistorialDto>>(StatusCodes.Status200OK);
```

También modificar el endpoint `/cerrar` para aceptar `MontoFisicoContado` del body (ya está en `CerrarTurnoComando`, no requiere cambio en el endpoint si el body lo deserializa correctamente).

#### 7. Modificar `CajaEndpoints.cs`

Ampliar con CRUD completo + movimientos:

```csharp
// Ya existentes: GET / y GET /{id}

// NUEVO: Crear caja
grupo.MapPost("/", async ([FromBody] CrearCajaRequest request, [FromHeader(Name = "X-User-Id")] string userIdHeader, [FromServices] IMediator mediator) =>
{
    if (!long.TryParse(userIdHeader, out long userId)) return Results.Unauthorized();
    request.UsuarioId = userId;
    var result = await mediator.Send(request);
    return Results.Created($"/api/cajas/{result.Id}", result);
})
.WithName("CrearCaja");

// NUEVO: Actualizar caja
grupo.MapPut("/{id:long}", async (long id, [FromBody] ActualizarCajaRequest request, [FromServices] IMediator mediator) =>
{
    request.Id = id;
    var result = await mediator.Send(request);
    return result != null ? Results.Ok(result) : Results.NotFound();
})
.WithName("ActualizarCaja");

// NUEVO: Cambiar estado (activar/desactivar)
grupo.MapPatch("/{id:long}/estado", async (long id, [FromBody] CambiarEstadoCajaRequest request, [FromServices] IMediator mediator) =>
{
    request.Id = id;
    var result = await mediator.Send(request);
    return Results.Ok(result);
})
.WithName("CambiarEstadoCaja");

// NUEVO: Registrar movimiento de caja
grupo.MapPost("/{cajaId:long}/movimientos", async (
    long cajaId,
    [FromBody] RegistrarMovimientoRequest body,
    [FromHeader(Name = "X-User-Id")] string userIdHeader,
    [FromHeader(Name = "X-User-Nombre")] string? userNombreHeader,
    [FromServices] IMediator mediator) =>
{
    if (!long.TryParse(userIdHeader, out long userId)) return Results.Unauthorized();
    var comando = new RegistrarMovimientoCajaComando
    {
        IdCaja = cajaId,
        IdTurnoVendedor = body.IdTurnoVendedor,
        IdTipoMovimiento = body.IdTipoMovimiento,
        Monto = body.Monto,
        Concepto = body.Concepto,
        UsuarioId = userId,
        UsuarioNombre = userNombreHeader ?? userId.ToString()
    };
    var result = await mediator.Send(comando);
    return Results.Created($"/api/cajas/{cajaId}/movimientos/{result.Id}", result);
})
.WithName("RegistrarMovimientoCaja");

// NUEVO: Listar movimientos del turno
grupo.MapGet("/{cajaId:long}/movimientos", async (
    long cajaId,
    [FromQuery] long turnoId,
    [FromServices] IMediator mediator) =>
{
    var query = new ObtenerMovimientosTurnoQuery { TurnoVendedorId = turnoId };
    var result = await mediator.Send(query);
    return Results.Ok(result);
})
.WithName("ObtenerMovimientosCaja");
```

**NOTA:** Agregar al inicio del archivo de `CajaEndpoints.cs` los usings necesarios:
```csharp
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Features.Turnos;
```

Además, agregar en `TurnosRequests.cs` las clases para el CRUD de cajas:

```csharp
public class CrearCajaRequest : IRequest<Caja>
{
    public string NombreCaja { get; set; } = string.Empty;
    public long IdAlmacen { get; set; }
    public long UsuarioId { get; set; }
}

public class ActualizarCajaRequest : IRequest<Caja?>
{
    public long Id { get; set; }
    public string NombreCaja { get; set; } = string.Empty;
    public long IdAlmacen { get; set; }
}

public class CambiarEstadoCajaRequest : IRequest<Caja>
{
    public long Id { get; set; }
    public bool Activado { get; set; }
}
```

Y en `TurnosManejadores.cs` los manejadores de CRUD:

```csharp
public class CrearCajaManejador : IRequestHandler<CrearCajaRequest, Caja>
{
    private readonly IVentasDbContext _context;
    public CrearCajaManejador(IVentasDbContext context) { _context = context; }
    public async Task<Caja> Handle(CrearCajaRequest request, CancellationToken cancellationToken)
    {
        var caja = new Caja
        {
            NombreCaja = request.NombreCaja,
            IdAlmacen = request.IdAlmacen,
            IdEstado = 60, // Registrado/Activo según tablas generales
            MontoApertura = 0,
            MontoActual = 0
        };
        _context.Cajas.Add(caja);
        await _context.SaveChangesAsync(cancellationToken);
        return caja;
    }
}

public class ActualizarCajaManejador : IRequestHandler<ActualizarCajaRequest, Caja?>
{
    private readonly IVentasDbContext _context;
    public ActualizarCajaManejador(IVentasDbContext context) { _context = context; }
    public async Task<Caja?> Handle(ActualizarCajaRequest request, CancellationToken cancellationToken)
    {
        var caja = await _context.Cajas.FindAsync(new object[] { request.Id }, cancellationToken);
        if (caja == null) return null;
        caja.NombreCaja = request.NombreCaja;
        caja.IdAlmacen = request.IdAlmacen;
        await _context.SaveChangesAsync(cancellationToken);
        return caja;
    }
}

public class CambiarEstadoCajaManejador : IRequestHandler<CambiarEstadoCajaRequest, Caja>
{
    private readonly IVentasDbContext _context;
    public CambiarEstadoCajaManejador(IVentasDbContext context) { _context = context; }
    public async Task<Caja> Handle(CambiarEstadoCajaRequest request, CancellationToken cancellationToken)
    {
        var caja = await _context.Cajas.FindAsync(new object[] { request.Id }, cancellationToken)
            ?? throw new Exception("Caja no encontrada.");
        caja.Activado = request.Activado;
        await _context.SaveChangesAsync(cancellationToken);
        return caja;
    }
}
```

**NOTA sobre `Activado`:** La propiedad `Activado` viene de `EntidadBase`. Si en la entidad `Caja.cs` no está declarada explícitamente, está heredada. No redeclararla.

### Criterio de completitud
- [ ] `TurnosManejadores.cs` tiene 7 clases manejadoras (las 2 originales mejoradas + 5 nuevas)
- [ ] `TurnosEndpoints.cs` tiene `/resumen-previo/{turnoId}` y `/historial` registrados
- [ ] `CajaEndpoints.cs` tiene `POST /`, `PUT /{id}`, `PATCH /{id}/estado`, `POST /{cajaId}/movimientos`, `GET /{cajaId}/movimientos`
- [ ] No hay hardcodeados `p.IdMetodoPago == 1/2/3` — se usa lookup por `Codigo`
- [ ] `dotnet build` compila sin errores en toda la solución

### ⚠️ Trampas comunes

- **El `using Dapper;` debe estar en el archivo** del manejador del historial — agregar si no está.
- **`COALESCE(SUM(...) FILTER (WHERE ...), 0)`** en PostgreSQL es la forma correcta — no usar `ISNULL` (es SQL Server).
- **`COUNT(*) OVER()`** para paginación — no dos queries separadas.
- **`Activado` viene de `EntidadBase`** — no redeclararla en `Caja.cs` o fallará por duplicado.
- En `CajaEndpoints.cs`, el header `X-User-Nombre` puede no existir — usar `?? userId.ToString()` como fallback.
- **`ObtenerMovimientosTurnoManejador`** filtra `m.IdPagoRelacionado == null` — los pagos de ventas NO son movimientos manuales.
- Al agregar `using MediatR;` a `CajaEndpoints.cs`, verificar que no estaba ya presente antes de agregarlo.

---

## Tarea C — Frontend: Servicios y Tipos (Agente 3)

**Tiempo estimado:** 30 minutos
**Modo recomendado:** Fast
**Prerequisito:** Tarea B completada.

### Archivos a crear/modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `features/ventas/tipos/ventas.types.ts` | MODIFICAR | Extender tipos de turno/cierre con nuevos campos de arqueo |
| `features/ventas/servicios/turnoService.ts` | MODIFICAR | Agregar `obtenerResumenPrevioCierre()` y `obtenerHistorialTurnos()` |
| `features/ventas/servicios/servicioCajas.ts` | CREAR | CRUD de cajas + movimientos |

### Especificación detallada

#### 1. Modificar `ventas.types.ts`

Extender `CierreTurnoDto` (en `turnoService.ts`, ya que en `ventas.types.ts` solo están los tipos de lista/detalle de ventas). **IMPORTANTE:** Los tipos de turno están en `turnoService.ts`, NO en `ventas.types.ts`. Modificar el archivo correcto.

Agregar en `ventas.types.ts` (al final del bloque CAJA):

```typescript
export interface MovimientoCajaDetalle {
  id: number;
  idCaja: number;
  idTurnoVendedor?: number;
  idTipoMovimiento: number;
  tipoMovimientoNombre: string;
  monto: number; // positivo = ingreso, negativo = egreso
  concepto: string;
  fechaMovimiento: string;
  usuarioResponsable: string;
}

export interface TurnoHistorialItem {
  id: number;
  cajaId: number;
  nombreCaja: string;
  usuarioVendedorId: number;
  nombreVendedor: string;
  fechaInicio: string;
  fechaFin?: string;
  montoApertura: number;
  montoCierre?: number;
  estado: 'ABIERTO' | 'CERRADO';
  totalVentas: number;
  cantidadTransacciones: number;
  total: number; // paginación
}

export interface TurnoResumenPrevio {
  turnoId: number;
  montoApertura: number;
  totalVentas: number;
  totalEfectivo: number;
  totalTarjeta: number;
  totalTransferencia: number;
  totalOtros: number;
  totalIngresosManualles: number;
  totalEgresosManualles: number;
  montoEsperadoEnCaja: number;
  cantidadVentas: number;
  movimientosManuales: MovimientoCajaDetalle[];
}

export interface CajaListItem {
  id: number;
  nombreCaja: string;
  idAlmacen: number;
  idEstado: number;
  montoApertura: number;
  montoActual: number;
  activado: boolean;
}
```

#### 2. Modificar `turnoService.ts`

Extender la interfaz `CierreTurnoDto` con los nuevos campos:

```typescript
export interface CierreTurnoDto {
    id: number;
    turnoVendedorId: number;
    fechaGeneracion: string;
    totalVentas: number;
    totalEfectivo: number;
    totalTarjeta: number;
    totalTransferencia: number;
    totalOtros: number;
    cantidadTransacciones: number;
    observaciones?: string;
    estado: string;
    // Nuevos campos de arqueo:
    totalIngresosManualles: number;
    totalEgresosManualles: number;
    montoEsperado: number;
    montoFisicoContado: number;
    diferenciaArqueo: number;
}
```

Extender `cerrarTurno()` para enviar `montoFisicoContado`:

```typescript
cerrarTurno: async (turnoVendedorId: number, montoFisicoContado: number, observaciones?: string): Promise<CierreTurnoDto> => {
    const token = localStorage.getItem('sc_token');
    const response = await axios.post<CierreTurnoDto>(`${apiGatewayURL}/api/turnos/cerrar`, 
        { turnoVendedorId, montoFisicoContado, observaciones },
        { headers: { 'Authorization': `Bearer ${token}` } }
    );
    return response.data;
},
```

Agregar los nuevos métodos:

```typescript
obtenerResumenPrevioCierre: async (turnoId: number): Promise<TurnoResumenPrevio> => {
    const token = localStorage.getItem('sc_token');
    const response = await axios.get<TurnoResumenPrevio>(
        `${apiGatewayURL}/api/turnos/resumen-previo/${turnoId}`,
        { headers: { 'Authorization': `Bearer ${token}` } }
    );
    return response.data;
},

obtenerHistorialTurnos: async (params: {
    pageNumber?: number;
    pageSize?: number;
    cajaId?: number;
    estado?: string;
    fechaDesde?: string;
    fechaHasta?: string;
}): Promise<{ datos: TurnoHistorialItem[]; total: number; totalPages: number }> => {
    const token = localStorage.getItem('sc_token');
    const response = await axios.get(`${apiGatewayURL}/api/turnos/historial`, {
        params,
        headers: { 'Authorization': `Bearer ${token}` }
    });
    return response.data;
},
```

Agregar el import de `TurnoResumenPrevio` y `TurnoHistorialItem` desde ventas.types.ts arriba del archivo:

```typescript
import type { TurnoResumenPrevio, TurnoHistorialItem } from '../tipos/ventas.types';
```

#### 3. Crear `servicioCajas.ts`

```typescript
import axios from 'axios';
import { apiGatewayURL } from '@/compartido/configuracion/entorno.config';
import type { CajaListItem, MovimientoCajaDetalle } from '../tipos/ventas.types';

const getHeaders = () => ({
    'Authorization': `Bearer ${localStorage.getItem('sc_token')}`
});

export const servicioCajas = {
    obtenerTodas: async (): Promise<CajaListItem[]> => {
        const response = await axios.get<{ data: CajaListItem[] }>(`${apiGatewayURL}/api/cajas`, {
            headers: getHeaders()
        });
        // El endpoint actual devuelve ToReturnList<Caja> que tiene propiedad 'data'
        return response.data.data ?? [];
    },

    crear: async (data: { nombreCaja: string; idAlmacen: number }): Promise<CajaListItem> => {
        const response = await axios.post<CajaListItem>(`${apiGatewayURL}/api/cajas`, data, {
            headers: getHeaders()
        });
        return response.data;
    },

    actualizar: async (id: number, data: { nombreCaja: string; idAlmacen: number }): Promise<CajaListItem> => {
        const response = await axios.put<CajaListItem>(`${apiGatewayURL}/api/cajas/${id}`, data, {
            headers: getHeaders()
        });
        return response.data;
    },

    cambiarEstado: async (id: number, activado: boolean): Promise<void> => {
        await axios.patch(`${apiGatewayURL}/api/cajas/${id}/estado`, { activado }, {
            headers: getHeaders()
        });
    },

    registrarMovimiento: async (cajaId: number, data: {
        idTurnoVendedor?: number;
        idTipoMovimiento: number;
        monto: number; // positivo = ingreso, negativo = egreso
        concepto: string;
    }): Promise<MovimientoCajaDetalle> => {
        const response = await axios.post<MovimientoCajaDetalle>(
            `${apiGatewayURL}/api/cajas/${cajaId}/movimientos`,
            data,
            { headers: getHeaders() }
        );
        return response.data;
    },

    obtenerMovimientosTurno: async (cajaId: number, turnoId: number): Promise<MovimientoCajaDetalle[]> => {
        const response = await axios.get<MovimientoCajaDetalle[]>(
            `${apiGatewayURL}/api/cajas/${cajaId}/movimientos`,
            { params: { turnoId }, headers: getHeaders() }
        );
        return response.data ?? [];
    }
};
```

### Criterio de completitud
- [ ] `ventas.types.ts` exporta `MovimientoCajaDetalle`, `TurnoHistorialItem`, `TurnoResumenPrevio`, `CajaListItem`
- [ ] `turnoService.ts` — `CierreTurnoDto` tiene los 5 campos de arqueo
- [ ] `turnoService.ts` — `cerrarTurno()` acepta y envía `montoFisicoContado`
- [ ] `turnoService.ts` — tiene `obtenerResumenPrevioCierre()` y `obtenerHistorialTurnos()`
- [ ] `servicioCajas.ts` creado con las 6 funciones
- [ ] `npx tsc --noEmit` sin errores en el módulo de ventas

### ⚠️ Trampas comunes

- **Los tipos de turno están en `turnoService.ts`, no en `ventas.types.ts`** — extender el archivo correcto.
- **`ToReturnList<Caja>` del backend devuelve `{ data: [...] }`** — acceder como `response.data.data`.
- **No romper la firma de `cerrarTurno()`** — el `ModalCierreTurno` existente la llama con `(turnoId, observaciones)`. Cambiar a `(turnoId, montoFisicoContado, observaciones)` con `observaciones` opcional al final.
- **El import de tipos debe ir al TOPE del archivo** antes de cualquier `const` o `export`.

---

## Tarea D — Frontend: POS Mejorado — Modales (Agente 4)

**Tiempo estimado:** 60 minutos
**Modo recomendado:** Planning
**Prerequisito:** Tarea C completada.

### Archivos a crear/modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `componentes/pos/ModalAperturaTurno.tsx` | REESCRIBIR | Cargar cajas reales desde API en lugar de hardcodeadas |
| `componentes/pos/ModalCierreTurno.tsx` | REESCRIBIR | Mostrar resumen real + campo arqueo + diferencia |
| `componentes/pos/ModalMovimientoCaja.tsx` | CREAR | Modal ingreso/egreso manual |
| `paginas/PaginaPOS.tsx` | MODIFICAR | Agregar botón "Movimiento de Caja" + integrar nuevo modal |

### Especificación detallada

#### 1. Reescribir `ModalAperturaTurno.tsx`

El modal actual hardcodea las cajas. Reemplazar el `Select` estático por datos reales de la API:

```tsx
import { useState, useEffect } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '@/componentes/ui/dialog';
import { Button } from '@/componentes/ui/button';
import { Input } from '@/componentes/ui/input';
import { Label } from '@/componentes/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/componentes/ui/select';
import { turnoService, TurnoVendedorDto } from '../../servicios/turnoService';
import { servicioCajas } from '../../servicios/servicioCajas';
import { toast } from 'sonner';
import { Wallet, Store, ArrowRightCircle, Loader2 } from 'lucide-react';
import type { CajaListItem } from '../../tipos/ventas.types';

interface ModalAperturaTurnoProps {
    isOpen: boolean;
    onSuccess: (turno: TurnoVendedorDto) => void;
}

export const ModalAperturaTurno = ({ isOpen, onSuccess }: ModalAperturaTurnoProps) => {
    const [cajas, setCajas] = useState<CajaListItem[]>([]);
    const [cajaId, setCajaId] = useState<string>('');
    const [monto, setMonto] = useState<string>('0.00');
    const [loading, setLoading] = useState(false);
    const [cargandoCajas, setCargandoCajas] = useState(true);

    useEffect(() => {
        const cargarCajas = async () => {
            try {
                const data = await servicioCajas.obtenerTodas();
                // Filtrar solo cajas activas
                const cajasActivas = data.filter(c => c.activado !== false);
                setCajas(cajasActivas);
                if (cajasActivas.length > 0) {
                    setCajaId(String(cajasActivas[0].id));
                }
            } catch {
                toast.error('No se pudieron cargar las cajas disponibles');
            } finally {
                setCargandoCajas(false);
            }
        };
        if (isOpen) cargarCajas();
    }, [isOpen]);

    const handleAbrir = async () => {
        if (!cajaId) { toast.error('Selecciona una caja'); return; }
        setLoading(true);
        try {
            const m = parseFloat(monto);
            if (isNaN(m) || m < 0) { toast.error('Monto de apertura inválido'); return; }
            const turno = await turnoService.abrirTurno(parseInt(cajaId), m);
            toast.success('Turno abierto exitosamente');
            onSuccess(turno);
        } catch (error: any) {
            toast.error(error.response?.data || 'Error al abrir turno');
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={isOpen} onOpenChange={() => {}}>
            <DialogContent className="sm:max-w-[425px] border-none shadow-2xl">
                <DialogHeader>
                    <div className="mx-auto bg-primary/10 p-3 rounded-full w-fit mb-2">
                        <Store className="h-6 w-6 text-primary" />
                    </div>
                    <DialogTitle className="text-2xl font-bold text-center">Apertura de Caja</DialogTitle>
                    <DialogDescription className="text-center">
                        Selecciona la caja e ingresa el monto inicial para iniciar tu jornada.
                    </DialogDescription>
                </DialogHeader>
                <div className="grid gap-6 py-4">
                    <div className="space-y-2">
                        <Label htmlFor="caja">Seleccionar Caja</Label>
                        {cargandoCajas ? (
                            <div className="flex items-center gap-2 h-12 px-3 border rounded-md bg-slate-50">
                                <Loader2 className="h-4 w-4 animate-spin" />
                                <span className="text-sm text-muted-foreground">Cargando cajas...</span>
                            </div>
                        ) : (
                            <Select value={cajaId} onValueChange={setCajaId} disabled={cajas.length === 0}>
                                <SelectTrigger className="h-12 bg-slate-50 dark:bg-slate-900 border-slate-200">
                                    <SelectValue placeholder={cajas.length === 0 ? 'No hay cajas disponibles' : 'Seleccione una caja'} />
                                </SelectTrigger>
                                <SelectContent>
                                    {cajas.map(caja => (
                                        <SelectItem key={caja.id} value={String(caja.id)}>
                                            {caja.nombreCaja}
                                        </SelectItem>
                                    ))}
                                </SelectContent>
                            </Select>
                        )}
                    </div>
                    <div className="space-y-2">
                        <Label htmlFor="monto">Monto Inicial (Soles)</Label>
                        <div className="relative">
                            <Wallet className="absolute left-3 top-3 h-5 w-5 text-muted-foreground" />
                            <Input
                                id="monto"
                                type="number"
                                step="0.01"
                                className="pl-10 h-12 text-lg font-semibold bg-slate-50 dark:bg-slate-900 border-slate-200"
                                value={monto}
                                onChange={(e) => setMonto(e.target.value)}
                            />
                        </div>
                    </div>
                </div>
                <DialogFooter>
                    <Button
                        onClick={handleAbrir}
                        className="w-full h-12 text-base"
                        disabled={loading || cargandoCajas || !cajaId}
                    >
                        {loading ? <Loader2 className="h-5 w-5 animate-spin mr-2" /> : null}
                        {loading ? 'Abriendo...' : (
                            <div className="flex items-center gap-2">
                                Iniciar Jornada <ArrowRightCircle className="h-5 w-5" />
                            </div>
                        )}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
};
```

#### 2. Reescribir `ModalCierreTurno.tsx`

El modal actual muestra ceros. Reescribir para: (1) cargar resumen real al abrir, (2) permitir ingresar monto físico, (3) mostrar diferencia calculada.

```tsx
import { useState, useEffect } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '@/componentes/ui/dialog';
import { Button } from '@/componentes/ui/button';
import { Textarea } from '@/componentes/ui/textarea';
import { Input } from '@/componentes/ui/input';
import { Label } from '@/componentes/ui/label';
import { turnoService, CierreTurnoDto } from '../../servicios/turnoService';
import { toast } from 'sonner';
import { ClipboardCheck, CreditCard, Landmark, AlertCircle, Loader2, ArrowDownUp, Banknote } from 'lucide-react';
import { formatearMoneda } from '@/compartido/utilidades/moneda';
import type { TurnoResumenPrevio } from '../../tipos/ventas.types';

interface ModalCierreTurnoProps {
    isOpen: boolean;
    onClose: () => void;
    turnoId: number;
    onSuccess: (cierre: CierreTurnoDto) => void;
}

export const ModalCierreTurno = ({ isOpen, onClose, turnoId, onSuccess }: ModalCierreTurnoProps) => {
    const [resumen, setResumen] = useState<TurnoResumenPrevio | null>(null);
    const [observaciones, setObservaciones] = useState('');
    const [montoFisico, setMontoFisico] = useState<string>('0.00');
    const [loading, setLoading] = useState(false);
    const [cargandoResumen, setCargandoResumen] = useState(true);

    const diferencia = resumen
        ? parseFloat(montoFisico || '0') - resumen.montoEsperadoEnCaja
        : 0;

    useEffect(() => {
        const cargarResumen = async () => {
            if (!isOpen || !turnoId) return;
            setCargandoResumen(true);
            try {
                const data = await turnoService.obtenerResumenPrevioCierre(turnoId);
                setResumen(data);
                setMontoFisico(data.montoEsperadoEnCaja.toFixed(2));
            } catch {
                toast.error('No se pudo cargar el resumen del turno');
            } finally {
                setCargandoResumen(false);
            }
        };
        cargarResumen();
    }, [isOpen, turnoId]);

    const handleCerrar = async () => {
        setLoading(true);
        try {
            const monto = parseFloat(montoFisico || '0');
            if (isNaN(monto) || monto < 0) { toast.error('Monto físico inválido'); return; }
            const cierre = await turnoService.cerrarTurno(turnoId, monto, observaciones);
            toast.success('Caja cerrada exitosamente');
            onSuccess(cierre);
        } catch (error: any) {
            toast.error(error.response?.data || 'Error al cerrar caja');
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="sm:max-w-[560px] border-none shadow-2xl max-h-[90vh] overflow-y-auto">
                <DialogHeader>
                    <div className="mx-auto bg-amber-100 p-3 rounded-full w-fit mb-2">
                        <ClipboardCheck className="h-6 w-6 text-amber-600" />
                    </div>
                    <DialogTitle className="text-2xl font-bold text-center">Cierre de Caja</DialogTitle>
                    <DialogDescription className="text-center">
                        Revisa el resumen de ventas e ingresa el monto físico contado.
                    </DialogDescription>
                </DialogHeader>

                {cargandoResumen ? (
                    <div className="flex items-center justify-center py-8">
                        <Loader2 className="h-8 w-8 animate-spin text-primary" />
                    </div>
                ) : resumen ? (
                    <div className="py-4 space-y-4">
                        {/* Totales de ventas */}
                        <div className="bg-slate-50 dark:bg-slate-900 rounded-xl p-4 border space-y-3">
                            <h4 className="font-semibold text-sm text-slate-500 uppercase tracking-wider">Resumen de Ventas ({resumen.cantidadVentas} ventas)</h4>
                            <div className="grid grid-cols-2 gap-3">
                                <div className="flex items-center gap-2">
                                    <Landmark className="h-4 w-4 text-emerald-500" />
                                    <div>
                                        <p className="text-xs text-muted-foreground">Efectivo Ventas</p>
                                        <p className="font-bold">{formatearMoneda(resumen.totalEfectivo)}</p>
                                    </div>
                                </div>
                                <div className="flex items-center gap-2">
                                    <CreditCard className="h-4 w-4 text-blue-500" />
                                    <div>
                                        <p className="text-xs text-muted-foreground">Tarjetas</p>
                                        <p className="font-bold">{formatearMoneda(resumen.totalTarjeta)}</p>
                                    </div>
                                </div>
                                {resumen.totalTransferencia > 0 && (
                                    <div className="flex items-center gap-2">
                                        <ArrowDownUp className="h-4 w-4 text-purple-500" />
                                        <div>
                                            <p className="text-xs text-muted-foreground">Transferencia</p>
                                            <p className="font-bold">{formatearMoneda(resumen.totalTransferencia)}</p>
                                        </div>
                                    </div>
                                )}
                                {resumen.totalIngresosManualles > 0 && (
                                    <div className="flex items-center gap-2">
                                        <Banknote className="h-4 w-4 text-green-500" />
                                        <div>
                                            <p className="text-xs text-muted-foreground">Ingresos Manuales</p>
                                            <p className="font-bold text-green-600">+{formatearMoneda(resumen.totalIngresosManualles)}</p>
                                        </div>
                                    </div>
                                )}
                                {resumen.totalEgresosManualles > 0 && (
                                    <div className="flex items-center gap-2">
                                        <Banknote className="h-4 w-4 text-red-500" />
                                        <div>
                                            <p className="text-xs text-muted-foreground">Egresos Manuales</p>
                                            <p className="font-bold text-red-600">-{formatearMoneda(resumen.totalEgresosManualles)}</p>
                                        </div>
                                    </div>
                                )}
                            </div>
                            <div className="pt-2 border-t space-y-1">
                                <div className="flex justify-between text-sm">
                                    <span className="text-muted-foreground">Total Ventas</span>
                                    <span className="font-semibold">{formatearMoneda(resumen.totalVentas)}</span>
                                </div>
                                <div className="flex justify-between items-center text-base font-bold">
                                    <span>Efectivo Esperado en Caja</span>
                                    <span className="text-primary">{formatearMoneda(resumen.montoEsperadoEnCaja)}</span>
                                </div>
                            </div>
                        </div>

                        {/* Arqueo */}
                        <div className="space-y-2">
                            <Label htmlFor="montoFisico">Monto Físico Contado (S/)</Label>
                            <Input
                                id="montoFisico"
                                type="number"
                                step="0.01"
                                className="text-lg font-semibold"
                                value={montoFisico}
                                onChange={(e) => setMontoFisico(e.target.value)}
                            />
                            <div className={`flex justify-between items-center p-3 rounded-lg text-sm font-semibold ${
                                diferencia === 0
                                    ? 'bg-green-50 text-green-700'
                                    : diferencia > 0
                                        ? 'bg-blue-50 text-blue-700'
                                        : 'bg-red-50 text-red-700'
                            }`}>
                                <span>Diferencia de Arqueo</span>
                                <span>{diferencia >= 0 ? '+' : ''}{formatearMoneda(diferencia)}</span>
                            </div>
                        </div>

                        <div className="space-y-2">
                            <Label htmlFor="obs">Observaciones</Label>
                            <Textarea
                                id="obs"
                                placeholder="Ej: Faltante por vuelto incorrecto. Todo conforme."
                                className="bg-slate-50 dark:bg-slate-900 resize-none h-20"
                                value={observaciones}
                                onChange={(e) => setObservaciones(e.target.value)}
                            />
                        </div>

                        <div className="flex gap-2 p-3 bg-red-50 dark:bg-red-950/20 rounded-lg text-red-600 text-xs">
                            <AlertCircle className="h-4 w-4 shrink-0" />
                            <p>Una vez cerrada la caja no podrás registrar nuevas ventas hasta abrir un nuevo turno.</p>
                        </div>
                    </div>
                ) : null}

                <DialogFooter className="flex gap-2 sm:gap-0">
                    <Button variant="ghost" onClick={onClose} disabled={loading} className="flex-1">Cancelar</Button>
                    <Button
                        onClick={handleCerrar}
                        className="flex-1 bg-red-600 hover:bg-red-700"
                        disabled={loading || cargandoResumen}
                    >
                        {loading ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
                        {loading ? 'Cerrando...' : 'Confirmar Cierre'}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
};
```

#### 3. Crear `ModalMovimientoCaja.tsx`

```tsx
import { useState } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/componentes/ui/dialog';
import { Button } from '@/componentes/ui/button';
import { Input } from '@/componentes/ui/input';
import { Label } from '@/componentes/ui/label';
import { Textarea } from '@/componentes/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/componentes/ui/select';
import { servicioCajas } from '../../servicios/servicioCajas';
import { toast } from 'sonner';
import { TrendingUp, TrendingDown, Loader2 } from 'lucide-react';
import type { MovimientoCajaDetalle } from '../../tipos/ventas.types';

// IDs de tipo de movimiento según tablas_generales tabla 4
// INGRESO_MANUAL = el frontend envía monto positivo
// EGRESO_MANUAL = el frontend envía monto negativo
// El agente debe verificar los IDs reales en la BD antes de hardcodear.
// Por ahora se usa el tipo de movimiento directamente en el monto con signo.
const TIPO_MOVIMIENTO_INGRESO = 1; // Verificar en tablas_generales donde tabla_id = 4
const TIPO_MOVIMIENTO_EGRESO = 2;  // Verificar en tablas_generales donde tabla_id = 4

interface ModalMovimientoCajaProps {
    isOpen: boolean;
    onClose: () => void;
    cajaId: number;
    turnoId: number;
    onSuccess: (movimiento: MovimientoCajaDetalle) => void;
}

export const ModalMovimientoCaja = ({ isOpen, onClose, cajaId, turnoId, onSuccess }: ModalMovimientoCajaProps) => {
    const [tipo, setTipo] = useState<'INGRESO' | 'EGRESO'>('INGRESO');
    const [monto, setMonto] = useState<string>('');
    const [concepto, setConcepto] = useState<string>('');
    const [loading, setLoading] = useState(false);

    const handleRegistrar = async () => {
        const montoNum = parseFloat(monto);
        if (isNaN(montoNum) || montoNum <= 0) { toast.error('Ingresa un monto válido mayor a cero'); return; }
        if (!concepto.trim()) { toast.error('El concepto es obligatorio'); return; }

        setLoading(true);
        try {
            const montoFinal = tipo === 'EGRESO' ? -montoNum : montoNum;
            const result = await servicioCajas.registrarMovimiento(cajaId, {
                idTurnoVendedor: turnoId,
                idTipoMovimiento: tipo === 'INGRESO' ? TIPO_MOVIMIENTO_INGRESO : TIPO_MOVIMIENTO_EGRESO,
                monto: montoFinal,
                concepto: concepto.trim()
            });
            toast.success(`${tipo === 'INGRESO' ? 'Ingreso' : 'Egreso'} registrado correctamente`);
            setMonto('');
            setConcepto('');
            onSuccess(result);
            onClose();
        } catch (error: any) {
            toast.error(error.response?.data || 'Error al registrar movimiento');
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="sm:max-w-[420px] border-none shadow-2xl">
                <DialogHeader>
                    <DialogTitle className="text-xl font-bold">Movimiento de Caja</DialogTitle>
                </DialogHeader>

                <div className="space-y-4 py-2">
                    <div className="grid grid-cols-2 gap-2">
                        <Button
                            variant={tipo === 'INGRESO' ? 'default' : 'outline'}
                            className={tipo === 'INGRESO' ? 'bg-green-600 hover:bg-green-700' : ''}
                            onClick={() => setTipo('INGRESO')}
                        >
                            <TrendingUp className="h-4 w-4 mr-2" /> Ingreso
                        </Button>
                        <Button
                            variant={tipo === 'EGRESO' ? 'default' : 'outline'}
                            className={tipo === 'EGRESO' ? 'bg-red-600 hover:bg-red-700' : ''}
                            onClick={() => setTipo('EGRESO')}
                        >
                            <TrendingDown className="h-4 w-4 mr-2" /> Egreso
                        </Button>
                    </div>

                    <div className="space-y-2">
                        <Label>Monto (S/)</Label>
                        <Input
                            type="number"
                            step="0.01"
                            placeholder="0.00"
                            value={monto}
                            onChange={(e) => setMonto(e.target.value)}
                            className="text-lg font-semibold"
                        />
                    </div>

                    <div className="space-y-2">
                        <Label>Concepto</Label>
                        <Textarea
                            placeholder="Ej: Fondo de cambio adicional / Retiro para depósito"
                            value={concepto}
                            onChange={(e) => setConcepto(e.target.value)}
                            className="resize-none h-20"
                        />
                    </div>
                </div>

                <DialogFooter className="gap-2">
                    <Button variant="ghost" onClick={onClose} disabled={loading}>Cancelar</Button>
                    <Button onClick={handleRegistrar} disabled={loading || !monto || !concepto}>
                        {loading ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
                        Registrar {tipo}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
};
```

#### 4. Modificar `PaginaPOS.tsx`

Agregar el botón "Movimiento de Caja" y el botón "Cerrar Turno" en la barra superior cuando hay turno activo. Integrar el `ModalMovimientoCaja` y `ModalCierreTurno`.

Cambios específicos en `PaginaPOS.tsx`:
- Agregar imports: `ModalMovimientoCaja`, `ModalCierreTurno`, `ArrowLeftRight`, `XCircle`
- Agregar estados: `showModalMovimiento`, `showModalCierre`
- Agregar JSX con los botones en la barra cuando `turno` no es null
- Integrar los dos modales

```tsx
// Agregar al bloque de imports (AL TOPE, después de los imports existentes):
import { ModalCierreTurno } from "../componentes/pos/ModalCierreTurno";
import { ModalMovimientoCaja } from "../componentes/pos/ModalMovimientoCaja";
import { ArrowLeftRight, XCircle } from "lucide-react";
import { CierreTurnoDto } from "../servicios/turnoService";

// Agregar estados (dentro del componente PaginaPOS, después de los estados existentes):
const [showModalMovimiento, setShowModalMovimiento] = useState(false);
const [showModalCierre, setShowModalCierre] = useState(false);

// Agregar handler:
const handleCierreTurno = (cierre: CierreTurnoDto) => {
    setTurno(null);
    setShowModalCierre(false);
    setShowModalApertura(true);
};
```

En el JSX donde está el grid (`{turno && (...)}`) agregar ANTES del grid una barra de acciones:

```tsx
{turno && (
    <div className="flex gap-2 py-2 border-b">
        <div className="flex-1" />
        <Button
            variant="outline"
            size="sm"
            onClick={() => setShowModalMovimiento(true)}
            className="gap-2"
        >
            <ArrowLeftRight className="h-4 w-4" />
            Movimiento de Caja
        </Button>
        <Button
            variant="outline"
            size="sm"
            onClick={() => setShowModalCierre(true)}
            className="gap-2 text-red-600 border-red-200 hover:bg-red-50"
        >
            <XCircle className="h-4 w-4" />
            Cerrar Turno
        </Button>
    </div>
)}
```

Y al final del JSX de `PaginaPOS`, agregar los modales:

```tsx
{turno && (
    <>
        <ModalMovimientoCaja
            isOpen={showModalMovimiento}
            onClose={() => setShowModalMovimiento(false)}
            cajaId={turno.cajaId}
            turnoId={turno.id}
            onSuccess={() => {}} // Sin efecto en el POS — solo confirma
        />
        <ModalCierreTurno
            isOpen={showModalCierre}
            onClose={() => setShowModalCierre(false)}
            turnoId={turno.id}
            onSuccess={handleCierreTurno}
        />
    </>
)}
```

### Criterio de completitud
- [ ] `ModalAperturaTurno.tsx` carga cajas desde `servicioCajas.obtenerTodas()` — no hay cajas hardcodeadas
- [ ] `ModalCierreTurno.tsx` llama `obtenerResumenPrevioCierre()` y muestra datos reales
- [ ] `ModalCierreTurno.tsx` tiene campo de monto físico y muestra diferencia calculada en tiempo real
- [ ] `ModalMovimientoCaja.tsx` creado con selector INGRESO/EGRESO
- [ ] `PaginaPOS.tsx` tiene botones "Movimiento de Caja" y "Cerrar Turno"
- [ ] `npx tsc --noEmit` sin errores

### ⚠️ Trampas comunes

- **`turno.cajaId`** — verificar que `TurnoVendedorDto` tiene la propiedad `cajaId` (sí la tiene, definida en `turnoService.ts`).
- **No importar `Button` desde la ruta incorrecta** — usar `@/componentes/ui/button`.
- **El interceptor Axios ya maneja errores genéricos** — en los modales solo usar `toast.error` para errores específicos del negocio, no duplicar el toast genérico de error 500.
- **`ModalCierreTurno`** recibe `turnoId: number` — pasar `turno.id`, no `turno` entero.
- **Los estados de los modales deben estar en `PaginaPOS`**, no dentro de los propios modales.
- Importar `CierreTurnoDto` desde `'../servicios/turnoService'`, no desde `ventas.types.ts`.

---

## Tarea E — Frontend: Páginas Historial y Admin Cajas (Agente 5)

**Tiempo estimado:** 60 minutos
**Modo recomendado:** Planning
**Prerequisito:** Tarea C completada. (Puede ejecutarse en paralelo con Tarea D)

### Archivos a crear/modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `features/ventas/paginas/PaginaHistorialTurnos.tsx` | CREAR | Listado paginado de turnos con filtros |
| `features/ventas/paginas/PaginaCajas.tsx` | CREAR | Admin CRUD de cajas |
| `config/rutasTitulos.ts` | MODIFICAR | Agregar títulos para nuevas rutas |
| `config/menu.tsx` | MODIFICAR | Agregar items al menú Ventas |
| `configuracion/rutas.tsx` | MODIFICAR | Registrar rutas y permisos |

### Especificación detallada

#### 1. Crear `PaginaHistorialTurnos.tsx`

```tsx
import { useState } from 'react';
import { turnoService } from '../servicios/turnoService';
import { useQuery } from '@tanstack/react-query';
import { DataTable } from '@/componentes/shared/DataTable';
import { Badge } from '@/componentes/ui/badge';
import { formatearMoneda } from '@/compartido/utilidades/moneda';
import { formatearFecha } from '@/compartido/utilidades/fecha';
import type { TurnoHistorialItem } from '../tipos/ventas.types';

export function PaginaHistorialTurnos() {
    const [pageNumber, setPageNumber] = useState(1);
    const pageSize = 20;

    const { data, isLoading } = useQuery({
        queryKey: ['turnos-historial', pageNumber],
        queryFn: () => turnoService.obtenerHistorialTurnos({ pageNumber, pageSize })
    });

    const columnas = [
        { header: 'Caja', accessorKey: 'nombreCaja' as keyof TurnoHistorialItem },
        {
            header: 'Inicio',
            accessorKey: 'fechaInicio' as keyof TurnoHistorialItem,
            cell: (row: TurnoHistorialItem) => formatearFecha(row.fechaInicio)
        },
        {
            header: 'Fin',
            accessorKey: 'fechaFin' as keyof TurnoHistorialItem,
            cell: (row: TurnoHistorialItem) => row.fechaFin ? formatearFecha(row.fechaFin) : '—'
        },
        {
            header: 'Estado',
            accessorKey: 'estado' as keyof TurnoHistorialItem,
            cell: (row: TurnoHistorialItem) => (
                <Badge className={row.estado === 'ABIERTO'
                    ? 'bg-green-100 text-green-700 border-green-200'
                    : 'bg-gray-100 text-gray-700 border-gray-200'}>
                    {row.estado}
                </Badge>
            )
        },
        {
            header: 'Total Ventas',
            accessorKey: 'totalVentas' as keyof TurnoHistorialItem,
            cell: (row: TurnoHistorialItem) => formatearMoneda(row.totalVentas)
        },
        {
            header: 'Transacciones',
            accessorKey: 'cantidadTransacciones' as keyof TurnoHistorialItem
        },
        {
            header: 'Apertura',
            accessorKey: 'montoApertura' as keyof TurnoHistorialItem,
            cell: (row: TurnoHistorialItem) => formatearMoneda(row.montoApertura)
        },
        {
            header: 'Cierre',
            accessorKey: 'montoCierre' as keyof TurnoHistorialItem,
            cell: (row: TurnoHistorialItem) => row.montoCierre != null ? formatearMoneda(row.montoCierre) : '—'
        },
    ];

    const totalItems = data?.total ?? 0;
    const totalPages = Math.ceil(totalItems / pageSize);

    return (
        <div className="space-y-4 p-4">
            <div className="flex items-center justify-between">
                <h1 className="text-2xl font-bold">Historial de Turnos</h1>
            </div>

            <DataTable
                columns={columnas}
                data={data?.datos ?? []}
                isLoading={isLoading}
            />

            {totalPages > 1 && (
                <div className="flex justify-center gap-2 pt-4">
                    <button
                        onClick={() => setPageNumber(p => Math.max(1, p - 1))}
                        disabled={pageNumber === 1}
                        className="px-4 py-2 border rounded disabled:opacity-40"
                    >
                        Anterior
                    </button>
                    <span className="px-4 py-2 text-sm">Página {pageNumber} de {totalPages}</span>
                    <button
                        onClick={() => setPageNumber(p => Math.min(totalPages, p + 1))}
                        disabled={pageNumber === totalPages}
                        className="px-4 py-2 border rounded disabled:opacity-40"
                    >
                        Siguiente
                    </button>
                </div>
            )}
        </div>
    );
}
```

#### 2. Crear `PaginaCajas.tsx`

```tsx
import { useState } from 'react';
import { servicioCajas } from '../servicios/servicioCajas';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { Button } from '@/componentes/ui/button';
import { Badge } from '@/componentes/ui/badge';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/componentes/ui/dialog';
import { Input } from '@/componentes/ui/input';
import { Label } from '@/componentes/ui/label';
import { toast } from 'sonner';
import { Plus, Edit, PowerOff, Power } from 'lucide-react';
import type { CajaListItem } from '../tipos/ventas.types';

export function PaginaCajas() {
    const queryClient = useQueryClient();
    const [showForm, setShowForm] = useState(false);
    const [editando, setEditando] = useState<CajaListItem | null>(null);
    const [nombreCaja, setNombreCaja] = useState('');
    const [idAlmacen, setIdAlmacen] = useState('1');

    const { data: cajas = [], isLoading } = useQuery({
        queryKey: ['cajas-admin'],
        queryFn: () => servicioCajas.obtenerTodas()
    });

    const mutacionCrear = useMutation({
        mutationFn: () => servicioCajas.crear({ nombreCaja, idAlmacen: parseInt(idAlmacen) }),
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ['cajas-admin'] });
            toast.success('Caja creada correctamente');
            cerrarForm();
        },
        onError: () => toast.error('Error al crear la caja')
    });

    const mutacionActualizar = useMutation({
        mutationFn: () => servicioCajas.actualizar(editando!.id, { nombreCaja, idAlmacen: parseInt(idAlmacen) }),
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ['cajas-admin'] });
            toast.success('Caja actualizada');
            cerrarForm();
        },
        onError: () => toast.error('Error al actualizar la caja')
    });

    const mutacionEstado = useMutation({
        mutationFn: ({ id, activado }: { id: number; activado: boolean }) =>
            servicioCajas.cambiarEstado(id, activado),
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ['cajas-admin'] });
            toast.success('Estado actualizado');
        },
        onError: () => toast.error('Error al cambiar el estado')
    });

    const cerrarForm = () => {
        setShowForm(false);
        setEditando(null);
        setNombreCaja('');
        setIdAlmacen('1');
    };

    const abrirEditar = (caja: CajaListItem) => {
        setEditando(caja);
        setNombreCaja(caja.nombreCaja);
        setIdAlmacen(String(caja.idAlmacen));
        setShowForm(true);
    };

    const handleGuardar = () => {
        if (!nombreCaja.trim()) { toast.error('El nombre es obligatorio'); return; }
        if (editando) mutacionActualizar.mutate();
        else mutacionCrear.mutate();
    };

    return (
        <div className="space-y-4 p-4">
            <div className="flex items-center justify-between">
                <h1 className="text-2xl font-bold">Gestión de Cajas</h1>
                <Button onClick={() => setShowForm(true)} className="gap-2">
                    <Plus className="h-4 w-4" /> Nueva Caja
                </Button>
            </div>

            {isLoading ? (
                <p className="text-muted-foreground">Cargando cajas...</p>
            ) : (
                <div className="border rounded-lg overflow-hidden">
                    <table className="w-full text-sm">
                        <thead className="bg-slate-50 dark:bg-slate-900">
                            <tr>
                                <th className="text-left px-4 py-3 font-medium">Nombre</th>
                                <th className="text-left px-4 py-3 font-medium">Estado</th>
                                <th className="text-right px-4 py-3 font-medium">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            {cajas.map(caja => (
                                <tr key={caja.id} className="border-t hover:bg-slate-50/50">
                                    <td className="px-4 py-3 font-medium">{caja.nombreCaja}</td>
                                    <td className="px-4 py-3">
                                        <Badge className={caja.activado !== false
                                            ? 'bg-green-100 text-green-700 border-green-200'
                                            : 'bg-red-100 text-red-700 border-red-200'}>
                                            {caja.activado !== false ? 'Activa' : 'Inactiva'}
                                        </Badge>
                                    </td>
                                    <td className="px-4 py-3 text-right space-x-2">
                                        <Button variant="ghost" size="sm" onClick={() => abrirEditar(caja)}>
                                            <Edit className="h-4 w-4" />
                                        </Button>
                                        <Button
                                            variant="ghost"
                                            size="sm"
                                            onClick={() => mutacionEstado.mutate({ id: caja.id, activado: !(caja.activado !== false) })}
                                        >
                                            {caja.activado !== false
                                                ? <PowerOff className="h-4 w-4 text-red-500" />
                                                : <Power className="h-4 w-4 text-green-500" />}
                                        </Button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                    {cajas.length === 0 && (
                        <p className="text-center py-8 text-muted-foreground">No hay cajas registradas.</p>
                    )}
                </div>
            )}

            <Dialog open={showForm} onOpenChange={cerrarForm}>
                <DialogContent className="sm:max-w-[400px]">
                    <DialogHeader>
                        <DialogTitle>{editando ? 'Editar Caja' : 'Nueva Caja'}</DialogTitle>
                    </DialogHeader>
                    <div className="space-y-4 py-2">
                        <div className="space-y-2">
                            <Label>Nombre de la Caja</Label>
                            <Input value={nombreCaja} onChange={(e) => setNombreCaja(e.target.value)} placeholder="Ej: Caja Principal" />
                        </div>
                        <div className="space-y-2">
                            <Label>ID Almacén</Label>
                            <Input type="number" value={idAlmacen} onChange={(e) => setIdAlmacen(e.target.value)} />
                        </div>
                    </div>
                    <DialogFooter className="gap-2">
                        <Button variant="ghost" onClick={cerrarForm}>Cancelar</Button>
                        <Button onClick={handleGuardar} disabled={mutacionCrear.isPending || mutacionActualizar.isPending}>
                            {editando ? 'Actualizar' : 'Crear'}
                        </Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>
        </div>
    );
}
```

#### 3. Modificar `config/rutasTitulos.ts`

Agregar al final del objeto (antes del cierre `}`):

```typescript
  '/ventas/turnos':                 'Historial de Turnos',
  '/ventas/cajas':                  'Gestión de Cajas',
```

#### 4. Modificar `config/menu.tsx`

Dentro del array `subItems` de Ventas (después de `VEN_COTIZACIONES`), agregar:

```typescript
{ 
  titulo: RUTAS_TITULOS['/ventas/turnos'] || 'Historial de Turnos',
  icono: <History className="h-6 w-6" />,
  ruta: '/ventas/turnos',
  codigoPermiso: 'VEN_TURNOS'
},
{ 
  titulo: RUTAS_TITULOS['/ventas/cajas'] || 'Gestión de Cajas',
  icono: <Building2 className="h-6 w-6" />,
  ruta: '/ventas/cajas',
  codigoPermiso: 'VEN_CAJAS'
},
```

**VERIFICAR** que `History` y `Building2` ya estén importados en `menu.tsx`. Si no, agregarlos al import de `lucide-react` en la línea de imports correspondiente.

#### 5. Modificar `configuracion/rutas.tsx`

**Paso 1:** Agregar los lazy imports AL TOPE del archivo (después de los imports existentes de páginas de ventas):

```tsx
const PaginaHistorialTurnos = lazy(() =>
  import('@/features/ventas/paginas/PaginaHistorialTurnos').then((m) => ({
    default: m.PaginaHistorialTurnos,
  })),
);

const PaginaCajas = lazy(() =>
  import('@/features/ventas/paginas/PaginaCajas').then((m) => ({
    default: m.PaginaCajas,
  })),
);
```

**Paso 2:** Agregar las rutas dentro de `children` (después de la ruta `ventas/pos`):

```tsx
{
  path: 'ventas/turnos',
  element: (
    <RutaConPermiso codigoPermiso="VEN_TURNOS">
      <Suspense fallback={<CargandoPagina />}>
        <PaginaHistorialTurnos />
      </Suspense>
    </RutaConPermiso>
  ),
},
{
  path: 'ventas/cajas',
  element: (
    <RutaConPermiso codigoPermiso="VEN_CAJAS">
      <Suspense fallback={<CargandoPagina />}>
        <PaginaCajas />
      </Suspense>
    </RutaConPermiso>
  ),
},
```

### Criterio de completitud
- [ ] `PaginaHistorialTurnos.tsx` usa `turnoService.obtenerHistorialTurnos()` y muestra tabla con badges de estado
- [ ] `PaginaCajas.tsx` tiene CRUD completo (crear, editar, activar/desactivar)
- [ ] `rutasTitulos.ts` tiene los 2 nuevos títulos
- [ ] `menu.tsx` tiene los 2 nuevos items bajo "Ventas" con los permisos correctos
- [ ] `rutas.tsx` tiene los 2 lazy imports AL TOPE y las 2 rutas dentro de `children`
- [ ] `npx tsc --noEmit` sin errores en todo el frontend

### ⚠️ Trampas comunes

- **Los lazy imports van AL TOPE del archivo `rutas.tsx`** — no en el medio de las rutas. Error pasado en lecciones.
- **`History` y `Building2` pueden no estar importados en `menu.tsx`** — verificar el import existente y agregar solo lo que falta.
- **`codigoPermiso: 'VEN_TURNOS'` y `'VEN_CAJAS'`** — estos permisos deben existir en la BD. Si no existen, el menú no los mostrará. El agente debe indicar en su output que se necesita insertar en BD.
- **`data?.datos`** para `obtenerHistorialTurnos` — la respuesta paginada usa `.datos`, no `.data` ni array directo.
- **No duplicar el import de `lazy` o `Suspense`** en `rutas.tsx` — ya están importados al inicio del archivo.
- La `PaginaCajas.tsx` usa `useQuery` y `useMutation` de `@tanstack/react-query` — verificar que el import exista.

---

## Dependencias entre Tareas

```
Tarea A  ──────────────────────┐
(Migración código C#)          ▼
                         Tarea B  ─────────────────────┐
                         (Manejadores y Endpoints)      ▼
                                                  Tarea C  ────┬──────────────┐
                                                  (Servicios)   ▼              ▼
                                                          Tarea D        Tarea E
                                                          (POS Modales)  (Páginas nuevas)
```

- **A → B**: B implementa los manejadores que usan las entidades/DTOs modificados en A
- **B → C**: C llama los endpoints creados en B
- **C → D**: D usa `servicioCajas` y `turnoService` mejorado de C
- **C → E**: E usa los mismos servicios de C
- **D y E** pueden ejecutarse en paralelo una vez C esté completa

---

## SQL Necesario Post-Implementación

Ejecutar en la BD después de la migración EF Core para registrar los permisos:

```sql
-- Verificar IDs antes de insertar
SELECT id_permiso, codigo, nombre FROM identidad.permisos WHERE codigo LIKE 'VEN_%' ORDER BY codigo;

-- Insertar permisos nuevos (ajustar id_modulo según la BD)
INSERT INTO identidad.permisos (codigo, nombre, descripcion, id_modulo, activado, fecha_creacion, usuario_creacion)
VALUES 
('VEN_TURNOS', 'Historial de Turnos', 'Ver historial de turnos de caja', 
    (SELECT id_modulo FROM identidad.modulos WHERE codigo = 'VENTAS'), true, NOW(), 'SISTEMA'),
('VEN_CAJAS', 'Gestión de Cajas', 'CRUD de cajas registradoras', 
    (SELECT id_modulo FROM identidad.modulos WHERE codigo = 'VENTAS'), true, NOW(), 'SISTEMA')
ON CONFLICT (codigo) DO NOTHING;

-- Asignar a rol ADMIN (verificar id_rol)
INSERT INTO identidad.rol_permisos (id_rol, id_permiso, activado, fecha_creacion, usuario_creacion)
SELECT 
    (SELECT id_rol FROM identidad.roles WHERE codigo = 'ADMIN'),
    id_permiso,
    true, NOW(), 'SISTEMA'
FROM identidad.permisos WHERE codigo IN ('VEN_TURNOS', 'VEN_CAJAS')
ON CONFLICT DO NOTHING;
```

---

## Checklist de Revisión Final (Claude Code)

### Backend
- [ ] `dotnet build` limpio en toda la solución Ventas.API
- [ ] `CerrarTurnoManejador` no tiene IDs de MetodoPago hardcodeados (`p.IdMetodoPago == 1`)
- [ ] `ObtenerHistorialTurnosManejador` usa `COUNT(*) OVER()` y NO dos queries separadas
- [ ] `MovimientoCaja` tiene la columna `id_turno_vendedor` nullable
- [ ] `CierreTurno` tiene los 5 campos de arqueo
- [ ] Endpoints documentados en `/swagger`

### Frontend
- [ ] `npx tsc --noEmit` limpio en todo el frontend
- [ ] `ModalAperturaTurno` no tiene strings hardcodeados de cajas
- [ ] `ModalCierreTurno` muestra datos reales (no zeros)
- [ ] `ModalCierreTurno` calcula y muestra diferencia de arqueo en tiempo real
- [ ] Lazy imports de páginas nuevas AL TOPE de `rutas.tsx`
- [ ] `codigos de permiso` correctos: `VEN_TURNOS` y `VEN_CAJAS`
- [ ] `response.datos` (no `response.data`) en historial de turnos

---

## Comandos de Verificación

```bash
# Backend
cd Codigo/Backend/src/Ventas.API
dotnet build --no-restore 2>&1 | tail -20

# Frontend
cd Codigo/Frontend
npx tsc --noEmit 2>&1 | head -50

# Generar migración (el dev ejecuta esto manualmente después de Tarea A)
cd Codigo/Backend/src/Ventas.API/Ventas.API.API
dotnet ef migrations add Add_CierreTurnoArqueo_MovimientoTurno --project ../Ventas.API.Infrastructure --startup-project . --context VentasDbContext
dotnet ef database update --project ../Ventas.API.Infrastructure --startup-project . --context VentasDbContext
```
