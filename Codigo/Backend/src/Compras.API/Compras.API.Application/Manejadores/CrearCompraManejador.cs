using MediatR;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Comandos;
using Compras.API.Application.Interfaces;
using Compras.API.Domain.Entidades;
using Compras.API.Application.Eventos;
using Nucleo.Comun.Domain;

namespace Compras.API.Application.Manejadores
{
    public class CrearCompraManejador : IRequestHandler<CrearCompraComando, long>
    {
        private readonly IComprasDbContext _context;
        private readonly IMediator _mediator;

        public CrearCompraManejador(IComprasDbContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public async Task<long> Handle(CrearCompraComando request, CancellationToken cancellationToken)
        {
            var dto = request.Compra;
            Console.WriteLine($"[DEBUG] [Compras.API] -> Iniciando CrearCompra. Proveedor={dto.IdProveedor}, OC_Ref={dto.IdOrdenCompraRef}, Doc={dto.SerieComprobante}-{dto.NumeroComprobante}");
            
            // 1. Validaciones
            if (dto.IdOrdenCompraRef.HasValue && dto.IdOrdenCompraRef.Value > 0)
            {
                Console.WriteLine($"[DEBUG] [Compras.API] -> Verificando OC {dto.IdOrdenCompraRef.Value} antes de procesar.");
                // Unificamos a 100 (Facturada) y verificamos CompraId
                var ordenConfirm = await _context.OrdenesCompra.AnyAsync(o => o.Id == dto.IdOrdenCompraRef.Value && (o.IdEstado == 100 || o.CompraId.HasValue), cancellationToken);
                if (ordenConfirm)
                {
                    Console.WriteLine($"[WARN] [Compras.API] -> Intento de usar OC ya procesada o facturada: {dto.IdOrdenCompraRef.Value}");
                    throw new AppException("Compras.API", "La Orden de Compra ya ha sido procesada en otra compra.");
                }
            }

            // 2. Mapear a Entidad (utilizando campos existentes en Compra.cs)
            var compra = new Compra
            {
                IdProveedor = dto.IdProveedor,
                IdAlmacen = dto.IdAlmacen,
                IdOrdenCompraRef = dto.IdOrdenCompraRef,
                IdTipoComprobante = dto.IdTipoComprobante,
                SerieComprobante = dto.SerieComprobante,
                NumeroComprobante = dto.NumeroComprobante,
                FechaEmision = (dto.FechaEmision == default ? DateTime.UtcNow : dto.FechaEmision).ToUniversalTime(),
                FechaContable = (dto.FechaContable == default ? DateTime.UtcNow : dto.FechaContable).ToUniversalTime(),
                FechaVencimiento = dto.FechaVencimiento?.ToUniversalTime(),
                Moneda = dto.Moneda,
                TipoCambio = dto.TipoCambio,
                Subtotal = dto.Subtotal,
                BaseGravada = dto.BaseGravada,
                BaseExonerada = dto.BaseExonerada,
                BaseInafecta = dto.BaseInafecta,
                Impuesto = dto.Impuesto,
                Total = dto.Total,
                SaldoPendiente = dto.SaldoPendiente,
                IdEstadoPago = dto.IdEstadoPago,
                Observaciones = dto.Observaciones,
                Detalles = dto.Detalles.Select(d => new DetalleCompra
                {
                    IdProducto = d.IdProducto,
                    IdVariante = d.IdVariante,
                    Descripcion = d.Descripcion,
                    Cantidad = d.Cantidad,
                    PrecioUnitarioCompra = d.PrecioUnitarioCompra,
                    Subtotal = d.Subtotal,
                    AfectacionIgv = d.AfectacionIgv
                }).ToList()
            };

            // 3. Persistir
            try 
            {
                _context.Compras.Add(compra);
                await _context.SaveChangesAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                var codigosAfectacion = string.Join(", ", compra.Detalles.Select(d => $"'{d.AfectacionIgv}'"));
                Console.Error.WriteLine($"[ERROR] [Compras.API] [CrearCompraManejador.Handle] → Falló al persistir la compra {dto.SerieComprobante}-{dto.NumeroComprobante}");
                Console.Error.WriteLine($"Detalle: Proveedor={dto.IdProveedor}, Total={dto.Total}, CodigosAfectacion=[{codigosAfectacion}] | Mensaje: {ex.Message}");
                if (ex.InnerException != null)
                {
                    Console.Error.WriteLine($"Inner Exception: {ex.InnerException.Message}");
                }
                Console.Error.WriteLine($"Stack: {ex.StackTrace}");
                
                throw new AppException("Compras.API", $"Error persistente al guardar compra {dto.SerieComprobante}-{dto.NumeroComprobante}", 
                    new { dto.IdProveedor, dto.Total, dto.SerieComprobante, dto.NumeroComprobante, codigosAfectacion }, ex);
            }

            // 3.1 Actualizar Orden de Compra si existe referencia
            if (dto.IdOrdenCompraRef.HasValue && dto.IdOrdenCompraRef.Value > 0)
            {
                Console.WriteLine($"[DEBUG] [Compras.API] -> Buscando OC con ID={dto.IdOrdenCompraRef.Value} para vinculación final.");
                var orden = await _context.OrdenesCompra.FirstOrDefaultAsync(o => o.Id == dto.IdOrdenCompraRef.Value, cancellationToken);
                if (orden != null)
                {
                    Console.WriteLine($"[DEBUG] [Compras.API] -> OC encontrada: {orden.CodigoOrden}. Estado actual: {orden.IdEstado}, CompraId previo: {orden.CompraId}");
                    Console.WriteLine($"[DEBUG] [Compras.API] -> Vinculando Compra {compra.Id} a OC {orden.CodigoOrden}. Cambiando estado a 100.");
                    
                    orden.CompraId = compra.Id;
                    orden.IdEstado = 100; // Facturada (Añadido por script SQL)
                    
                    _context.OrdenesCompra.Update(orden);
                    var guardado = await _context.SaveChangesAsync(cancellationToken);
                    Console.WriteLine($"[DEBUG] [Compras.API] -> Resultado SaveChanges para OC: {guardado} registros afectados.");
                }
                else
                {
                    Console.WriteLine($"[ERROR] [Compras.API] -> No se encontró la OC con ID={dto.IdOrdenCompraRef.Value} a pesar de que el DTO la referencia.");
                }
            }
            else
            {
                Console.WriteLine($"[DEBUG] [Compras.API] -> No se procesó vinculación de OC. dto.IdOrdenCompraRef es {(dto.IdOrdenCompraRef == null ? "NULL" : dto.IdOrdenCompraRef.ToString())}");
            }

            // 4. Publicar evento para actualizar inventario
            var evento = new CompraCreadaEvento(
                compra.Id,
                compra.IdAlmacen,
                compra.IdTipoComprobante,
                compra.SerieComprobante ?? string.Empty,
                compra.NumeroComprobante ?? string.Empty,
                compra.Detalles.Select(d => new CompraItemDetalle(d.IdProducto, d.Cantidad, d.PrecioUnitarioCompra)).ToList()
            );

            await _mediator.Publish(evento, cancellationToken);

            return compra.Id;
        }
    }
}
