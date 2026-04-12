using MediatR;
using Microsoft.EntityFrameworkCore;
using Ventas.API.Application.Comandos;
using Ventas.API.Application.Interfaces;
using Microsoft.Extensions.Logging;
using Nucleo.Comun.Domain.Enums;

namespace Ventas.API.Application.Manejadores
{
    public class AnularVentaManejador : IRequestHandler<AnularVentaComando, bool>
    {
        private readonly IVentasDbContext _context;
        private readonly IInventarioServicio _inventarioServicio;
        private readonly ILogger<AnularVentaManejador> _logger;

        public AnularVentaManejador(
            IVentasDbContext context, 
            IInventarioServicio inventarioServicio,
            ILogger<AnularVentaManejador> logger)
        {
            _context = context;
            _inventarioServicio = inventarioServicio;
            _logger = logger;
        }

        public async Task<bool> Handle(AnularVentaComando request, CancellationToken cancellationToken)
        {
            try 
            {
                var venta = await _context.Ventas
                    .Include(v => v.Detalles)
                    .FirstOrDefaultAsync(v => v.Id == request.IdVenta, cancellationToken);

                if (venta == null)
                    throw new Exception("La venta no existe.");

                if (venta.IdEstado == (long)EstadoVenta.Anulada)
                    return true;

                // 1. Validar Tipo de Comprobante (Solo Boletas '03' según SUNAT para anulación directa)
                var tipoComp = await _context.TiposComprobanteRef
                    .FirstOrDefaultAsync(t => t.Id == venta.IdTipoComprobante, cancellationToken);
                
                if (tipoComp == null)
                    throw new Exception("No se pudo determinar el tipo de comprobante para la validación.");

                if (tipoComp.Codigo == "01") // Factura
                    throw new Exception("Las Facturas NO se anulan directamente por normativa SUNAT. Debe emitir una Nota de Crédito.");

                // 2. Validar Fecha de Creación (Política v1.0: 24 horas absolutas para anulación directa)
                var limite24Horas = venta.FechaCreacion.AddHours(24);
                if (DateTime.UtcNow > limite24Horas)
                    throw new Exception("Han pasado más de 24 horas desde el registro. No se puede anular directamente. Debe realizar una Nota de Crédito.");

                // 3. Actualizar estados y campos v1.0
                venta.IdEstado = (long)EstadoDocumento.AnuladoDirecto;
                venta.IdEstadoPago = (long)EstadoPago.Anulado;
                venta.FechaAnulacion = DateTime.UtcNow;
                venta.MotivoAnulacion = request.Motivo;
                venta.TipoAnulacion = "directo";
                venta.UsuarioActualizacion = request.UsuarioId.ToString();
                venta.EstadoSunat = "ANULADO";
                venta.Observaciones += $"\n[ANULACIÓN DIRECTA SUNAT] {DateTime.UtcNow} por {request.UsuarioId}: {request.Motivo}";

                // 4. Solicitar reversión de stock en Inventario.API
                _logger.LogInformation("Solicitando reversión de stock para Anulación de Venta {VentaId}", venta.Id);
                var successStock = await _inventarioServicio.AnularMovimientosVentaAsync(venta.Id);

                if (!successStock)
                {
                    _logger.LogError("Fallo crítico: No se pudo revertir el stock para la Venta {VentaId}", venta.Id);
                    throw new Exception("Error al revertir el stock. No se pudo completar la anulación.");
                }

                _context.Ventas.Update(venta);
                await _context.SaveChangesAsync(cancellationToken);

                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al anular la venta {VentaId}", request.IdVenta);
                throw;
            }
        }
    }
}
