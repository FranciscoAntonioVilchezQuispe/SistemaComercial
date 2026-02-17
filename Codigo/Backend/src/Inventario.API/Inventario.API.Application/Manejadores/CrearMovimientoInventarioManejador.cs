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
            decimal valorTotalAnterior = stock.ValorTotal;
            decimal costoPromedioAnterior = stock.CostoPromedio;

            decimal cantidadCambio = request.Cantidad * factor;
            decimal cantidadNueva = cantidadAnterior + cantidadCambio;

            if (cantidadNueva < 0)
            {
                throw new Exception($"Stock insuficiente. Stock actual: {cantidadAnterior}, Salida requerida: {request.Cantidad}");
            }

            // --- LÓGICA DE VALORIZACIÓN (CPP) ---
            decimal costoUnitarioMovimiento = request.CostoUnitario ?? 0;
            decimal valorMovimiento = 0;
            decimal nuevoValorTotal = valorTotalAnterior;
            decimal nuevoCostoPromedio = costoPromedioAnterior;

            if (factor > 0) // ENTRADA (Compra, Ajuste POS, Inv Inicial)
            {
                // Si no se provee costo en una entrada, usamos el anterior (o 0 si es nuevo)
                costoUnitarioMovimiento = request.CostoUnitario ?? costoPromedioAnterior;
                valorMovimiento = request.Cantidad * costoUnitarioMovimiento;
                nuevoValorTotal = valorTotalAnterior + valorMovimiento;

                // Nueva fórmula CPP: Valor Total / Cantidad Total
                if (cantidadNueva > 0)
                {
                    nuevoCostoPromedio = nuevoValorTotal / cantidadNueva;
                }
            }
            else // SALIDA (Venta, Ajuste NEG)
            {
                // En salidas, SIEMPRE usamos el costo promedio actual del stock
                costoUnitarioMovimiento = costoPromedioAnterior;
                valorMovimiento = request.Cantidad * costoUnitarioMovimiento;
                nuevoValorTotal = valorTotalAnterior - valorMovimiento;

                // El costo promedio NO cambia en las salidas (regla contable CPP)
                nuevoCostoPromedio = costoPromedioAnterior;

                // Ajuste de redondeo: si la cantidad queda en 0, el valor total debe ser 0
                if (cantidadNueva == 0)
                {
                    nuevoValorTotal = 0;
                }
            }

            // Actualizar el Stock con los nuevos valores
            stock.CantidadActual = cantidadNueva;
            stock.ValorTotal = nuevoValorTotal;
            stock.CostoPromedio = nuevoCostoPromedio;
            stock.UsuarioActualizacion = "SISTEMA";
            stock.FechaActualizacion = DateTime.UtcNow;

            // 4. Crear Movimiento con datos de valorización
            var movimiento = new MovimientoInventario
            {
                IdTipoMovimiento = request.IdTipoMovimiento,
                Stock = stock,
                Cantidad = request.Cantidad,
                CantidadAnterior = cantidadAnterior,
                CantidadNueva = cantidadNueva,

                // Campos de valorización para el Kardex
                CostoUnitarioMovimiento = costoUnitarioMovimiento,
                SaldoCantidad = cantidadNueva,
                SaldoValorizado = nuevoValorTotal,
                CostoPromedioActual = nuevoCostoPromedio,

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
