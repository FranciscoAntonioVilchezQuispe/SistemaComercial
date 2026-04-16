using Inventario.API.Application.Comandos.Kardex;
using Inventario.API.Domain.Entidades.Kardex;
using Inventario.API.Domain.Interfaces;
using MediatR;
using Nucleo.Comun.Domain.Helpers;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Manejadores.Kardex
{
    public class CerrarPeriodoManejador : IRequestHandler<CerrarPeriodoComando, bool>
    {
        private readonly IKardexPeriodoControlRepositorio _periodoRepo;

        public CerrarPeriodoManejador(IKardexPeriodoControlRepositorio periodoRepo)
        {
            _periodoRepo = periodoRepo;
        }

        public async Task<bool> Handle(CerrarPeriodoComando request, CancellationToken cancellationToken)
        {
            // Validar formato YYYY-MM
            if (string.IsNullOrWhiteSpace(request.Periodo) || request.Periodo.Length != 7)
            {
                throw new ArgumentException("El periodo debe tener el formato YYYY-MM");
            }

            var periodoActual = await _periodoRepo.ObtenerPorPeriodoAsync(request.Periodo);

            if (periodoActual == null)
            {
                // Si no existe, lo creamos directamente como cerrado
                periodoActual = new KardexPeriodoControl
                {
                    Periodo = request.Periodo,
                    Estado = "C",
                    FechaCierre = DateTimeHelper.ObtenerAhoraLima().Date,
                    UsuarioCierreId = request.UsuarioId,
                    CreatedAt = DateTimeHelper.ObtenerAhoraLima()
                };
                await _periodoRepo.AgregarAsync(periodoActual);
            }
            else
            {
                if (periodoActual.Estado == "C")
                {
                    throw new Exception($"El periodo {request.Periodo} ya se encuentra cerrado.");
                }

                periodoActual.Estado = "C";
                periodoActual.FechaCierre = DateTimeHelper.ObtenerAhoraLima().Date;
                periodoActual.UsuarioCierreId = request.UsuarioId;
                periodoActual.UpdatedAt = DateTimeHelper.ObtenerAhoraLima();

                await _periodoRepo.ActualizarAsync(periodoActual);
            }

            return true;
        }
    }
}
