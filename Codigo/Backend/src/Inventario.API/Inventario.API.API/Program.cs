using Inventario.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using Inventario.API.Domain.Interfaces;
using Inventario.API.Infrastructure.Repositorios;
using Inventario.API.Endpoints;
using Inventario.API.Application.Interfaces;
using Microsoft.OpenApi;

using Nucleo.Comun.Application.Extensions;
using Nucleo.Comun.API.Extensions;

AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

var builder = WebApplication.CreateBuilder(args);
builder.AddCentralizedLogging();

// Add services to the container.
// builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Inventario.API", Version = "v1" });
});

// DbContext e Interfaz
builder.Services.AddDbContext<InventarioDbContext>(options =>
{
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"));
    options.UseSnakeCaseNamingConvention();
});

// Importante: Registrar la interfaz para los manejadores de MediatR
builder.Services.AddScoped<IInventarioDbContext>(provider => provider.GetRequiredService<InventarioDbContext>());

// Repositorios
builder.Services.AddScoped<IAlmacenRepositorio, AlmacenRepositorio>();
builder.Services.AddScoped<IStockRepositorio, StockRepositorio>();

// MediatR (Scan Application Assembly de forma segura)
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(Inventario.API.Application.Comandos.CrearMovimientoInventarioComando).Assembly));

// CORS
// CORS
var frontendUrl = builder.Configuration.GetValue<string>("FrontendUrl") ?? "http://localhost:5180";

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend",
        builder =>
        {
            builder.SetIsOriginAllowed(_ => true)
                   .AllowAnyMethod()
                   .AllowAnyHeader()
                   .AllowCredentials();
        });
});

// Configuración de Autorización
builder.Services.AddAuthorization();

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseManejoExcepcionesGlobal();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// app.UseHttpsRedirection(); // Opcional en dev local
app.UseCors("AllowFrontend");
app.UseAuthorization();
// app.MapControllers();

// Map Endpoints
app.MapAlmacenEndpoints();
app.MapStockEndpoints();
app.MapMovimientosEndpoints();

app.Run();
