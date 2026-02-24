using Inventario.API.Application.Interfaces;
using Inventario.API.Application.Comandos;
using Inventario.API.Domain.Entidades;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using Inventario.API.Application.DTOs;

namespace Inventario.API.Application.Manejadores
{
    public class CrearMovimientoInventarioManejador : IRequestHandler<CrearMovimientoInventarioComando, long>
    {
        private readonly IInventarioDbContext _context;
        private readonly IKardexService _kardexService;
        private readonly IValidacionReglaSunatService _validacionSunat;

        public CrearMovimientoInventarioManejador(IInventarioDbContext context,
            IKardexService kardexService,
            IValidacionReglaSunatService validacionSunat)
        {
            _context = context;
            _kardexService = kardexService;
            _validacionSunat = validacionSunat;
        }

        public async Task<long> Handle(CrearMovimientoInventarioComando request, CancellationToken cancellationToken)
        {
            // 1. Validar Tipo Movimiento y obtener Código
            var tipoMovimiento = await _context.TiposMovimiento
                .FirstOrDefaultAsync(t => t.Id == request.IdTipoMovimiento, cancellationToken);

            if (tipoMovimiento == null)
                throw new Exception($"El tipo de movimiento con ID {request.IdTipoMovimiento} no existe.");

            // 2. Determinar Factor (Suma/Resta)
            decimal factor = 0;
            switch (tipoMovimiento.Codigo)
            {
                case "ING_COM":
                case "AJU_POS":
                case "INV_INI":
                case "ING_TRA": // Ingreso por Traslado
                    factor = 1;
                    break;
                case "SAL_VEN":
                case "AJU_NEG":
                case "TRA_ALM":
                    factor = -1;
                    break;
                default:
                    throw new Exception($"Código de movimiento '{tipoMovimiento.Codigo}' no soportado.");
            }

            // 3. Obtener o Crear Stock
            var stock = await _context.Stocks
                .FirstOrDefaultAsync(s => s.IdProducto == request.IdProducto && s.IdAlmacen == request.IdAlmacen, cancellationToken);

            if (stock == null)
            {
                if (factor < 0)
                    throw new Exception("No existe registro de stock para este producto en el almacén.");

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
                throw new Exception($"Stock insuficiente. Stock actual: {cantidadAnterior}");

            // --- LÓGICA DE VALORIZACIÓN (CPP) ---
            decimal costoUnitarioMovimiento = request.CostoUnitario ?? 0;
            decimal valorMovimiento = 0;
            decimal nuevoValorTotal = valorTotalAnterior;
            decimal nuevoCostoPromedio = costoPromedioAnterior;

            if (factor > 0)
            {
                costoUnitarioMovimiento = request.CostoUnitario ?? costoPromedioAnterior;
                valorMovimiento = request.Cantidad * costoUnitarioMovimiento;
                nuevoValorTotal = valorTotalAnterior + valorMovimiento;
                if (cantidadNueva > 0) nuevoCostoPromedio = nuevoValorTotal / cantidadNueva;
            }
            else
            {
                costoUnitarioMovimiento = costoPromedioAnterior;
                valorMovimiento = request.Cantidad * costoUnitarioMovimiento;
                nuevoValorTotal = valorTotalAnterior - valorMovimiento;
                nuevoCostoPromedio = costoPromedioAnterior;
                if (cantidadNueva == 0) nuevoValorTotal = 0;
            }

            stock.CantidadActual = cantidadNueva;
            stock.ValorTotal = nuevoValorTotal;
            stock.CostoPromedio = nuevoCostoPromedio;

            // 4. Crear Movimiento
            var movimiento = new MovimientoInventario
            {
                IdTipoMovimiento = request.IdTipoMovimiento,
                Stock = stock,
                Cantidad = request.Cantidad,
                CantidadAnterior = cantidadAnterior,
                CantidadNueva = cantidadNueva,
                CostoUnitarioMovimiento = costoUnitarioMovimiento,
                SaldoCantidad = cantidadNueva,
                SaldoValorizado = nuevoValorTotal,
                CostoPromedioActual = nuevoCostoPromedio,
                ReferenciaModulo = request.ReferenciaModulo,
                IdReferencia = request.IdReferencia,
                Observaciones = request.Observaciones,
                UsuarioCreacion = "SISTEMA",
                FechaCreacion = request.FechaMovimiento ?? DateTime.UtcNow
            };

            _context.MovimientosInventario.Add(movimiento);

            // 5. Integración con el Kardex Valorizado SUNAT
            string tipoComprobanteSunat = "00";
            if (request.IdTipoDocumento.HasValue)
            {
                // LOOKUP REAL del código SUNAT
                var comprobante = await _context.SyncTiposComprobante
                    .AsNoTracking()
                    .FirstOrDefaultAsync(c => c.Id == request.IdTipoDocumento.Value, cancellationToken);

                tipoComprobanteSunat = comprobante?.Codigo ?? "00";
            }

            string motivoSunat = "99";
            switch (tipoMovimiento.Codigo)
            {
                case "ING_COM": motivoSunat = "02"; break;
                case "SAL_VEN": motivoSunat = "01"; break;
                case "TRA_ALM":
                case "ING_TRA": motivoSunat = "11"; break;
                case "INV_INI": motivoSunat = "16"; break;
            }

            // Validar Reglas SUNAT (Cruce Doc x Op)
            if (request.IdTipoDocumento.HasValue)
            {
                var nivelRelacion = await _validacionSunat.ValidarReglaAsync(motivoSunat, request.IdTipoDocumento.Value, cancellationToken);
                if (nivelRelacion == 0)
                {
                    throw new Exception($"Regla SUNAT: Operación [{motivoSunat}] no permitida con Documento [{tipoComprobanteSunat}].");
                }
            }

            var kardexDto = new RegistrarMovimientoKardexDto
            {
                ModuloOrigen = request.ReferenciaModulo ?? "SISTEMA",
                TipoDocumento = tipoComprobanteSunat,
                SerieDocumento = string.IsNullOrWhiteSpace(request.SerieDocumento) ? "-" : request.SerieDocumento,
                NumeroDocumento = string.IsNullOrWhiteSpace(request.NumeroDocumento) ? "0" : request.NumeroDocumento,
                TipoOperacion = factor > 0 ? "E" : "S",
                MotivoTrasladoSunat = motivoSunat,
                DescripcionMovimiento = request.Observaciones ?? tipoMovimiento.Nombre,
                AlmacenId = request.IdAlmacen,
                ProductoId = request.IdProducto,
                UnidadMedidaCodigo = "NIU",
                ReferenciaId = request.IdReferencia,
                ReferenciaTipo = request.ReferenciaModulo,
                UsuarioRegistroId = 1,
                FechaMovimiento = request.FechaMovimiento?.Date ?? DateTime.UtcNow.Date,
                HoraMovimiento = request.FechaMovimiento?.TimeOfDay ?? DateTime.UtcNow.TimeOfDay,
                Cantidad = request.Cantidad,
                CostoUnitarioIngreso = factor > 0 ? costoUnitarioMovimiento : null,
                ProductoPermiteStockNegativo = false,
                ProductoMetodoValuacion = "PP"
            };

            if (factor > 0) await _kardexService.RegistrarEntradaAsync(kardexDto);
            else await _kardexService.RegistrarSalidaAsync(kardexDto);

            await _context.SaveChangesAsync(cancellationToken);

            return movimiento.Id;
        }
    }
}
