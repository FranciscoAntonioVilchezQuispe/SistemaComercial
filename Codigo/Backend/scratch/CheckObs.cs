using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;
using Inventario.API.Infrastructure.Datos;
using Inventario.API.Application.Interfaces;

var services = new ServiceCollection();
var connectionString = "Host=localhost;Database=sistema_comercial;Username=postgres;Password=aaAA11++";
services.AddDbContext<InventarioDbContext>(options => {
    options.UseNpgsql(connectionString);
    options.UseSnakeCaseNamingConvention();
});

var serviceProvider = services.BuildServiceProvider();
using var scope = serviceProvider.CreateScope();
var db = scope.ServiceProvider.GetRequiredService<InventarioDbContext>();

Console.WriteLine("CONSULTANDO MOVIMIENTOS EXISTENTES (COMPRAS/VENTAS):");
var movs = await db.MovimientosInventario
    .Where(m => m.ReferenciaModulo == "COMPRAS" || m.ReferenciaModulo == "VENTAS")
    .Select(m => new { m.IdMovimiento, m.Observaciones, m.ReferenciaModulo, m.IdReferencia })
    .ToListAsync();

foreach(var m in movs) {
    Console.WriteLine($"ID: {m.IdMovimiento} | Mod: {m.ReferenciaModulo} | Ref: {m.IdReferencia} | Obs: [{m.Observaciones}]");
}
