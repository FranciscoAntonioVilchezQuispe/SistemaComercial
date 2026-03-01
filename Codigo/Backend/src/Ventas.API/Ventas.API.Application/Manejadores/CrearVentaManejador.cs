using MediatR;
using Microsoft.EntityFrameworkCore;
using Ventas.API.Application.Comandos;
using Ventas.API.Application.Eventos;
using Ventas.API.Application.Interfaces;
using Ventas.API.Domain.Entidades;

namespace Ventas.API.Application.Manejadores
{
    public class CrearVentaManejador : IRequestHandler<CrearVentaComando, long>
    {
        private readonly IVentasDbContext _context;
        private readonly IMediator _mediator;

        public CrearVentaManejador(IVentasDbContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public async Task<long> Handle(CrearVentaComando request, CancellationToken cancellationToken)
        {
            var dto = request.Venta;

            // 1. Validar Catálogos e Integridad
            // ... (resto del código igual hasta el mapeo)

            // 2. Mapear a Entidad
            var venta = new Venta
            {
                IdEmpresa = dto.IdEmpresa > 0 ? dto.IdEmpresa : 1,
                IdAlmacen = dto.IdAlmacen,
                IdCaja = dto.IdCaja,
                IdCliente = dto.IdCliente,
                IdUsuarioVendedor = dto.IdUsuarioVendedor > 0 ? dto.IdUsuarioVendedor : 1,
                IdCotizacionOrigen = dto.IdCotizacionOrigen,
                IdTipoComprobante = dto.IdTipoComprobante,
                Serie = dto.Serie,
                Numero = dto.Numero,
                FechaEmision = dto.FechaEmision == default ? DateTime.UtcNow : dto.FechaEmision,
                FechaVencimientoPago = dto.FechaVencimientoPago,
                IdEstado = dto.IdEstado > 0 ? dto.IdEstado : 1, // 1 = Registrada
                Moneda = string.IsNullOrWhiteSpace(dto.Moneda) ? "PEN" : dto.Moneda,
                TipoCambio = dto.TipoCambio > 0 ? dto.TipoCambio : 1.0m,
                SubtotalGravado = dto.SubtotalGravado,
                SubtotalExonerado = dto.SubtotalExonerado,
                SubtotalInafecto = dto.SubtotalInafecto,
                TotalImpuesto = dto.TotalImpuesto,
                TotalDescuentoGlobal = dto.TotalDescuentoGlobal,
                TotalVenta = dto.TotalVenta,
                SaldoPendiente = dto.TotalVenta, // Inicialmente el saldo es el total
                IdEstadoPago = dto.IdEstadoPago > 0 ? dto.IdEstadoPago : 1, // 1 = Pendiente
                Observaciones = dto.Observaciones,
                Detalles = dto.Detalles.Select(d => new DetalleVenta
                {
                    IdProducto = d.IdProducto,
                    IdVariante = d.IdVariante,
                    DescripcionProducto = d.DescripcionProducto,
                    Cantidad = d.Cantidad,
                    PrecioUnitario = d.PrecioUnitario,
                    PrecioListaOriginal = d.PrecioListaOriginal,
                    PorcentajeImpuesto = d.PorcentajeImpuesto,
                    ImpuestoItem = d.ImpuestoItem,
                    TotalItem = d.TotalItem
                }).ToList()
            };

            // Manejar Cliente "Público General" si Id es 0
            if (venta.IdCliente <= 0)
            {
                var clienteDefault = await _context.Clientes
                    .FirstOrDefaultAsync(c => c.NumeroDocumento == "00000000", cancellationToken);
                
                if (clienteDefault != null)
                {
                    venta.IdCliente = clienteDefault.Id;
                }
                else
                {
                    // Si no existe, al menos intentar con el ID 1 o fallar con elegancia
                    venta.IdCliente = 1; 
                }
            }

            // 3. Persistir
            _context.Ventas.Add(venta);

            // 4. Actualizar Correlativo de Serie
            var serieObj = await _context.SeriesComprobantes
                .FirstOrDefaultAsync(s => s.Serie == venta.Serie && 
                                         s.IdTipoComprobante == venta.IdTipoComprobante &&
                                         s.IdAlmacen == venta.IdAlmacen, cancellationToken);
            
            if (serieObj != null)
            {
                serieObj.CorrelativoActual = venta.Numero;
            }

            await _context.SaveChangesAsync(cancellationToken);

            // 5. Publicar evento para actualizar inventario
            var evento = new VentaCreadaEvento(
                venta.Id,
                venta.IdAlmacen,
                venta.IdTipoComprobante,
                venta.Serie ?? string.Empty,
                venta.Numero.ToString(),
                venta.Detalles.Select(d => new VentaItemDetalle(d.IdProducto, d.Cantidad)).ToList()
            );

            await _mediator.Publish(evento, cancellationToken);

            return venta.Id;
        }
    }
}
