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

        public async Task<Usuario?> ObtenerPorTrabajadorIdAsync(long idTrabajador)
        {
            return await _context.Usuarios
                .FirstOrDefaultAsync(u => u.IdTrabajador == idTrabajador);
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

        public async Task SincronizarPermisosAsync(long idRol, List<long> permisosIds)
        {
            var permisosActuales = await _context.RolesPermisos
                .Where(rp => rp.IdRol == idRol)
                .ToListAsync();

            // Eliminar los que ya no están
            var aEliminar = permisosActuales.Where(rp => !permisosIds.Contains(rp.IdPermiso)).ToList();
            if (aEliminar.Any()) _context.RolesPermisos.RemoveRange(aEliminar);

            // Agregar los nuevos
            var idsActuales = permisosActuales.Select(rp => rp.IdPermiso).ToList();
            var aAgregar = permisosIds
                .Where(id => !idsActuales.Contains(id))
                .Select(id => new RolPermiso
                {
                    IdRol = idRol,
                    IdPermiso = id,
                    FechaCreacion = DateTime.UtcNow
                });

            if (aAgregar.Any()) await _context.RolesPermisos.AddRangeAsync(aAgregar);

            await _context.SaveChangesAsync();
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
        
        public async Task<IEnumerable<string>> ObtenerCodigosPorRolIdsAsync(IEnumerable<long> rolIds)
        {
            return await _context.RolesPermisos
                .Where(rp => rolIds.Contains(rp.IdRol))
                .Select(rp => rp.Permiso.CodigoPermiso)
                .Distinct()
                .ToListAsync();
        }
    }

    public class RefreshTokenRepositorio : Identidad.API.Domain.Interfaces.IRefreshTokenRepositorio
    {
        private readonly IdentidadDbContext _context;

        public RefreshTokenRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<RefreshToken?> ObtenerPorTokenAsync(string token)
        {
            return await _context.RefreshTokens.FirstOrDefaultAsync(x => x.Token == token);
        }

        public async Task AgregarAsync(RefreshToken refreshToken)
        {
            _context.RefreshTokens.Add(refreshToken);
            await _context.SaveChangesAsync();
        }

        public async Task ActualizarAsync(RefreshToken refreshToken)
        {
            _context.Entry(refreshToken).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }
    }

    public class TrabajadorRepositorio : ITrabajadorRepositorio
    {
        private readonly IdentidadDbContext _context;

        public TrabajadorRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<Trabajador?> ObtenerPorIdAsync(long id)
        {
            return await _context.Trabajadores
                .Include(t => t.Cargo)
                .Include(t => t.Usuario)
                .FirstOrDefaultAsync(t => t.Id == id);
        }

        public async Task<Trabajador?> ObtenerPorUsuarioIdAsync(long usuarioId)
        {
            return await _context.Usuarios
                .Where(u => u.Id == usuarioId)
                .Include(u => u.Trabajador)
                    .ThenInclude(t => t.Cargo)
                .Select(u => u.Trabajador)
                .FirstOrDefaultAsync();
        }

        public async Task<Trabajador> AgregarAsync(Trabajador trabajador)
        {
            _context.Trabajadores.Add(trabajador);
            await _context.SaveChangesAsync();
            return trabajador;
        }

        public async Task ActualizarAsync(Trabajador trabajador)
        {
            _context.Entry(trabajador).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<Trabajador>> ObtenerTodosAsync()
        {
            return await _context.Trabajadores
                .Include(t => t.Cargo)
                .Include(t => t.Usuario)
                .ToListAsync();
        }
    }

    public class CargoRepositorio : ICargoRepositorio
    {
        private readonly IdentidadDbContext _context;

        public CargoRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<Cargo?> ObtenerPorIdAsync(long id)
        {
            return await _context.Cargos.FindAsync(id);
        }

        public async Task<IEnumerable<Cargo>> ObtenerTodosAsync()
        {
            return await _context.Cargos.ToListAsync();
        }
    }

    public class AreaRepositorio : IAreaRepositorio
    {
        private readonly IdentidadDbContext _context;

        public AreaRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<Area?> ObtenerPorIdAsync(long id)
        {
            return await _context.Areas.FindAsync(id);
        }

        public async Task<IEnumerable<Area>> ObtenerTodosAsync()
        {
            return await _context.Areas.ToListAsync();
        }
    }
}
