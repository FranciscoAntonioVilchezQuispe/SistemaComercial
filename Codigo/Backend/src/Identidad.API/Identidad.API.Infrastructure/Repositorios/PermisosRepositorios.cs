using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using Identidad.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Identidad.API.Infrastructure.Repositorios
{
    public class MenuRepositorio : IMenuRepositorio
    {
        private readonly IdentidadDbContext _context;

        public MenuRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<Menu?> ObtenerPorIdAsync(long id)
        {
            return await _context.Menus
                .Include(m => m.SubMenus)
                .FirstOrDefaultAsync(m => m.Id == id);
        }

        public async Task<Menu?> ObtenerPorCodigoAsync(string codigo)
        {
            return await _context.Menus
                .FirstOrDefaultAsync(m => m.Codigo == codigo);
        }

        public async Task<Menu> AgregarAsync(Menu menu)
        {
            _context.Menus.Add(menu);
            await _context.SaveChangesAsync();
            return menu;
        }

        public async Task ActualizarAsync(Menu menu)
        {
            _context.Entry(menu).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var menu = await _context.Menus.FindAsync(id);
            if (menu != null)
            {
                _context.Menus.Remove(menu);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<Menu>> ObtenerTodosAsync()
        {
            return await _context.Menus
                .OrderBy(m => m.Orden)
                .ToListAsync();
        }

        public async Task<IEnumerable<Menu>> ObtenerMenusJerarquicosAsync()
        {
            return await _context.Menus
                .Where(m => m.IdMenuPadre == null)
                .Include(m => m.SubMenus)
                .OrderBy(m => m.Orden)
                .ToListAsync();
        }

        public async Task<IEnumerable<Menu>> ObtenerMenusPorRolAsync(long idRol)
        {
            return await _context.RolesMenus
                .Where(rm => rm.IdRol == idRol)
                .Select(rm => rm.Menu)
                .OrderBy(m => m.Orden)
                .ToListAsync();
        }
    }

    public class TipoPermisoRepositorio : ITipoPermisoRepositorio
    {
        private readonly IdentidadDbContext _context;

        public TipoPermisoRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<TipoPermiso?> ObtenerPorIdAsync(long id)
        {
            return await _context.TiposPermiso.FindAsync(id);
        }

        public async Task<TipoPermiso?> ObtenerPorCodigoAsync(string codigo)
        {
            return await _context.TiposPermiso
                .FirstOrDefaultAsync(tp => tp.Codigo == codigo);
        }

        public async Task<TipoPermiso> AgregarAsync(TipoPermiso tipoPermiso)
        {
            _context.TiposPermiso.Add(tipoPermiso);
            await _context.SaveChangesAsync();
            return tipoPermiso;
        }

        public async Task ActualizarAsync(TipoPermiso tipoPermiso)
        {
            _context.Entry(tipoPermiso).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<TipoPermiso>> ObtenerTodosAsync()
        {
            return await _context.TiposPermiso.ToListAsync();
        }
    }

    public class RolMenuRepositorio : IRolMenuRepositorio
    {
        private readonly IdentidadDbContext _context;

        public RolMenuRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<RolMenu?> ObtenerPorIdAsync(long id)
        {
            return await _context.RolesMenus
                .Include(rm => rm.Rol)
                .Include(rm => rm.Menu)
                .Include(rm => rm.Permisos)
                .FirstOrDefaultAsync(rm => rm.Id == id);
        }

        public async Task<RolMenu?> ObtenerPorRolYMenuAsync(long idRol, long idMenu)
        {
            return await _context.RolesMenus
                .Include(rm => rm.Permisos)
                .FirstOrDefaultAsync(rm => rm.IdRol == idRol && rm.IdMenu == idMenu);
        }

        public async Task<RolMenu> AgregarAsync(RolMenu rolMenu)
        {
            _context.RolesMenus.Add(rolMenu);
            await _context.SaveChangesAsync();
            return rolMenu;
        }

        public async Task EliminarAsync(long id)
        {
            var rolMenu = await _context.RolesMenus.FindAsync(id);
            if (rolMenu != null)
            {
                _context.RolesMenus.Remove(rolMenu);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<RolMenu>> ObtenerPorRolAsync(long idRol)
        {
            return await _context.RolesMenus
                .Include(rm => rm.Menu)
                .Include(rm => rm.Permisos)
                .Where(rm => rm.IdRol == idRol)
                .ToListAsync();
        }

        public async Task<IEnumerable<RolMenu>> ObtenerPorMenuAsync(long idMenu)
        {
            return await _context.RolesMenus
                .Include(rm => rm.Rol)
                .Where(rm => rm.IdMenu == idMenu)
                .ToListAsync();
        }
    }

    public class RolMenuPermisoRepositorio : IRolMenuPermisoRepositorio
    {
        private readonly IdentidadDbContext _context;

        public RolMenuPermisoRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<RolMenuPermiso?> ObtenerPorIdAsync(long id)
        {
            return await _context.RolesMenusPermisos
                .Include(rmp => rmp.RolMenu)
                .Include(rmp => rmp.TipoPermiso)
                .FirstOrDefaultAsync(rmp => rmp.Id == id);
        }

        public async Task<RolMenuPermiso> AgregarAsync(RolMenuPermiso rolMenuPermiso)
        {
            _context.RolesMenusPermisos.Add(rolMenuPermiso);
            await _context.SaveChangesAsync();
            return rolMenuPermiso;
        }

        public async Task EliminarAsync(long id)
        {
            var rolMenuPermiso = await _context.RolesMenusPermisos.FindAsync(id);
            if (rolMenuPermiso != null)
            {
                _context.RolesMenusPermisos.Remove(rolMenuPermiso);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<RolMenuPermiso>> ObtenerPorRolMenuAsync(long idRolMenu)
        {
            return await _context.RolesMenusPermisos
                .Include(rmp => rmp.TipoPermiso)
                .Where(rmp => rmp.IdRolMenu == idRolMenu)
                .ToListAsync();
        }

        public async Task<IEnumerable<RolMenuPermiso>> ObtenerPermisosPorRolYMenuAsync(long idRol, long idMenu)
        {
            return await _context.RolesMenusPermisos
                .Include(rmp => rmp.TipoPermiso)
                .Where(rmp => rmp.RolMenu.IdRol == idRol && rmp.RolMenu.IdMenu == idMenu)
                .ToListAsync();
        }

        public async Task<bool> UsuarioTienePermisoAsync(long idUsuario, string codigoMenu, string codigoPermiso)
        {
            return await _context.UsuariosRoles
                .Where(ur => ur.IdUsuario == idUsuario)
                .Join(_context.RolesMenus,
                    ur => ur.IdRol,
                    rm => rm.IdRol,
                    (ur, rm) => rm)
                .Join(_context.Menus,
                    rm => rm.IdMenu,
                    m => m.Id,
                    (rm, m) => new { RolMenu = rm, Menu = m })
                .Where(x => x.Menu.Codigo == codigoMenu)
                .Join(_context.RolesMenusPermisos,
                    x => x.RolMenu.Id,
                    rmp => rmp.IdRolMenu,
                    (x, rmp) => rmp)
                .Join(_context.TiposPermiso,
                    rmp => rmp.IdTipoPermiso,
                    tp => tp.Id,
                    (rmp, tp) => tp)
                .AnyAsync(tp => tp.Codigo == codigoPermiso);
        }
    }

    public class UsuarioRolRepositorio : IUsuarioRolRepositorio
    {
        private readonly IdentidadDbContext _context;

        public UsuarioRolRepositorio(IdentidadDbContext context)
        {
            _context = context;
        }

        public async Task<UsuarioRol?> ObtenerPorIdAsync(long id)
        {
            return await _context.UsuariosRoles
                .Include(ur => ur.Usuario)
                .Include(ur => ur.Rol)
                .FirstOrDefaultAsync(ur => ur.Id == id);
        }

        public async Task<UsuarioRol?> ObtenerPorUsuarioYRolAsync(long idUsuario, long idRol)
        {
            return await _context.UsuariosRoles
                .FirstOrDefaultAsync(ur => ur.IdUsuario == idUsuario && ur.IdRol == idRol);
        }

        public async Task<UsuarioRol> AgregarAsync(UsuarioRol usuarioRol)
        {
            _context.UsuariosRoles.Add(usuarioRol);
            await _context.SaveChangesAsync();
            return usuarioRol;
        }

        public async Task EliminarAsync(long id)
        {
            var usuarioRol = await _context.UsuariosRoles.FindAsync(id);
            if (usuarioRol != null)
            {
                _context.UsuariosRoles.Remove(usuarioRol);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<UsuarioRol>> ObtenerPorUsuarioAsync(long idUsuario)
        {
            return await _context.UsuariosRoles
                .Include(ur => ur.Rol)
                .Where(ur => ur.IdUsuario == idUsuario)
                .ToListAsync();
        }

        public async Task<IEnumerable<UsuarioRol>> ObtenerPorRolAsync(long idRol)
        {
            return await _context.UsuariosRoles
                .Include(ur => ur.Usuario)
                .Where(ur => ur.IdRol == idRol)
                .ToListAsync();
        }
    }
}
