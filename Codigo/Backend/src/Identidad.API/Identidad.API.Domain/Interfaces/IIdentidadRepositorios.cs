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
        Task<IEnumerable<Usuario>> ObtenerTodosAsync();
    }

    public interface IRolRepositorio
    {
        Task<Rol?> ObtenerPorIdAsync(long id);
        Task<Rol> AgregarAsync(Rol rol);
        Task ActualizarAsync(Rol rol);
        Task<IEnumerable<Rol>> ObtenerTodosAsync();
    }

    public interface IPermisoRepositorio
    {
        Task<Permiso?> ObtenerPorIdAsync(long id);
        Task<IEnumerable<Permiso>> ObtenerTodosAsync();
    }
}
