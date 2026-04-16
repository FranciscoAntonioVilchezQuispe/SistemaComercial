using Identidad.API.Domain.Entidades;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Nucleo.Comun.Domain.Helpers;

namespace Identidad.API.Infrastructure.Datos
{
    public class IdentidadDbContext : DbContext
    {
        public IdentidadDbContext(DbContextOptions<IdentidadDbContext> options) : base(options)
        {
        }

        public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            // Aplicar auditoría centralizada (Estandarización Global)
            DbContextAuditHelper.AplicarAuditoriaDirecta(ChangeTracker);

            return base.SaveChangesAsync(cancellationToken);
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
        public DbSet<RefreshToken> RefreshTokens { get; set; }

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
                
            // Relación 1:1 Usuario - Trabajador
            modelBuilder.Entity<Usuario>()
                .HasOne(u => u.Trabajador)
                .WithOne(t => t.Usuario)
                .HasForeignKey<Usuario>(u => u.IdTrabajador)
                .OnDelete(DeleteBehavior.Restrict);

            // Índice único para RolMenu
            modelBuilder.Entity<RolMenu>()
                .HasIndex(rm => new { rm.IdRol, rm.IdMenu })
                .IsUnique();
        }

        protected override void ConfigureConventions(ModelConfigurationBuilder configurationBuilder)
        {
            // Convierte todos los DateTime a UTC al guardar en la base de datos
            configurationBuilder
                .Properties<DateTime>()
                .HaveConversion(typeof(DateTimeToUtcConverter));

            configurationBuilder
                .Properties<DateTime?>()
                .HaveConversion(typeof(NullableDateTimeToUtcConverter));
        }
    }

    // Convertidores para asegurar DateTimeKind.Utc
    public class DateTimeToUtcConverter : ValueConverter<DateTime, DateTime>
    {
        public DateTimeToUtcConverter()
            : base(v => v.Kind == DateTimeKind.Utc ? v : DateTime.SpecifyKind(v, DateTimeKind.Utc), v => v)
        {
        }
    }

    public class NullableDateTimeToUtcConverter : ValueConverter<DateTime?, DateTime?>
    {
        public NullableDateTimeToUtcConverter()
            : base(v => !v.HasValue ? v : (v.Value.Kind == DateTimeKind.Utc ? v : DateTime.SpecifyKind(v.Value, DateTimeKind.Utc)), v => v)
        {
        }
    }
}
