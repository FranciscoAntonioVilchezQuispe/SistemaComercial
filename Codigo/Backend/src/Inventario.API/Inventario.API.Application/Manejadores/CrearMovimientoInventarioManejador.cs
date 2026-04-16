using Inventario.API.Application.Interfaces;
using Inventario.API.Application.Comandos;
using Inventario.API.Domain.Entidades;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using Inventario.API.Application.DTOs;
using Nucleo.Comun.Domain.Helpers;

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
            Console.WriteLine($"[DEBUG] [Inventario.API] Iniciando procesamiento de movimiento: Prod={request.IdProducto}, Alm={request.IdAlmacen}, Tipo={request.IdTipoMovimiento}, Cant={request.Cantidad}");
            try 
            {
                // 1. Validar Tipo Movimiento y obtener Código
            var tipoMovimiento = await _context.TiposMovimiento
                .FirstOrDefaultAsync(t => t.Id == request.IdTipoMovimiento, cancellationToken);

            if (tipoMovimiento == null)
                throw new Exception($"El tipo de movimiento con ID {request.IdTipoMovimiento} no existe.");

            // 2. Determinar Factor (Suma/Resta) Dinámicamente
            decimal factor = 0;
            string tipoComprobanteSunat = "00";
            
            if (request.IdTipoDocumento.HasValue)
            {
                var comprobante = await _context.SyncTiposComprobante
                    .AsNoTracking()
                    .FirstOrDefaultAsync(c => c.Id == request.IdTipoDocumento.Value, cancellationToken);
                
                if (comprobante != null)
                {
                    tipoComprobanteSunat = comprobante.Codigo;

                    if (!comprobante.MueveStock)
                    {
                        Console.WriteLine($"[DEBUG] [Inventario.API] Documento {comprobante.Codigo} configurado con mueve_stock = false. Factor Neutro.");
                        factor = 0;
                    }
                    else if (comprobante.TipoMovimientoStock == "ENTRADA") factor = 1;
                    else if (comprobante.TipoMovimientoStock == "SALIDA") factor = -1;
                    else if (comprobante.TipoMovimientoStock == "DEPENDIENTE")
                    {
                        // Lógica dependiente del módulo (Compras/Ventas)
                        string modulo = request.ReferenciaModulo?.ToUpper() ?? "";
                        if (modulo.Contains("COMPRAS"))
                        {
                            if (comprobante.MovimientoStockCompra == "ENTRADA") factor = 1;
                            else if (comprobante.MovimientoStockCompra == "SALIDA") factor = -1;
                        }
                        else if (modulo.Contains("VENTAS"))
                        {
                            if (comprobante.MovimientoStockVenta == "ENTRADA") factor = 1;
                            else if (comprobante.MovimientoStockVenta == "SALIDA") factor = -1;
                        }
                    }
                }
            }

            // Fallback a lógica antigua por código de movimiento si no se determinó por documento
            if (factor == 0 && request.IdTipoDocumento.HasValue == false)
            {
                switch (tipoMovimiento.Codigo)
                {
                    case "ING_COM":
                    case "AJU_POS":
                    case "INV_INI":
                    case "ING_TRA":
                        factor = 1;
                        break;
                    case "SAL_VEN":
                    case "AJU_NEG":
                    case "TRA_ALM":
                        factor = -1;
                        break;
                    default:
                        factor = 0; // Neutro por defecto si no coincide
                        break;
                }
            }

            if (factor == 0 && request.IdTipoDocumento.HasValue == false && tipoMovimiento.Codigo != "NEUTRO")
            {
                 throw new Exception($"No se pudo determinar el factor de movimiento para '{tipoMovimiento.Codigo}'.");
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
                    FechaCreacion = DateTimeHelper.ObtenerAhoraLima()
                };
                _context.Stocks.Add(stock);
            }

            decimal cantidadAnterior = stock.CantidadActual;
            decimal valorTotalAnterior = stock.ValorTotal;
            decimal costoPromedioAnterior = stock.CostoPromedio;

            decimal cantidadCambio = request.Cantidad * factor;
            decimal cantidadNueva = cantidadAnterior + cantidadCambio;

            if (cantidadNueva < 0 && !request.PermitirStockNegativo)
                throw new Exception($"Stock insuficiente. Stock actual: {cantidadAnterior}, Módulo: {request.ReferenciaModulo}, Factor: {factor}, Cantidad solicitada: {request.Cantidad * factor}");

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

            // --- NORMALIZACIÓN DE HORA COMERCIAL (SUNAT REORDENAMIENTO) ---
            TimeSpan horaComercial = _validacionSunat.ObtenerHoraComercial(request.ReferenciaModulo ?? "", tipoComprobanteSunat);
            DateTime fechaFinal = (request.FechaMovimiento ?? DateTimeHelper.ObtenerAhoraLima()).Date.Add(horaComercial);
            
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
                FechaCreacion = fechaFinal,  // Usar fecha normalizada

                // Nuevos campos para Sincronización Total (SUNAT)
                TipoDocumento = tipoComprobanteSunat,
                SerieDocumento = request.SerieDocumento ?? string.Empty,
                NumeroDocumento = (request.NumeroDocumento ?? "0").PadLeft(8, '0'),
                CodigoOperacionSunat = request.CodigoOperacionSunat ?? string.Empty
            };

            _context.MovimientosInventario.Add(movimiento);

            // 5. Integración con el Kardex Valorizado SUNAT

            string motivoSunat = "99";
            switch (tipoMovimiento.Codigo)
            {
                case "02": // COMPRA NACIONAL
                case "ING_COM": motivoSunat = "0101"; break; 
                
                case "01": // VENTA NACIONAL
                case "SAL_VEN": motivoSunat = "0101"; break;
                
                case "04": // TRANSFERENCIA ENTRE ALMACENES
                case "TRA_ALM":
                case "ING_TRA": motivoSunat = "0401"; break; 
                
                case "06": // NC COMPRA (DEVOLUCION A PROVEEDOR)
                case "05": // NC VENTA (DEVOLUCION DE CLIENTE)
                    motivoSunat = "0101"; break; // Usar el código general de venta/compra interna permitido

                case "INV_INI": motivoSunat = "0101"; break;
            }

            // 5. Validar Regla SUNAT (Bypass en sincronización histórica)
            if (!request.PermitirStockNegativo && request.IdTipoDocumento.HasValue)
            {
                var nivelRelacion = await _validacionSunat.ValidarReglaAsync(motivoSunat, request.IdTipoDocumento.Value, cancellationToken);
                if (nivelRelacion == 0)
                {
                    Console.WriteLine($"[ERROR] [Inventario.API] Regla SUNAT fallida: Operación [{motivoSunat}] no permitida con Documento [{tipoComprobanteSunat}].");
                    throw new Exception($"Regla SUNAT: Operación [{motivoSunat}] no permitida con Documento [{tipoComprobanteSunat}].");
                }
                Console.WriteLine($"[DEBUG] [Inventario.API] Regla SUNAT validada ok (Nivel {nivelRelacion}).");
            }
            else
            {
                Console.WriteLine("[DEBUG] Sincronización histórica o sin documento: Omitiendo validación SUNAT.");
            }

            var kardexDto = new RegistrarMovimientoKardexDto
            {
                ModuloOrigen = request.ReferenciaModulo ?? "SISTEMA",
                TipoDocumento = tipoComprobanteSunat,
                SerieDocumento = string.IsNullOrWhiteSpace(request.SerieDocumento) ? "-" : request.SerieDocumento,
                NumeroDocumento = (request.NumeroDocumento ?? "0").PadLeft(8, '0'),
                TipoOperacion = factor > 0 ? "E" : "S",
                MotivoTrasladoSunat = motivoSunat,
                DescripcionMovimiento = request.Observaciones ?? tipoMovimiento.Nombre,
                AlmacenId = request.IdAlmacen,
                ProductoId = request.IdProducto,
                UnidadMedidaCodigo = "NIU",
                ReferenciaId = request.IdReferencia,
                ReferenciaTipo = request.ReferenciaModulo,
                UsuarioRegistroId = 1,
                FechaMovimiento = fechaFinal.Date,
                HoraMovimiento = fechaFinal.TimeOfDay,
                Cantidad = request.Cantidad,
                CostoUnitarioIngreso = factor > 0 ? costoUnitarioMovimiento : null,
                CodigoOperacionSunat = request.CodigoOperacionSunat ?? (factor > 0 ? "02" : "01"), 
                ProductoPermiteStockNegativo = request.PermitirStockNegativo,
                ProductoMetodoValuacion = "PP"
            };

            if (factor > 0) await _kardexService.RegistrarEntradaAsync(kardexDto);
            else await _kardexService.RegistrarSalidaAsync(kardexDto);

            Console.WriteLine($"[DEBUG] [Inventario.API] Persistiendo cambios en BD...");
            try 
            {
                await _context.SaveChangesAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] [Inventario.API] Error persistiendo movimiento en BD: {ex.Message}");
                if (ex.InnerException != null)
                {
                    Console.WriteLine($"[ERROR] Inner Exception: {ex.InnerException.Message}");
                }
                throw;
            }
            Console.WriteLine($"[DEBUG] [Inventario.API] Movimiento registrado exitosamente. ID: {movimiento.Id}");

            return movimiento.Id;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] [Inventario.API] Error crítico en CrearMovimientoInventarioManejador:");
                Console.WriteLine($"Mensaje: {ex.Message}");
                if (ex.InnerException != null)
                    Console.WriteLine($"Inner Exception: {ex.InnerException.Message}");
                Console.WriteLine($"Stack: {ex.StackTrace}");
                throw;
            }
        }
    }
}
