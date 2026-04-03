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
        DbSet<Compras.API.Domain.Entidades.NotaCreditoCompra> NotasCredito { get; set; }
        DbSet<Compras.API.Domain.Entidades.NotaCreditoDetalleCompra> NotasCreditoDetalles { get; set; }
        DbSet<Compras.API.Domain.Entidades.NotaDebitoCompra> NotasDebito { get; set; }
        DbSet<Compras.API.Domain.Entidades.NotaDebitoDetalleCompra> NotasDebitoDetalles { get; set; }

        Task<int> SaveChangesAsync(CancellationToken cancellationToken);
        System.Data.Common.DbConnection GetDbConnection();
    }
}
