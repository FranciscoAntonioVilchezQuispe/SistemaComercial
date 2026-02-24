using Inventario.API.Application.Comandos.Kardex;
using Inventario.API.Application.Servicios;
using MediatR;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Manejadores.Kardex
{
    public class RecalcularKardexManejador : IRequestHandler<RecalcularKardexComando, bool>
    {
        private readonly IKardexRecalculoService _recalculoService;

        public RecalcularKardexManejador(IKardexRecalculoService recalculoService)
        {
            _recalculoService = recalculoService;
        }

        public async Task<bool> Handle(RecalcularKardexComando request, CancellationToken cancellationToken)
        {
            // El recálculo inicia desde las 00:00:00 de ese día indicado en DesdeFecha
            await _recalculoService.RecalcularDesdePuntoDeQuiebreAsync(
                request.AlmacenId, 
                request.ProductoId, 
                request.DesdeFecha.Date, 
                TimeSpan.Zero, 
                request.Motivo, 
                request.UsuarioId);

            return true;
        }
    }
}
