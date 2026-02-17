using Microsoft.EntityFrameworkCore;

namespace Compras.API.Application.Interfaces
{
    public interface IComprasDbContext
    {
        DbSet<Compras.API.Domain.Entidades.Compra> Compras { get; set; }
        DbSet<Compras.API.Domain.Entidades.DetalleCompra> DetallesCompra { get; set; }
        DbSet<Compras.API.Domain.Entidades.OrdenCompra> OrdenesCompra { get; set; }
        DbSet<Compras.API.Domain.Entidades.DetalleOrdenCompra> DetallesOrdenCompra { get; set; }
        DbSet<Compras.API.Domain.Entidades.Proveedor> Proveedores { get; set; }
        DbSet<Compras.API.Domain.Entidades.Referencias.CatalogoReferencia> Catalogos { get; set; }
        DbSet<Compras.API.Domain.Entidades.Nota> Notas { get; set; }
        DbSet<Compras.API.Domain.Entidades.DetalleNota> DetallesNota { get; set; }

        Task<int> SaveChangesAsync(CancellationToken cancellationToken);
    }
}
