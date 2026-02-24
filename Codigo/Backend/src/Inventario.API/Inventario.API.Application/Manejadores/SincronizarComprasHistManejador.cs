using MediatR;
using Microsoft.EntityFrameworkCore;
using Inventario.API.Application.Comandos;
using Inventario.API.Application.Interfaces;
using System.Linq;

namespace Inventario.API.Application.Manejadores
{
    public class SincronizarComprasHistManejador : IRequestHandler<SincronizarComprasHistComando, string>
    {
        private readonly IInventarioDbContext _context;
        private readonly IMediator _mediator;

        public SincronizarComprasHistManejador(IInventarioDbContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public async Task<string> Handle(SincronizarComprasHistComando request, CancellationToken cancellationToken)
        {
            int comprasProcesadas = 0;
            int comprasOmitidas = 0;
            int ventasProcesadas = 0;
            int ventasOmitidas = 0;

            try
            {
                if (request.Reiniciar)
                {
                    // Limpiar movimientos previos de sincronización histórica usando EF
                    var oldMovs = await _context.MovimientosInventario
                        .Where(m => m.Observaciones != null && m.Observaciones.Contains("Sincronización histórica"))
                        .ToListAsync(cancellationToken);

                    if (oldMovs.Any())
                    {
                        _context.MovimientosInventario.RemoveRange(oldMovs);
                    }

                    var oldKardex = await _context.KardexMovimientos
                        .Where(k => k.DescripcionMovimiento != null && k.DescripcionMovimiento.Contains("Sincronización histórica"))
                        .ToListAsync(cancellationToken);

                    if (oldKardex.Any())
                    {
                        _context.KardexMovimientos.RemoveRange(oldKardex);
                    }

                    await _context.SaveChangesAsync(cancellationToken);
                }

                // --- 1. SINCRONIZAR COMPRAS ---
                var compras = await _context.SyncCompras
                    .Include(c => c.Detalles)
                    .OrderBy(c => c.FechaEmision).ThenBy(c => c.IdCompra)
                    .ToListAsync(cancellationToken);

                foreach (var compra in compras)
                {
                    foreach (var detalle in compra.Detalles.Where(d => d.IdProducto > 0 && d.Cantidad > 0))
                    {
                        bool existe = await _context.MovimientosInventario
                            .AnyAsync(m => m.IdReferencia == compra.IdCompra
                                        && m.ReferenciaModulo == "COMPRAS"
                                        && m.IdTipoMovimiento == 19 // ING_COM
                                        && m.Stock.IdProducto == detalle.IdProducto, cancellationToken);

                        if (existe)
                        {
                            comprasOmitidas++;
                            continue;
                        }

                        var comandoInventario = new CrearMovimientoInventarioComando(
                            IdProducto: detalle.IdProducto,
                            IdAlmacen: compra.IdAlmacen,
                            IdTipoMovimiento: 19, // ING_COM
                            Cantidad: detalle.Cantidad,
                            CostoUnitario: detalle.PrecioUnitarioCompra,
                            ReferenciaModulo: "COMPRAS",
                            IdReferencia: compra.IdCompra,
                            Observaciones: $"Sincronización histórica Compra #{compra.IdCompra} de la fecha {compra.FechaEmision:dd/MM/yyyy}",
                            IdTipoDocumento: compra.IdTipoComprobante,
                            SerieDocumento: compra.SerieComprobante ?? "",
                            NumeroDocumento: compra.NumeroComprobante ?? "",
                            FechaMovimiento: compra.FechaEmision
                        );

                        await _mediator.Send(comandoInventario, cancellationToken);
                        comprasProcesadas++;
                    }
                }

                // --- 2. SINCRONIZAR VENTAS ---
                var ventas = await _context.SyncVentas
                    .Include(v => v.Detalles)
                    .OrderBy(v => v.FechaEmision).ThenBy(v => v.IdVenta)
                    .ToListAsync(cancellationToken);

                foreach (var venta in ventas)
                {
                    foreach (var detalle in venta.Detalles.Where(d => d.IdProducto > 0 && d.Cantidad > 0))
                    {
                        bool existe = await _context.MovimientosInventario
                            .AnyAsync(m => m.IdReferencia == venta.IdVenta
                                        && m.ReferenciaModulo == "VENTAS"
                                        && m.IdTipoMovimiento == 20 // SAL_VEN
                                        && m.Stock.IdProducto == detalle.IdProducto, cancellationToken);

                        if (existe)
                        {
                            ventasOmitidas++;
                            continue;
                        }

                        var comandoInventario = new CrearMovimientoInventarioComando(
                            IdProducto: detalle.IdProducto,
                            IdAlmacen: venta.IdAlmacen,
                            IdTipoMovimiento: 20, // SAL_VEN
                            Cantidad: detalle.Cantidad,
                            CostoUnitario: detalle.PrecioUnitario,
                            ReferenciaModulo: "VENTAS",
                            IdReferencia: venta.IdVenta,
                            Observaciones: $"Sincronización histórica Venta #{venta.IdVenta} de la fecha {venta.FechaEmision:dd/MM/yyyy}",
                            IdTipoDocumento: venta.IdTipoComprobante,
                            SerieDocumento: venta.Serie ?? "",
                            NumeroDocumento: venta.Numero.ToString(),
                            FechaMovimiento: venta.FechaEmision
                        );

                        await _mediator.Send(comandoInventario, cancellationToken);
                        ventasProcesadas++;
                    }
                }

                return $"Sincronización finalizada satisfactoriamente. \nCompras: {comprasProcesadas} líneas agregadas al Kardex ({comprasOmitidas} ya existían).\nVentas: {ventasProcesadas} líneas agregadas al Kardex ({ventasOmitidas} ya existían).";
            }
            catch (Exception ex)
            {
                return $"Ocurrió un error en la sincronización: {ex.Message}";
            }
        }
    }
}
