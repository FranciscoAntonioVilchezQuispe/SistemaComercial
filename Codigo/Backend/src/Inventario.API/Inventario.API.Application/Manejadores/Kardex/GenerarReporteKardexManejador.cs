using Inventario.API.Application.Consultas.Kardex;
using Inventario.API.Application.DTOs.Kardex;
using Inventario.API.Application.Interfaces;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Manejadores.Kardex
{
    public class GenerarReporteKardexManejador : IRequestHandler<GenerarReporteKardexConsulta, KardexReporteDto>
    {
        private readonly IInventarioDbContext _context;

        public GenerarReporteKardexManejador(IInventarioDbContext context)
        {
            _context = context;
        }

        public async Task<KardexReporteDto> Handle(GenerarReporteKardexConsulta request, CancellationToken cancellationToken)
        {
            var reporte = new KardexReporteDto
            {
                Periodo = $"{request.FechaInicio:yyyyMM}-{request.FechaFin:yyyyMM}",
                RucEmpresa = request.RucEmpresa,
                RazonSocialEmpresa = request.RazonSocialEmpresa,
                Establecimiento = "0000",
                CodigoExistencia = request.IdProducto.ToString(),
                TipoExistencia = "01", // Por defecto mercadería, debería conectarse a Catálogo
                DescripcionExistencia = "Producto " + request.IdProducto,
                CodigoUnidadMedida = "NIU",
                MetodoValuacion = "9" // Promedio (PP)
            };

            // 1. Obtener Saldo Inicial (Último movimiento antes de FechaInicio)
            var ultimoMovimientoAnterior = await _context.KardexMovimientos
                .Where(m => m.AlmacenId == request.IdAlmacen &&
                            m.ProductoId == request.IdProducto &&
                            m.FechaMovimiento < request.FechaInicio.Date &&
                            !m.Anulado)
                .OrderByDescending(m => m.FechaHoraCompuesta)
                .ThenByDescending(m => m.CorrelativoKardex)
                .FirstOrDefaultAsync(cancellationToken);

            if (ultimoMovimientoAnterior != null && ultimoMovimientoAnterior.SaldoCantidad > 0)
            {
                reporte.Detalles.Add(new KardexReporteItemDto
                {
                    Fecha = request.FechaInicio.Date,
                    TipoDocumentoSunat = "00", // Saldo inicial
                    SerieDocumento = "-",
                    NumeroDocumento = "0",
                    TipoOperacionSunat = "16", // 16 = Saldo Inicial SUNAT
                    
                    EntradaCantidad = ultimoMovimientoAnterior.SaldoCantidad,
                    EntradaCostoUnitario = ultimoMovimientoAnterior.SaldoCostoUnitario,
                    EntradaCostoTotal = ultimoMovimientoAnterior.SaldoCostoTotal,
                    
                    SalidaCantidad = 0,
                    SalidaCostoUnitario = 0,
                    SalidaCostoTotal = 0,
                    
                    SaldoCantidad = ultimoMovimientoAnterior.SaldoCantidad,
                    SaldoCostoUnitario = ultimoMovimientoAnterior.SaldoCostoUnitario,
                    SaldoCostoTotal = ultimoMovimientoAnterior.SaldoCostoTotal
                });
            }

            // 2. Traer todos los movimientos en el rango
            var movimientos = await _context.KardexMovimientos
                .Where(m => m.AlmacenId == request.IdAlmacen &&
                            m.ProductoId == request.IdProducto &&
                            m.FechaMovimiento >= request.FechaInicio.Date &&
                            m.FechaMovimiento <= request.FechaFin.Date &&
                            !m.Anulado)
                .OrderBy(m => m.FechaHoraCompuesta)
                .ThenBy(m => m.CorrelativoKardex)
                .ToListAsync(cancellationToken);

            // 3. Mapear al DTO
            foreach (var mov in movimientos)
            {
                var itemDto = new KardexReporteItemDto
                {
                    Fecha = mov.FechaMovimiento,
                    TipoDocumentoSunat = mov.TipoDocumento ?? "00",
                    SerieDocumento = mov.SerieDocumento ?? "-",
                    NumeroDocumento = mov.NumeroDocumento ?? "-",
                    TipoOperacionSunat = mov.MotivoTrasladoSunat ?? "00",

                    EntradaCantidad = mov.EntradaCantidad ?? 0,
                    EntradaCostoUnitario = mov.EntradaCostoUnitario ?? 0,
                    EntradaCostoTotal = mov.EntradaCostoTotal ?? 0,

                    SalidaCantidad = mov.SalidaCantidad ?? 0,
                    SalidaCostoUnitario = mov.SalidaCostoUnitario ?? 0,
                    SalidaCostoTotal = mov.SalidaCostoTotal ?? 0,

                    SaldoCantidad = mov.SaldoCantidad,
                    SaldoCostoUnitario = mov.SaldoCostoUnitario,
                    SaldoCostoTotal = mov.SaldoCostoTotal
                };

                reporte.Detalles.Add(itemDto);
            }

            return reporte;
        }
    }
}
