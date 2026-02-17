using Catalogo.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using Catalogo.API.Endpoints;
using Nucleo.Comun.Application.Extensions;
using Nucleo.Comun.API.Extensions;

var builder = WebApplication.CreateBuilder(args);
builder.AddCentralizedLogging();

// Fix for Npgsql Timestamp
AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

// Configurar DB
builder.Services.AddDbContext<CatalogoDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"))
           .UseSnakeCaseNamingConvention());

// Configurar MediatR (Scan Application assm)
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssemblies(
    typeof(Catalogo.Application.Comandos.CrearProductoComando).Assembly
));

// Enable CORS
var frontendUrl = builder.Configuration.GetValue<string>("FrontendUrl") ?? "http://localhost:5180";

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend",
        policy =>
        {
            policy.SetIsOriginAllowed(_ => true) // Allow any origin
                  .AllowAnyHeader()
                  .AllowAnyMethod()
                  .AllowCredentials();
        });
});

// Registros de Infraestructura
builder.Services.AddScoped<Catalogo.Domain.Interfaces.IProductoRepositorio, Catalogo.Infrastructure.Repositorios.ProductoRepositorio>();
builder.Services.AddScoped<Catalogo.Domain.Interfaces.ICategoriaRepositorio, Catalogo.Infrastructure.Repositorios.CategoriaRepositorio>();
builder.Services.AddScoped<Catalogo.Domain.Interfaces.IMarcaRepositorio, Catalogo.Infrastructure.Repositorios.MarcaRepositorio>();
builder.Services.AddScoped<Catalogo.Domain.Interfaces.IUnidadMedidaRepositorio, Catalogo.Infrastructure.Repositorios.UnidadMedidaRepositorio>();
builder.Services.AddScoped<Catalogo.Domain.Interfaces.IListaPrecioRepositorio, Catalogo.Infrastructure.Repositorios.ListaPrecioRepositorio>();
builder.Services.AddScoped<Catalogo.Domain.Interfaces.IImagenProductoRepositorio, Catalogo.Infrastructure.Repositorios.ImagenProductoRepositorio>();
builder.Services.AddScoped<Catalogo.Domain.Interfaces.IVarianteProductoRepositorio, Catalogo.Infrastructure.Repositorios.VarianteProductoRepositorio>();


// Configurar JSON para usar camelCase
builder.Services.ConfigureHttpJsonOptions(options =>
{
    options.SerializerOptions.PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase;
});

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseManejoExcepcionesGlobal();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowFrontend");

app.UseHttpsRedirection();

// Map Endpoints
app.MapProductoEndpoints();
app.MapCategoriaEndpoints();
app.MapMarcaEndpoints();
app.MapUnidadMedidaEndpoints();
app.MapListaPrecioEndpoints();
app.MapImagenProductoEndpoints();
app.MapVarianteProductoEndpoints();

app.Run();
