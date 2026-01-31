using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using Identidad.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Identidad.API.Infrastructure.Repositorios
{
    public class UsuarioRepositorio : IUsuarioRepositorio
    {
        private readonly IdentidadDbContext _context;

        public UsuarioRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<Usuario?> ObtenerPorIdAsync(long id)
        {
            return await _context.Usuarios
                .Include(u => u.UsuariosRoles)
                    .ThenInclude(ur => ur.Rol)
                .FirstOrDefaultAsync(u => u.Id == id);
        }

        public async Task<Usuario?> ObtenerPorUsernameAsync(string username)
        {
            return await _context.Usuarios
                .Include(u => u.UsuariosRoles)
                    .ThenInclude(ur => ur.Rol)
                .FirstOrDefaultAsync(u => u.Username == username);
        }

        public async Task<Usuario> AgregarAsync(Usuario usuario)
        {
            _context.Usuarios.Add(usuario);
            await _context.SaveChangesAsync();
            return usuario;
        }

        public async Task ActualizarAsync(Usuario usuario)
        {
            _context.Entry(usuario).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<Usuario>> ObtenerTodosAsync()
        {
            return await _context.Usuarios
                .Include(u => u.UsuariosRoles)
                    .ThenInclude(ur => ur.Rol)
                .ToListAsync();
        }
    }

    public class RolRepositorio : IRolRepositorio
    {
        private readonly IdentidadDbContext _context;

        public RolRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<Rol?> ObtenerPorIdAsync(long id)
        {
            return await _context.Roles.FindAsync(id);
        }

        public async Task<Rol> AgregarAsync(Rol rol)
        {
            _context.Roles.Add(rol);
            await _context.SaveChangesAsync();
            return rol;
        }

        public async Task ActualizarAsync(Rol rol)
        {
            _context.Entry(rol).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<Rol>> ObtenerTodosAsync()
        {
            return await _context.Roles.ToListAsync();
        }
    }

    public class PermisoRepositorio : IPermisoRepositorio
    {
        private readonly IdentidadDbContext _context;

        public PermisoRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<Permiso?> ObtenerPorIdAsync(long id)
        {
            return await _context.Permisos.FindAsync(id);
        }

        public async Task<IEnumerable<Permiso>> ObtenerTodosAsync()
        {
            return await _context.Permisos.ToListAsync();
        }
    }
}
