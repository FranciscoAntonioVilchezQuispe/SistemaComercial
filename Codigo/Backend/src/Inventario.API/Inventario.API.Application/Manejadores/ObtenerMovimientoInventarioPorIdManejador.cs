using Inventario.API.Application.Consultas;
using Inventario.API.Application.DTOs;
using Inventario.API.Application.Interfaces;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Manejadores
{
    public class ObtenerMovimientoInventarioPorIdManejador : IRequestHandler<ObtenerMovimientoInventarioPorIdConsulta, MovimientoInventarioDto?>
    {
        private readonly IInventarioDbContext _context;

        public ObtenerMovimientoInventarioPorIdManejador(IInventarioDbContext context)
        {
            _context = context;
        }

        public async Task<MovimientoInventarioDto?> Handle(ObtenerMovimientoInventarioPorIdConsulta request, CancellationToken cancellationToken)
        {
            var movimiento = await _context.MovimientosInventario
                .AsNoTracking()
                .FirstOrDefaultAsync(m => m.Id == request.Id, cancellationToken);

            if (movimiento == null) return null;

            return new MovimientoInventarioDto
            {
                Id = movimiento.Id,
                IdTipoMovimiento = movimiento.IdTipoMovimiento,
                IdStock = movimiento.IdStock,
                Cantidad = movimiento.Cantidad,
                CantidadAnterior = movimiento.CantidadAnterior,
                CantidadNueva = movimiento.CantidadNueva,
                CostoUnitarioMovimiento = movimiento.CostoUnitarioMovimiento,
                ReferenciaModulo = movimiento.ReferenciaModulo,
                IdReferencia = movimiento.IdReferencia,
                Observaciones = movimiento.Observaciones,
                FechaCreacion = movimiento.FechaCreacion,
                UsuarioCreacion = movimiento.UsuarioCreacion
            };
        }
    }
}
