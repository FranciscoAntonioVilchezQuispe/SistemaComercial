using Catalogo.Domain.Entidades;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Catalogo.Infrastructure.Datos.Configuraciones
{
    public class ProductoConfiguracion : IEntityTypeConfiguration<Producto>
    {
        public void Configure(EntityTypeBuilder<Producto> builder)
        {
            builder.ToTable("productos", "catalogo");
            builder.Property(x => x.Id).HasColumnName("id_producto"); // PK Manual
            builder.HasKey(x => x.Id);

            // Auditoria
            builder.Property(x => x.Activado).HasColumnName("activado");
            builder.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
            builder.Property(x => x.UsuarioCreacion).HasColumnName("usuario_creacion");
            builder.Property(x => x.FechaActualizacion).HasColumnName("fecha_modificacion");
            builder.Property(x => x.UsuarioActualizacion).HasColumnName("usuario_modificacion");
            builder.Ignore(x => x.EventosDominio);

            builder.Property(x => x.CodigoProducto).HasMaxLength(50).IsRequired();
            builder.HasIndex(x => x.CodigoProducto).IsUnique();

            builder.Property(x => x.NombreProducto).HasMaxLength(255).IsRequired();
            builder.Property(x => x.Sku).HasMaxLength(100);
            builder.Property(x => x.ImagenPrincipalUrl).HasColumnName("imagen_principal_url");

            // Precios con precision
            builder.Property(x => x.PrecioCompra).HasPrecision(12, 2);
            builder.Property(x => x.PrecioVentaPublico).HasPrecision(12, 2);
            builder.Property(x => x.PrecioVentaMayorista).HasPrecision(12, 2);
            builder.Property(x => x.PrecioVentaDistribuidor).HasPrecision(12, 2);
            builder.Property(x => x.PorcentajeImpuesto).HasPrecision(5, 2);
            builder.Property(x => x.StockMinimo).HasPrecision(10, 3);
            builder.Property(x => x.StockMaximo).HasPrecision(10, 3);

            // Relaciones
            builder.Property(x => x.IdUnidadMedida).HasColumnName("id_unidad");
            builder.HasOne(x => x.Categoria).WithMany().HasForeignKey(x => x.IdCategoria).OnDelete(DeleteBehavior.Restrict);
            builder.HasOne(x => x.Marca).WithMany().HasForeignKey(x => x.IdMarca).OnDelete(DeleteBehavior.Restrict);
            builder.HasOne(x => x.UnidadMedida).WithMany().HasForeignKey(x => x.IdUnidadMedida).OnDelete(DeleteBehavior.Restrict);
        }
    }

    public class CategoriaConfiguracion : IEntityTypeConfiguration<Categoria>
    {
        public void Configure(EntityTypeBuilder<Categoria> builder)
        {
            builder.ToTable("categorias", "catalogo");
            builder.Property(x => x.Id).HasColumnName("id_categoria");
            builder.HasKey(x => x.Id);

            // Auditoria
            builder.Property(x => x.Activado).HasColumnName("activado");
            builder.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
            builder.Property(x => x.UsuarioCreacion).HasColumnName("usuario_creacion");
            builder.Property(x => x.FechaActualizacion).HasColumnName("fecha_modificacion");
            builder.Property(x => x.UsuarioActualizacion).HasColumnName("usuario_modificacion");
            builder.Ignore(x => x.EventosDominio);
            builder.Property(x => x.NombreCategoria).HasMaxLength(100).IsRequired().HasColumnName("nombre_categoria"); // Maps to nombre_categoria
            builder.HasOne(x => x.CategoriaPadre).WithMany(x => x.SubCategorias).HasForeignKey(x => x.IdCategoriaPadre);
        }
    }

    public class MarcaConfiguracion : IEntityTypeConfiguration<Marca>
    {
        public void Configure(EntityTypeBuilder<Marca> builder)
        {
            builder.ToTable("marcas", "catalogo");
            builder.Property(x => x.Id).HasColumnName("id_marca");
            builder.HasKey(x => x.Id);

            // Auditoria
            builder.Property(x => x.Activado).HasColumnName("activado");
            builder.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
            builder.Property(x => x.UsuarioCreacion).HasColumnName("usuario_creacion");
            builder.Property(x => x.FechaActualizacion).HasColumnName("fecha_modificacion");
            builder.Property(x => x.UsuarioActualizacion).HasColumnName("usuario_modificacion");
            builder.Ignore(x => x.EventosDominio);
            builder.Property(x => x.NombreMarca).HasMaxLength(100).IsRequired().HasColumnName("nombre_marca");
        }
    }

    public class UnidadMedidaConfiguracion : IEntityTypeConfiguration<UnidadMedida>
    {
        public void Configure(EntityTypeBuilder<UnidadMedida> builder)
        {
            builder.ToTable("unidades_medida", "catalogo");
            builder.Property(x => x.Id).HasColumnName("id_unidad");
            builder.HasKey(x => x.Id);

            // Auditoria
            builder.Property(x => x.Activado).HasColumnName("activado");
            builder.Property(x => x.FechaCreacion).HasColumnName("fecha_creacion");
            builder.Property(x => x.UsuarioCreacion).HasColumnName("usuario_creacion");
            builder.Property(x => x.FechaActualizacion).HasColumnName("fecha_modificacion");
            builder.Property(x => x.UsuarioActualizacion).HasColumnName("usuario_modificacion");
            builder.Ignore(x => x.EventosDominio);
            builder.Property(x => x.NombreUnidad).HasMaxLength(50).IsRequired().HasColumnName("nombre_unidad");
            builder.Property(x => x.Simbolo).HasMaxLength(10);
        }
    }
}
