using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore;
using MediatR;
using Dapper;
using Inventario.API.Infrastructure.Datos;
using Inventario.API.Infrastructure.Repositorios;
using Inventario.API.Domain.Interfaces;
using Inventario.API.Application.Manejadores;
using Inventario.API.Application.Comandos;
using Inventario.API.Application.Interfaces;
using Inventario.API.Application.Servicios;
using System.Reflection;

Console.WriteLine("==================================================");
Console.WriteLine("HERRAMIENTA DE RECALCULO Y SINCRONIZACION MANUAL");
Console.WriteLine("==================================================");

var services = new ServiceCollection();

// Configuración de Logging
services.AddLogging(builder => builder.AddConsole());

// Configuración de Base de Datos
var connectionString = "Host=localhost;Database=sistema_comercial;Username=postgres;Password=aaAA11++";
services.AddDbContext<InventarioDbContext>(options =>
{
    options.UseNpgsql(connectionString);
    options.UseSnakeCaseNamingConvention();
});

// Registrar dependencias de Infraestructura (Repositorios)
services.AddScoped<IAlmacenRepositorio, AlmacenRepositorio>();
services.AddScoped<IStockRepositorio, StockRepositorio>();
services.AddScoped<IKardexMovimientoRepositorio, KardexMovimientoRepositorio>();
services.AddScoped<IKardexPeriodoControlRepositorio, KardexPeriodoControlRepositorio>();
services.AddScoped<IKardexRecalculoLogRepositorio, KardexRecalculoLogRepositorio>();

// Registrar dependencias de Aplicación (Servicios)
services.AddScoped<IKardexService, KardexService>();
services.AddScoped<IKardexRecalculoService, KardexRecalculoService>();
services.AddScoped<IValidacionReglaSunatService, ValidacionReglaSunatService>();

// Mapeos y MediatR
services.AddMediatR(cfg => {
    cfg.RegisterServicesFromAssembly(typeof(SincronizarComprasHistManejador).Assembly);
});

services.AddScoped<IInventarioDbContext>(sp => sp.GetRequiredService<InventarioDbContext>());

var serviceProvider = services.BuildServiceProvider();

using (var scope = serviceProvider.CreateScope())
{
    var mediator = scope.ServiceProvider.GetRequiredService<IMediator>();
    
    try 
    {
        // Diagnóstico de Almacenes
        var context = scope.ServiceProvider.GetRequiredService<IInventarioDbContext>();
        var connection = context.GetDbConnection();
        if (connection.State != System.Data.ConnectionState.Open) 
        {
             if (connection is System.Data.Common.DbConnection dbConn) await dbConn.OpenAsync();
             else connection.Open();
        }
        
        var almacenes = await connection.QueryAsync("SELECT id_almacen as id, nombre_almacen as nombre FROM inventario.almacenes");
        Console.WriteLine("------------------------------------------");
        Console.WriteLine("ALMACENES DISPONIBLES EN BD:");
        foreach(var alm in almacenes) {
            Console.WriteLine($" - ID: {alm.id}, Nombre: {alm.nombre}");
        }
        Console.WriteLine("------------------------------------------");

        // Diagnóstico de Integridad
        Console.WriteLine("\nVERIFICANDO INTEGRIDAD DE ALMACENES...");
        var idsVentas = await connection.QueryAsync<long>("SELECT DISTINCT id_almacen FROM ventas.ventas");
        var idsCompras = await connection.QueryAsync<long>("SELECT DISTINCT id_almacen FROM compras.compras");
        var idsValidos = (await connection.QueryAsync<long>("SELECT id_almacen FROM inventario.almacenes")).ToHashSet();

        Console.WriteLine($"IDs en Ventas: {string.Join(", ", idsVentas)}");
        Console.WriteLine($"IDs en Compras: {string.Join(", ", idsCompras)}");
        Console.WriteLine($"IDs Válidos en Almacenes: {string.Join(", ", idsValidos)}");

        foreach (var id in idsVentas.Concat(idsCompras).Distinct())
        {
            if (!idsValidos.Contains(id))
            {
                Console.WriteLine($"[WARNING] ID Almacén {id} encontrado en documentos pero NO en tabla almacenes.");
            }
        }
        Console.WriteLine("------------------------------------------");

        Console.WriteLine("\n[1/1] Iniciando Sincronización Histórica (Reiniciar = true)...");
        var result = await mediator.Send(new SincronizarComprasHistComando(Reiniciar: true));
        
        Console.WriteLine("\nRESULTADO:");
        Console.WriteLine("--------------------------------------------------");
        Console.WriteLine(result);
        Console.WriteLine("--------------------------------------------------");
        Console.WriteLine("\nPROCESO COMPLETADO EXITOSAMENTE.");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"\nERROR CRÍTICO: {ex.Message}");
        if (ex.InnerException != null)
            Console.WriteLine($"DETALLE: {ex.InnerException.Message}");
    }
}

Console.WriteLine("\nPresione cualquier tecla para salir...");
