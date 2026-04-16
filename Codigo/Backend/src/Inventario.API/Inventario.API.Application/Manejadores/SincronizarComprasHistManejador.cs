using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using Inventario.API.Application.Comandos;
using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Entidades.Integracion;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Nucleo.Comun.Domain.Enums;

namespace Inventario.API.Application.Manejadores
{
    public class SincronizarComprasHistManejador : IRequestHandler<SincronizarComprasHistComando, string>
    {
        private readonly IInventarioDbContext _context;
        private readonly IMediator _mediator;
        private readonly IValidacionReglaSunatService _validacionSunat;

        public SincronizarComprasHistManejador(IInventarioDbContext context, IMediator mediator, IValidacionReglaSunatService validacionSunat)
        {
            _context = context;
            _mediator = mediator;
            _validacionSunat = validacionSunat;
        }

        public async Task<string> Handle(SincronizarComprasHistComando request, CancellationToken cancellationToken)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != System.Data.ConnectionState.Open) 
            {
                 if (connection is System.Data.Common.DbConnection dbConn) await dbConn.OpenAsync(cancellationToken);
                 else connection.Open();
            }
            
            // Obtener el almacén principal de forma más robusta (Dapper dynamic)
            var almacenes = await connection.QueryAsync("SELECT id_almacen, nombre_almacen FROM inventario.almacenes ORDER BY es_principal DESC LIMIT 1");
            var primerAlmacen = almacenes.FirstOrDefault();

            if (primerAlmacen == null)
            {
                throw new Exception("ERROR CRÍTICO: No se encontraron almacenes en 'inventario.almacenes'.");
            }

            long almacenIdPrincipal = (long)primerAlmacen.id_almacen;
            string nombreAlmacenPrincipal = (string)primerAlmacen.nombre_almacen;
            
            Console.WriteLine($"[DEBUG] Almacén Principal detectado: {nombreAlmacenPrincipal} (ID: {almacenIdPrincipal})");

            // Obtener todos los IDs de almacén válidos para remapeo de seguridad
            var setAlmacenesValidos = (await connection.QueryAsync<long>("SELECT id_almacen FROM inventario.almacenes")).ToHashSet();

            int comprasProcesadas = 0;
            int ventasProcesadas = 0;
            int notasProcesadas = 0;
            int omitidos = 0;

            try
            {
                if (request.Reiniciar)
                {
                    Console.WriteLine("[DEBUG] Iniciando limpieza total para sincronización histórica...");
                    
                    var oldMovs = await _context.MovimientosInventario
                        .Where(m => m.Observaciones != null && 
                                   (m.Observaciones.Contains("Sincronización histórica") || 
                                    m.Observaciones.Contains("Sincronizacion historica") ||
                                    m.Observaciones.Contains("Ingreso automático") || 
                                    m.Observaciones.Contains("Salida automática") ||
                                    m.Observaciones.Contains("Reingreso por Nota")))
                        .ToListAsync(cancellationToken);

                    if (oldMovs.Any())
                    {
                        Console.WriteLine($"[DEBUG] Eliminando {oldMovs.Count} movimientos antiguos.");
                        _context.MovimientosInventario.RemoveRange(oldMovs);
                    }

                    var oldKardex = await _context.KardexMovimientos
                        .Where(k => k.DescripcionMovimiento != null && 
                                   (k.DescripcionMovimiento.Contains("Sincronización histórica") || 
                                    k.DescripcionMovimiento.Contains("Sincronizacion historica") ||
                                    k.DescripcionMovimiento.Contains("Ingreso automático") ||
                                    k.DescripcionMovimiento.Contains("Salida automática") ||
                                    k.DescripcionMovimiento.Contains("Reingreso por Nota")))
                        .ToListAsync(cancellationToken);

                    if (oldKardex.Any())
                    {
                        Console.WriteLine($"[DEBUG] Eliminando {oldKardex.Count} filas de Kardex antiguas.");
                        _context.KardexMovimientos.RemoveRange(oldKardex);
                    }

                    Console.WriteLine("[DEBUG] Reseteando tabla de stocks a cero...");
                    var stocks = await _context.Stocks.ToListAsync(cancellationToken);
                    foreach (var s in stocks)
                    {
                        s.CantidadActual = 0;
                        s.ValorTotal = 0;
                        s.CostoPromedio = 0;
                    }

                    await _context.SaveChangesAsync(cancellationToken);
                    Console.WriteLine("[DEBUG] Limpieza y reseteo de stocks completado.");
                }

                Console.WriteLine("[DEBUG] Cargando datos históricos de todas las fuentes...");
                
                var compras = await _context.SyncCompras.Include(c => c.Detalles).ToListAsync(cancellationToken);
                var ventas = await _context.SyncVentas.Include(v => v.Detalles).ToListAsync(cancellationToken);
                var ncCompras = await _context.SyncNotaCreditoCompras.Include(n => n.Detalles).ToListAsync(cancellationToken);
                var ndCompras = await _context.SyncNotaDebitoCompras.Include(n => n.Detalles).ToListAsync(cancellationToken);
                var ncVentas = await _context.SyncNotaCreditoVentas.Include(n => n.Detalles).ToListAsync(cancellationToken);
                var ndVentas = await _context.SyncNotaDebitoVentas.Include(n => n.Detalles).ToListAsync(cancellationToken);

                var eventos = new List<EventoSync>();

                foreach (var c in compras) eventos.Add(new EventoSync(c.FechaEmision, c, "COMPRA", _validacionSunat.ObtenerHoraComercial("COMPRAS", c.IdTipoComprobante.ToString())));
                foreach (var v in ventas) {
                    var hora = _validacionSunat.ObtenerHoraComercial("VENTAS", v.IdTipoComprobante.ToString());
                    // Aplicamos el número para los segundos (máx 59) para garantizar orden correlativo
                    if (v.Numero > 0)
                        hora = hora.Add(TimeSpan.FromSeconds(v.Numero % 60)); 
                        
                    eventos.Add(new EventoSync(v.FechaEmision, v, "VENTA", hora));
                }
                foreach (var n in ncCompras) eventos.Add(new EventoSync(n.FechaEmision, n, "NC_COMPRA", _validacionSunat.ObtenerHoraComercial("COMPRAS", "07")));
                foreach (var n in ndCompras) eventos.Add(new EventoSync(n.FechaEmision, n, "ND_COMPRA", _validacionSunat.ObtenerHoraComercial("COMPRAS", "08")));
                foreach (var n in ncVentas) eventos.Add(new EventoSync(n.FechaEmision, n, "NC_VENTA", _validacionSunat.ObtenerHoraComercial("VENTAS", "07")));
                foreach (var n in ndVentas) eventos.Add(new EventoSync(n.FechaEmision, n, "ND_VENTA", _validacionSunat.ObtenerHoraComercial("VENTAS", "08")));

                var eventosOrdenados = eventos
                    .OrderBy(e => e.FechaCompuesta)
                    .ThenBy(e => e.PrioridadTipo)
                    .ToList();

                foreach (var ev in eventosOrdenados)
                {
                    if (ev.Tipo == "COMPRA")
                    {
                        var c = (SyncCompra)ev.Entidad;
                        long almId = setAlmacenesValidos.Contains(c.IdAlmacen) ? c.IdAlmacen : almacenIdPrincipal;
                        
                        foreach (var det in c.Detalles)
                        {
                            if (await ProcesarDocumento(c.IdCompra, "COMPRAS", TipoMovimientoInventario.IngresoCompra, det.IdProducto, det.Cantidad, det.PrecioUnitarioCompra, almId, c.FechaEmision, c.SerieComprobante, c.NumeroComprobante, c.IdTipoComprobante, "Ingreso", cancellationToken))
                                comprasProcesadas++;
                            else omitidos++;
                        }
                    }
                    else if (ev.Tipo == "VENTA")
                    {
                        var v = (SyncVenta)ev.Entidad;
                        long almId = setAlmacenesValidos.Contains(v.IdAlmacen) ? v.IdAlmacen : almacenIdPrincipal;

                        foreach (var det in v.Detalles)
                        {
                            if (await ProcesarDocumento(v.IdVenta, "VENTAS", TipoMovimientoInventario.SalidaVenta, det.IdProducto, det.Cantidad, det.PrecioUnitario, almId, v.FechaEmision, v.Serie, v.Numero.ToString(), v.IdTipoComprobante, "Salida", cancellationToken))
                                ventasProcesadas++;
                            else omitidos++;
                        }
                    }
                    else if (ev.Tipo.StartsWith("NC_") || ev.Tipo.StartsWith("ND_"))
                    {
                        if (await ProcesarNota(ev, setAlmacenesValidos, almacenIdPrincipal, cancellationToken))
                            notasProcesadas++;
                        else omitidos++;
                    }
                }

                return $"Sincronización finalizada exitosamente.\nPROCESADOS: Compras={comprasProcesadas}, Ventas={ventasProcesadas}, Notas={notasProcesadas}.\nOMITIDOS: {omitidos}.";
            }
            catch (Exception ex)
            {
                return $"Error en sincronización: {ex.Message}";
            }
        }

        private async Task<bool> ProcesarDocumento(long idRef, string modulo, TipoMovimientoInventario tipo, long prodId, decimal cant, decimal? precio, long almId, DateTime fecha, string? serie, string? num, long? idTipoDoc, string prefijo, CancellationToken ct)
        {
            // La fecha ya viene normalizada por EventoSync o por el Inyeccion en CrearMovimientoInventarioManejador
            DateTime fechaFinal = fecha;

            bool existe = await _context.MovimientosInventario.AnyAsync(m => m.IdReferencia == idRef && m.ReferenciaModulo == modulo && m.IdTipoMovimiento == (long)tipo && m.IdStock != 0 && m.Stock.IdProducto == prodId, ct);
            if (existe) return false;

            var comando = new CrearMovimientoInventarioComando(
                IdTipoMovimiento: (long)tipo,
                IdProducto: prodId,
                IdAlmacen: almId,
                Cantidad: cant,
                CostoUnitario: precio,
                SerieDocumento: serie ?? "S/S",
                NumeroDocumento: num ?? "0",
                IdTipoDocumento: idTipoDoc,
                ReferenciaModulo: modulo,
                IdReferencia: idRef,
                Observaciones: $"Sincronización histórica {prefijo} #{idRef} de la fecha {fecha:dd/MM/yyyy}",
                FechaMovimiento: fechaFinal,
                PermitirStockNegativo: true
            );

            await _mediator.Send(comando, ct);
            return true;
        }

        private async Task<bool> ProcesarNota(EventoSync ev, HashSet<long> setValidos, long idPrincipal, CancellationToken ct)
        {
            if (ev.Tipo == "NC_COMPRA") {
                var n = (SyncNotaCreditoCompra)ev.Entidad;
                long almId = setValidos.Contains(n.IdAlmacen) ? n.IdAlmacen : idPrincipal;
                foreach(var det in n.Detalles) 
                    await ProcesarDocumento(n.Id, "COMPRAS", TipoMovimientoInventario.DevolucionCompra, det.IdProducto, det.Cantidad, det.PrecioUnitario, almId, n.FechaEmision, n.Serie, n.Numero.ToString().PadLeft(8, '0'), 5, "NC Compra", ct);
            }
            else if (ev.Tipo == "NC_VENTA") {
                var n = (SyncNotaCreditoVenta)ev.Entidad;
                long almId = setValidos.Contains(n.IdAlmacen) ? n.IdAlmacen : idPrincipal;
                foreach(var det in n.Detalles)
                    await ProcesarDocumento(n.Id, "VENTAS", TipoMovimientoInventario.DevolucionVenta, det.IdProducto, det.Cantidad, null, almId, n.FechaEmision, n.Serie, n.Numero.ToString().PadLeft(8, '0'), 5, "NC Venta", ct);
            }
            else if (ev.Tipo == "ND_COMPRA") {
                var n = (SyncNotaDebitoCompra)ev.Entidad;
                long almId = setValidos.Contains(n.IdAlmacen) ? n.IdAlmacen : idPrincipal;
                foreach(var det in n.Detalles) 
                    await ProcesarDocumento(n.Id, "COMPRAS", TipoMovimientoInventario.NotaDebitoCompra, det.IdProducto, det.Cantidad, det.PrecioUnitario, almId, n.FechaEmision, n.Serie, n.Numero.ToString().PadLeft(8, '0'), 6, "ND Compra", ct);
            }
            else if (ev.Tipo == "ND_VENTA") {
                var n = (SyncNotaDebitoVenta)ev.Entidad;
                long almId = setValidos.Contains(n.IdAlmacen) ? n.IdAlmacen : idPrincipal;
                foreach(var det in n.Detalles)
                    await ProcesarDocumento(n.Id, "VENTAS", TipoMovimientoInventario.NotaDebitoVenta, det.IdProducto, det.Cantidad, null, almId, n.FechaEmision, n.Serie, n.Numero.ToString().PadLeft(8, '0'), 6, "ND Venta", ct);
            }
            return true;
        }

        private class EventoSync
        {
            public DateTime FechaOriginal { get; }
            public object Entidad { get; }
            public string Tipo { get; }
            public DateTime FechaCompuesta { get; }
            public int PrioridadTipo { get; }

            public EventoSync(DateTime fecha, object entidad, string tipo, TimeSpan horaComercial)
            {
                FechaOriginal = fecha;
                Entidad = entidad;
                Tipo = tipo;
                // SIEMPRE forzamos la hora comercial/estándar para asegurar el ordenamiento por bloques
                // Ingresos (08:00) siempre antes que Salidas (10:00) en el mismo día.
                FechaCompuesta = fecha.Date.Add(horaComercial);

                PrioridadTipo = tipo switch {
                    "COMPRA" => 1,
                    "NC_COMPRA" => 2,
                    "ND_COMPRA" => 2,
                    "VENTA" => 3,
                    "NC_VENTA" => 4,
                    "ND_VENTA" => 4,
                    _ => 99
                };
            }
        }
    }
}
