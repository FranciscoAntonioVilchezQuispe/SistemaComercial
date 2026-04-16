using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using MediatR;
using Nucleo.Comun.Application.Wrappers;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Identidad.API.Application.Features.Roles.ActualizarAccesoRol
{
    public record ActualizarAccesoRolCommand : IRequest<IToReturn<bool>>
    {
        public long IdRol { get; set; }
        public List<AccesoMenuDto> Accesos { get; set; } = new();
    }

    public class ActualizarAccesoRolCommandHandler : IRequestHandler<ActualizarAccesoRolCommand, IToReturn<bool>>
    {
        private readonly IRolRepositorio _repoRol;
        private readonly IRolMenuRepositorio _repoRolMenu;
        private readonly IRolMenuPermisoRepositorio _repoRolMenuPermiso;
        private readonly IMenuRepositorio _repoMenu;
        private readonly ITipoPermisoRepositorio _repoTipoPermiso;

        public ActualizarAccesoRolCommandHandler(
            IRolRepositorio repoRol,
            IRolMenuRepositorio repoRolMenu,
            IRolMenuPermisoRepositorio repoRolMenuPermiso,
            IMenuRepositorio repoMenu,
            ITipoPermisoRepositorio repoTipoPermiso)
        {
            _repoRol = repoRol;
            _repoRolMenu = repoRolMenu;
            _repoRolMenuPermiso = repoRolMenuPermiso;
            _repoMenu = repoMenu;
            _repoTipoPermiso = repoTipoPermiso;
        }

        public async Task<IToReturn<bool>> Handle(ActualizarAccesoRolCommand request, CancellationToken cancellationToken)
        {
            var rol = await _repoRol.ObtenerPorIdAsync(request.IdRol);
            if (rol == null)
                return new ToReturnError<bool>("Rol no encontrado.", 404);

            // 1. Obtener accesos actuales del rol
            var accesosActuales = await _repoRolMenu.ObtenerPorRolAsync(request.IdRol);

            // 2. Eliminar accesos que ya no están en la petición
            var menusIdsPeticion = request.Accesos.Select(a => a.IdMenu).ToList();
            foreach (var accesoActual in accesosActuales)
            {
                if (!menusIdsPeticion.Contains(accesoActual.IdMenu))
                {
                    await _repoRolMenu.EliminarAsync(accesoActual.Id);
                }
            }

            // 3. Procesar cada acceso de la petición
            foreach (var accesoReq in request.Accesos)
            {
                var rolMenu = accesosActuales.FirstOrDefault(am => am.IdMenu == accesoReq.IdMenu);

                if (rolMenu == null)
                {
                    // Crear nuevo RolMenu
                    rolMenu = new RolMenu
                    {
                        IdRol = request.IdRol,
                        IdMenu = accesoReq.IdMenu,
                        FechaCreacion = System.DateTime.UtcNow,
                        UsuarioCreacion = "admin" // TODO: Obtener del contexto
                    };
                    rolMenu = await _repoRolMenu.AgregarAsync(rolMenu);
                }

                // Sincronizar permisos del RolMenu
                var permisosActuales = await _repoRolMenuPermiso.ObtenerPorRolMenuAsync(rolMenu.Id);
                
                // Eliminar permisos obsoletos
                foreach (var permActual in permisosActuales)
                {
                    if (!accesoReq.TiposPermisoIds.Contains(permActual.IdTipoPermiso))
                    {
                        await _repoRolMenuPermiso.EliminarAsync(permActual.Id);
                    }
                }

                // Agregar nuevos permisos
                var idsPermisosActuales = permisosActuales.Select(p => p.IdTipoPermiso).ToList();
                foreach (var idTipoPermiso in accesoReq.TiposPermisoIds)
                {
                    if (!idsPermisosActuales.Contains(idTipoPermiso))
                    {
                        await _repoRolMenuPermiso.AgregarAsync(new RolMenuPermiso
                        {
                            IdRolMenu = rolMenu.Id,
                            IdTipoPermiso = idTipoPermiso,
                            FechaCreacion = System.DateTime.UtcNow,
                            UsuarioCreacion = "admin"
                        });
                    }
                }
            }

            return new ToReturn<bool>(true);
        }
    }
}
