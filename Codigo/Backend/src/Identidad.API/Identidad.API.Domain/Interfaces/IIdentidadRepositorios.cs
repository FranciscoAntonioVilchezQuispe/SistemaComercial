using Identidad.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Identidad.API.Domain.Interfaces
{
    public interface IUsuarioRepositorio
    {
        Task<Usuario?> ObtenerPorIdAsync(long id);
        Task<Usuario?> ObtenerPorUsernameAsync(string username);
        Task<Usuario> AgregarAsync(Usuario usuario);
        Task ActualizarAsync(Usuario usuario);
        Task<Usuario?> ObtenerPorTrabajadorIdAsync(long idTrabajador);
        Task<IEnumerable<Usuario>> ObtenerTodosAsync();
    }

    public interface IRolRepositorio
    {
        Task<Rol?> ObtenerPorIdAsync(long id);
        Task<Rol> AgregarAsync(Rol rol);
        Task ActualizarAsync(Rol rol);
        Task<IEnumerable<Rol>> ObtenerTodosAsync();
        Task SincronizarPermisosAsync(long idRol, List<long> permisosIds);
    }

    public interface IPermisoRepositorio
    {
        Task<Permiso?> ObtenerPorIdAsync(long id);
        Task<IEnumerable<Permiso>> ObtenerTodosAsync();
        Task<IEnumerable<string>> ObtenerCodigosPorRolIdsAsync(IEnumerable<long> rolIds);
    }

    public interface ITrabajadorRepositorio
    {
        Task<Trabajador?> ObtenerPorIdAsync(long id);
        Task<Trabajador?> ObtenerPorUsuarioIdAsync(long usuarioId);
        Task<Trabajador> AgregarAsync(Trabajador trabajador);
        Task ActualizarAsync(Trabajador trabajador);
        Task<IEnumerable<Trabajador>> ObtenerTodosAsync();
    }

    public interface ICargoRepositorio
    {
        Task<Cargo?> ObtenerPorIdAsync(long id);
        Task<IEnumerable<Cargo>> ObtenerTodosAsync();
    }

    public interface IAreaRepositorio
    {
        Task<Area?> ObtenerPorIdAsync(long id);
        Task<IEnumerable<Area>> ObtenerTodosAsync();
    }
}
