using Inventario.API.Application.Interfaces;
using Inventario.API.Application.Comandos;
using Inventario.API.Domain.Entidades;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;

namespace Inventario.API.Application.Manejadores
{
    public class CrearMovimientoInventarioManejador : IRequestHandler<CrearMovimientoInventarioComando, long>
    {
        private readonly IInventarioDbContext _context;

        public CrearMovimientoInventarioManejador(IInventarioDbContext context)
        {
            _context = context;
        }

        public async Task<long> Handle(CrearMovimientoInventarioComando request, CancellationToken cancellationToken)
        {
            // 1. Validar Tipo Movimiento y obtener Código
            // Usamos la tabla de referencia readonly
            var tipoMovimiento = await _context.TiposMovimiento
                .FirstOrDefaultAsync(t => t.Id == request.IdTipoMovimiento, cancellationToken);
            
            if (tipoMovimiento == null)
                throw new Exception($"El tipo de movimiento con ID {request.IdTipoMovimiento} no existe.");

            // 2. Determinar Factor (Suma/Resta)
            decimal factor = 0;
            switch (tipoMovimiento.Codigo)
            {
                case "ING_COM": // Ingreso Compra
                case "AJU_POS": // Ajuste Positivo
                case "INV_INI": // Inventario Inicial
                    factor = 1;
                    break;
                case "SAL_VEN": // Salida Venta
                case "AJU_NEG": // Ajuste Negativo
                    factor = -1;
                    break;
                case "TRA_ALM": // Transferencia
                    factor = -1; // Salida del origen
                    break;
                default:
                    // Por defecto asumimos 0 si no conocemos
                    throw new Exception($"Código de movimiento '{tipoMovimiento.Codigo}' no soportado o no configura stock.");
            }

            // 3. Obtener o Crear Stock
            var stock = await _context.Stocks
                .FirstOrDefaultAsync(s => s.IdProducto == request.IdProducto && s.IdAlmacen == request.IdAlmacen, cancellationToken);

            if (stock == null)
            {
                // Si es salida y no hay stock, error
                if (factor < 0)
                    throw new Exception("No existe registro de stock para este producto en el almacén. No se puede realizar salida.");

                stock = new Stock
                {
                    IdProducto = request.IdProducto,
                    IdAlmacen = request.IdAlmacen,
                    CantidadActual = 0,
                    CantidadReservada = 0,
                    UsuarioCreacion = "SISTEMA", 
                    FechaCreacion = DateTime.UtcNow
                };
                _context.Stocks.Add(stock);
            }

            decimal cantidadAnterior = stock.CantidadActual;
            decimal cantidadCambio = request.Cantidad * factor;
            decimal cantidadNueva = cantidadAnterior + cantidadCambio;

            if (cantidadNueva < 0)
            {
                 // Regla de negocio: no permitir negativo
                 throw new Exception($"Stock insuficiente. Stock actual: {cantidadAnterior}, Salida requerida: {request.Cantidad}");
            }

            stock.CantidadActual = cantidadNueva;
            stock.UsuarioActualizacion = "SISTEMA";
            stock.FechaActualizacion = DateTime.UtcNow;

            // 4. Crear Movimiento
            var movimiento = new MovimientoInventario
            {
                IdTipoMovimiento = request.IdTipoMovimiento,
                // Stock aún no tiene ID si es nuevo, pero EF Core lo vincula por navegación
                Stock = stock, 
                // IdStock se llenará automáticamente
                Cantidad = request.Cantidad,
                CantidadAnterior = cantidadAnterior,
                CantidadNueva = cantidadNueva,
                ReferenciaModulo = request.ReferenciaModulo,
                IdReferencia = request.IdReferencia,
                Observaciones = request.Observaciones,
                UsuarioCreacion = "SISTEMA",
                FechaCreacion = DateTime.UtcNow
            };

            _context.MovimientosInventario.Add(movimiento);

            await _context.SaveChangesAsync(cancellationToken);

            return movimiento.Id;
        }
    }
}
