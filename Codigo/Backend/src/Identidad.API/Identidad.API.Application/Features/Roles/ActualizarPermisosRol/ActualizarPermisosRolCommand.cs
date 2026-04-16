using Identidad.API.Domain.Interfaces;
using MediatR;
using Nucleo.Comun.Application.Wrappers;

namespace Identidad.API.Application.Features.Roles.ActualizarPermisosRol
{
    public record ActualizarPermisosRolCommand : IRequest<IToReturn<bool>>
    {
        public long IdRol { get; set; }
        public List<long> PermisosIds { get; set; } = new();
    }

    public class ActualizarPermisosRolCommandHandler : IRequestHandler<ActualizarPermisosRolCommand, IToReturn<bool>>
    {
        private readonly IRolRepositorio _repoRol;

        public ActualizarPermisosRolCommandHandler(IRolRepositorio repoRol)
        {
            _repoRol = repoRol;
        }

        public async Task<IToReturn<bool>> Handle(ActualizarPermisosRolCommand request, CancellationToken cancellationToken)
        {
            var rol = await _repoRol.ObtenerPorIdAsync(request.IdRol);
            if (rol == null)
                return new ToReturnError<bool>("Rol no encontrado.", 404);

            await _repoRol.SincronizarPermisosAsync(request.IdRol, request.PermisosIds);
            
            return new ToReturn<bool>(true);
        }
    }
}
