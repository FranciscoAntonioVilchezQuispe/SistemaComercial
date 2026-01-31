using Identidad.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Identidad.API.Domain.Interfaces
{
    public interface IMenuRepositorio
    {
        Task<Menu?> ObtenerPorIdAsync(long id);
        Task<Menu?> ObtenerPorCodigoAsync(string codigo);
        Task<Menu> AgregarAsync(Menu menu);
        Task ActualizarAsync(Menu menu);
        Task EliminarAsync(long id);
        Task<IEnumerable<Menu>> ObtenerTodosAsync();
        Task<IEnumerable<Menu>> ObtenerMenusJerarquicosAsync();
        Task<IEnumerable<Menu>> ObtenerMenusPorRolAsync(long idRol);
    }

    public interface ITipoPermisoRepositorio
    {
        Task<TipoPermiso?> ObtenerPorIdAsync(long id);
        Task<TipoPermiso?> ObtenerPorCodigoAsync(string codigo);
        Task<TipoPermiso> AgregarAsync(TipoPermiso tipoPermiso);
        Task ActualizarAsync(TipoPermiso tipoPermiso);
        Task<IEnumerable<TipoPermiso>> ObtenerTodosAsync();
    }

    public interface IRolMenuRepositorio
    {
        Task<RolMenu?> ObtenerPorIdAsync(long id);
        Task<RolMenu?> ObtenerPorRolYMenuAsync(long idRol, long idMenu);
        Task<RolMenu> AgregarAsync(RolMenu rolMenu);
        Task EliminarAsync(long id);
        Task<IEnumerable<RolMenu>> ObtenerPorRolAsync(long idRol);
        Task<IEnumerable<RolMenu>> ObtenerPorMenuAsync(long idMenu);
    }

    public interface IRolMenuPermisoRepositorio
    {
        Task<RolMenuPermiso?> ObtenerPorIdAsync(long id);
        Task<RolMenuPermiso> AgregarAsync(RolMenuPermiso rolMenuPermiso);
        Task EliminarAsync(long id);
        Task<IEnumerable<RolMenuPermiso>> ObtenerPorRolMenuAsync(long idRolMenu);
        Task<IEnumerable<RolMenuPermiso>> ObtenerPermisosPorRolYMenuAsync(long idRol, long idMenu);
        Task<bool> UsuarioTienePermisoAsync(long idUsuario, string codigoMenu, string codigoPermiso);
    }

    public interface IUsuarioRolRepositorio
    {
        Task<UsuarioRol?> ObtenerPorIdAsync(long id);
        Task<UsuarioRol?> ObtenerPorUsuarioYRolAsync(long idUsuario, long idRol);
        Task<UsuarioRol> AgregarAsync(UsuarioRol usuarioRol);
        Task EliminarAsync(long id);
        Task<IEnumerable<UsuarioRol>> ObtenerPorUsuarioAsync(long idUsuario);
        Task<IEnumerable<UsuarioRol>> ObtenerPorRolAsync(long idRol);
    }
}
