using Inventario.API.Application.Comandos.Kardex;
using Inventario.API.Domain.Entidades.Kardex;
using Inventario.API.Domain.Interfaces;
using MediatR;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Manejadores.Kardex
{
    public class AbrirPeriodoManejador : IRequestHandler<AbrirPeriodoComando, bool>
    {
        private readonly IKardexPeriodoControlRepositorio _periodoRepo;

        public AbrirPeriodoManejador(IKardexPeriodoControlRepositorio periodoRepo)
        {
            _periodoRepo = periodoRepo;
        }

        public async Task<bool> Handle(AbrirPeriodoComando request, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(request.Periodo) || request.Periodo.Length != 7)
            {
                throw new ArgumentException("El periodo debe tener el formato YYYY-MM");
            }

            var periodoActual = await _periodoRepo.ObtenerPorPeriodoAsync(request.Periodo);

            if (periodoActual == null)
            {
                // Si no existe, no hay nada que abrir. Podríamos crearlo como abierto.
                periodoActual = new KardexPeriodoControl
                {
                    Periodo = request.Periodo,
                    Estado = "A",
                    CreatedAt = DateTime.UtcNow
                };
                await _periodoRepo.AgregarAsync(periodoActual);
            }
            else
            {
                if (periodoActual.Estado == "A")
                {
                    throw new Exception($"El periodo {request.Periodo} ya se encuentra abierto.");
                }

                // TODO: Dejar un rastro en auditoría fuerte de quién re-abrió el mes
                periodoActual.Estado = "A";
                periodoActual.FechaCierre = null;
                periodoActual.UsuarioCierreId = null;
                periodoActual.UpdatedAt = DateTime.UtcNow;

                await _periodoRepo.ActualizarAsync(periodoActual);
            }

            return true;
        }
    }
}
