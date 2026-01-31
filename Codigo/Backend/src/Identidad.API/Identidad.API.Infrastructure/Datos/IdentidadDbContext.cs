using Identidad.API.Domain.Entidades;
using Microsoft.EntityFrameworkCore;

namespace Identidad.API.Infrastructure.Datos
{
    public class IdentidadDbContext : DbContext
    {
        public IdentidadDbContext(DbContextOptions<IdentidadDbContext> options) : base(options)
        {
        }

        public DbSet<Trabajador> Trabajadores { get; set; }
        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<Rol> Roles { get; set; }
        public DbSet<Permiso> Permisos { get; set; }
        public DbSet<RolPermiso> RolesPermisos { get; set; }
        public DbSet<Cargo> Cargos { get; set; }
        public DbSet<Area> Areas { get; set; }
        
        // Nuevas entidades del sistema de permisos granulares
        public DbSet<Menu> Menus { get; set; }
        public DbSet<TipoPermiso> TiposPermiso { get; set; }
        public DbSet<RolMenu> RolesMenus { get; set; }
        public DbSet<RolMenuPermiso> RolesMenusPermisos { get; set; }
        public DbSet<UsuarioRol> UsuariosRoles { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            
            // Esquema por defecto para Identidad
            modelBuilder.HasDefaultSchema("identidad");

            // Clave compuesta para RolPermiso
            modelBuilder.Entity<RolPermiso>().HasKey(rp => new { rp.IdRol, rp.IdPermiso });
            
            // Índice único para RolMenuPermiso
            modelBuilder.Entity<RolMenuPermiso>()
                .HasIndex(rmp => new { rmp.IdRolMenu, rmp.IdTipoPermiso })
                .IsUnique();
                
            // Índice único para UsuarioRol
            modelBuilder.Entity<UsuarioRol>()
                .HasIndex(ur => new { ur.IdUsuario, ur.IdRol })
                .IsUnique();
                
            // Índice único para RolMenu
            modelBuilder.Entity<RolMenu>()
                .HasIndex(rm => new { rm.IdRol, rm.IdMenu })
                .IsUnique();
        }
    }
}
