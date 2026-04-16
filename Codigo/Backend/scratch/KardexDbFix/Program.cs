using Inventario.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace KardexDbFix
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var services = new ServiceCollection();
            var configuration = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json", optional: true)
                .Build();

            string connectionString = "Host=localhost;Database=sistema_comercial;Username=postgres;Password=aaAA11++";
            
            services.AddDbContext<InventarioDbContext>(options =>
                options.UseNpgsql(connectionString));

            var serviceProvider = services.BuildServiceProvider();

            using (var scope = serviceProvider.CreateScope())
            {
                var context = scope.ServiceProvider.GetRequiredService<InventarioDbContext>();
                
                Console.WriteLine("--- Verificando y Corrigiendo Tipos de Comprobantes (SUNAT) ---");

                var todos = await context.SyncTiposComprobante.ToListAsync();
                Console.WriteLine("ID | CODIGO | NOMBRE");
                foreach(var t in todos) Console.WriteLine($"{t.Id} | {t.Codigo} | {t.Nombre}");

                // Corrección de NC (ID 5)
                var nc = await context.SyncTiposComprobante.FirstOrDefaultAsync(t => t.Id == 5);
                if (nc != null)
                {
                    Console.WriteLine($"Actualizando NC (ID 5): {nc.Codigo} -> 07");
                    nc.Codigo = "07";
                    nc.Nombre = "Nota de Crédito";
                    nc.MueveStock = true;
                    nc.TipoMovimientoStock = "DEPENDIENTE";
                    nc.MovimientoStockVenta = "ENTRADA"; 
                    nc.MovimientoStockCompra = "SALIDA"; 
                }
                
                // Corrección de ND (ID 6)
                var nd = await context.SyncTiposComprobante.FirstOrDefaultAsync(t => t.Id == 6);
                if (nd != null)
                {
                    Console.WriteLine($"Actualizando ND (ID 6): {nd.Codigo} -> 08");
                    nd.Codigo = "08";
                    nd.Nombre = "Nota de Débito";
                    nd.MueveStock = true;
                    nd.TipoMovimientoStock = "DEPENDIENTE";
                    nd.MovimientoStockVenta = "SALIDA"; 
                    nd.MovimientoStockCompra = "ENTRADA"; 
                }

                try 
                {
                    await context.SaveChangesAsync();
                    Console.WriteLine("--- Corrección Finalizada con Éxito ---");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"[ERROR] Error al guardar cambios: {ex.Message}");
                    if (ex.InnerException != null) Console.WriteLine($"[INNER ERROR] {ex.InnerException.Message}");
                }
            }
        }
    }
}
