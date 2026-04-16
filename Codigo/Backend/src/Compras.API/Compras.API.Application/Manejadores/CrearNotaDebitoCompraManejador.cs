using MediatR;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Comandos;
using Compras.API.Application.DTOs;
using Compras.API.Application.Interfaces;
using Compras.API.Domain.Entidades;
using Microsoft.Extensions.Logging;
using Nucleo.Comun.Domain.Enums;
using Nucleo.Comun.Domain.Helpers;
using Nucleo.Comun.Domain.Constants;

namespace Compras.API.Application.Manejadores
{
    public class CrearNotaDebitoCompraManejador : IRequestHandler<CrearNotaDebitoCompraComando, NotaDebitoCompraDto>
    {
        private readonly IComprasDbContext _context;
        private readonly IInventarioServicio _inventarioServicio;
        private readonly ILogger<CrearNotaDebitoCompraManejador> _logger;

        public CrearNotaDebitoCompraManejador(
            IComprasDbContext context, 
            IInventarioServicio inventarioServicio,
            ILogger<CrearNotaDebitoCompraManejador> logger)
        {
            _context = context;
            _inventarioServicio = inventarioServicio;
            _logger = logger;
        }

        public async Task<NotaDebitoCompraDto> Handle(CrearNotaDebitoCompraComando request, CancellationToken cancellationToken)
        {
            var dto = request.Nota;

            // 1. Validar compra de referencia (incluyendo proveedor)
            var compra = await _context.Compras
                .Include(c => c.Detalles)
                .Include(c => c.Proveedor)
                .FirstOrDefaultAsync(c => c.Id == dto.IdCompraReferencia, cancellationToken);
            
            if (compra == null)
                throw new Exception("La compra de referencia no existe.");

            // 2. Porcentaje IGV
            decimal porcentajeIgv = FiscalConstants.PORCENTAJE_IGV;

            // 3. Obtener correlativo automático por serie
            var serieObj = await _context.SeriesComprobantesRef
                .FirstOrDefaultAsync(s => s.Serie == dto.Serie, cancellationToken);

            if (serieObj == null)
                throw new Exception($"La serie seleccionada ({dto.Serie}) no existe o no está configurada.");

            serieObj.CorrelativoActual += 1;
            string nuevoNumero = serieObj.CorrelativoActual.ToString().PadLeft(8, '0');

            // 4. Mapear a Entidad y Recalcular Totales
            decimal tSubtotal = 0;
            decimal tIgv = 0;
            decimal tTotal = 0;

            var detallesNota = new List<NotaDebitoDetalleCompra>();
            foreach (var detDto in dto.Detalles)
            {
                var compraDetOri = compra.Detalles.FirstOrDefault(d => d.Id == detDto.IdCompraDetalle);
                
                decimal cant = detDto.Cantidad > 0 ? detDto.Cantidad : (compraDetOri?.Cantidad ?? 0);
                decimal pu = compraDetOri?.PrecioUnitarioCompra ?? detDto.PrecioUnitario;
                
                decimal subtotalLinea = Math.Round(cant * pu / (1 + (porcentajeIgv / 100)), 2);
                decimal totalLinea = Math.Round(cant * pu, 2);
                decimal igvLinea = totalLinea - subtotalLinea;

                tSubtotal += subtotalLinea;
                tIgv += igvLinea;
                tTotal += totalLinea;

                detallesNota.Add(new NotaDebitoDetalleCompra
                {
                    IdCompraDetalle = detDto.IdCompraDetalle,
                    IdProducto = detDto.IdProducto,
                    Descripcion = detDto.Descripcion ?? compraDetOri?.Descripcion ?? "Desconocido",
                    UnidadMedida = detDto.UnidadMedida ?? "NIU",
                    Cantidad = cant,
                    PrecioUnitario = pu,
                    Subtotal = subtotalLinea,
                    Igv = igvLinea,
                    Total = totalLinea
                });
            }

            var tipocomp = await _context.TiposComprobanteRef.FirstOrDefaultAsync(x => x.Id == compra.IdTipoComprobante);

            var nota = new NotaDebitoCompra
            {
                Serie = dto.Serie,
                Numero = nuevoNumero,
                TipoComprobante = "08",
                IdCompraReferencia = dto.IdCompraReferencia,
                SerieReferencia = compra.SerieComprobante,
                NumeroReferencia = compra.NumeroComprobante,
                TipoDocReferencia = tipocomp?.Codigo ?? "01",
                IdTipoNota = dto.IdTipoNota,
                MotivoSustento = dto.MotivoSustento,
                
                IdProveedor = compra.IdProveedor,
                ProveedorTipoDoc = compra.Proveedor.IdTipoDocumento.ToString(),
                ProveedorNroDoc = compra.Proveedor.NumeroDocumento,
                ProveedorRazonSocial = compra.Proveedor.RazonSocial,
                
                Subtotal = tSubtotal,
                Igv = tIgv,
                Total = tTotal,
                Moneda = compra.Moneda,
                TipoCambio = compra.TipoCambio,
                
                AfectaStock = dto.AfectaStock,
                FechaEmision = DateTimeHelper.ObtenerAhoraLima(),
                Estado = "PENDIENTE",
                IdEstado = (long)EstadoDocumento.Registrado,
                
                Detalles = detallesNota
            };

            // 5. Persistir Nota
            _context.NotasDebito.Add(nota);
            
            // 5.1 Vincular con Compra
            compra.IdEstado = (long)EstadoDocumento.AnuladoNotaDebito;
            compra.IdNotaDebito = nota.Id;
            compra.TipoAnulacion = "nota_debito";
            compra.FechaAnulacion = DateTimeHelper.ObtenerAhoraLima();
            compra.MotivoAnulacion = nota.MotivoSustento;
            compra.Observaciones += $"\n[NOTA DÉBITO] {DateTimeHelper.ObtenerAhoraLima()}: Nota {nota.Serie}-{nota.Numero} generada.";
            _context.Compras.Update(compra);

            // 5.2 Liberar Orden de Compra si existe referencia
            var orden = await _context.OrdenesCompra.FirstOrDefaultAsync(o => o.CompraId == compra.Id, cancellationToken);
            if (orden != null)
            {
                orden.CompraId = null;
                orden.IdEstado = (long)EstadoOrdenCompra.Aprobada;
                orden.Observaciones += $"\n[LIBERACIÓN POR ND] {DateTimeHelper.ObtenerAhoraLima()}: Nota {nota.Serie}-{nota.Numero} generada.";
                _context.OrdenesCompra.Update(orden);
            }

            await _context.SaveChangesAsync(cancellationToken);

            // 6. Inventario (Nota de Débito Compra es ENTRADA de stock)
            if (nota.AfectaStock)
            {
                foreach (var det in nota.Detalles)
                {
                    long idAlmacen = compra.IdAlmacen;
                    long idTipoComprobante = serieObj?.IdTipoComprobante ?? 0;

                    var success = await _inventarioServicio.RegistrarEntradaNotaDebitoAsync(
                        det.IdProducto,
                        idAlmacen,
                        det.Cantidad,
                        det.PrecioUnitario,
                        nota.Id,
                        nota.Serie,
                        nota.Numero,
                        idTipoComprobante);

                    if (!success)
                    {
                        _logger.LogError("No se pudo registrar entrada en inventario para ND Compra {NotaId}, Producto {ProdId}", nota.Id, det.IdProducto);
                        throw new Exception($"Error al actualizar stock para el producto {det.Descripcion}.");
                    }
                }
            }

            dto.Id = nota.Id;
            dto.Numero = nota.Numero;
            dto.Total = tTotal;
            return dto;
        }
    }
}
