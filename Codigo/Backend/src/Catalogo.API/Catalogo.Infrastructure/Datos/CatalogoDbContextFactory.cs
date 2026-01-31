using Catalogo.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;
using System.IO;

namespace Catalogo.Infrastructure.Datos
{
    public class CatalogoDbContextFactory : IDesignTimeDbContextFactory<CatalogoDbContext>
    {
        public CatalogoDbContext CreateDbContext(string[] args)
        {
            // Construir configuración
            // Asumimos que appsettings.json está en el proyecto API, nivel superior relativo
            var configuration = new ConfigurationBuilder()
                .SetBasePath(Path.Combine(Directory.GetCurrentDirectory(), "../Catalogo.API"))
                .AddJsonFile("appsettings.json")
                .Build();

            var builder = new DbContextOptionsBuilder<CatalogoDbContext>();
            var connectionString = configuration.GetConnectionString("DefaultConnection");

            builder.UseNpgsql(connectionString);

            return new CatalogoDbContext(builder.Options);
        }
    }
}
