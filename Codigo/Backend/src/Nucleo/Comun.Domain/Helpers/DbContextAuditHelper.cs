using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace Nucleo.Comun.Domain.Helpers
{
    public static class DbContextAuditHelper
    {
        /// <summary>
        /// Aplica automáticamente los metadatos de auditoría (FechaCreacion, UsuarioCreacion, etc.)
        /// a todas las entidades que implementen IAuditable en el ChangeTracker.
        /// </summary>
        /// <param name="changeTracker">El ChangeTracker del DbContext</param>
        /// <param name="usuarioActual">Opcional: El nombre del usuario que realiza la operación</param>
        /// <param name="habilitarSoftDelete">Opcional: Si es true, las eliminaciones se convierten en actualizaciones con Activado = false</param>
        public static void AplicarAuditoriaDirecta(Microsoft.EntityFrameworkCore.ChangeTracking.ChangeTracker changeTracker, string usuarioActual = "SISTEMA", bool habilitarSoftDelete = false)
        {
            var entries = changeTracker.Entries()
                .Where(e => e.State == EntityState.Added || e.State == EntityState.Modified || (habilitarSoftDelete && e.State == EntityState.Deleted));

            foreach (var entry in entries)
            {
                if (entry.Entity is IAuditable auditableEntity)
                {
                    if (entry.State == EntityState.Added)
                    {
                        auditableEntity.FechaCreacion = DateTimeHelper.ObtenerAhoraLima();
                        auditableEntity.UsuarioCreacion = string.IsNullOrEmpty(auditableEntity.UsuarioCreacion) ? usuarioActual : auditableEntity.UsuarioCreacion;
                        auditableEntity.Activado = true;
                    }
                    else if (entry.State == EntityState.Modified)
                    {
                        auditableEntity.FechaActualizacion = DateTimeHelper.ObtenerAhoraLima();
                        auditableEntity.UsuarioActualizacion = usuarioActual;
                    }
                    else if (entry.State == EntityState.Deleted && habilitarSoftDelete)
                    {
                        // Convertir Delete a Update (Soft Delete)
                        entry.State = EntityState.Modified;
                        auditableEntity.Activado = false;
                        auditableEntity.FechaActualizacion = DateTimeHelper.ObtenerAhoraLima();
                        auditableEntity.UsuarioActualizacion = usuarioActual;
                    }
                }
            }
        }
    }
}
