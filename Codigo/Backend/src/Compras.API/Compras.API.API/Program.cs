using Compras.API.Infrastructure.Datos;
using Compras.API.Domain.Interfaces;
using Compras.API.Infrastructure.Repositorios;
using Microsoft.EntityFrameworkCore;
using Compras.API.Endpoints;

var builder = WebApplication.CreateBuilder(args);

// DbContext e Interfaz
builder.Services.AddDbContext<ComprasDbContext>(options =>
{
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"));
    options.UseSnakeCaseNamingConvention();
});

// Registrar la interfaz para los manejadores de MediatR
builder.Services.AddScoped<Compras.API.Application.Interfaces.IComprasDbContext>(provider => provider.GetRequiredService<ComprasDbContext>());

// Registros de Infraestructura
builder.Services.AddScoped<IProveedorRepositorio, ProveedorRepositorio>();
builder.Services.AddScoped<IOrdenCompraRepositorio, OrdenCompraRepositorio>();
builder.Services.AddScoped<ICompraRepositorio, CompraRepositorio>();

// MediatR
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(Compras.API.Application.DTOs.CompraDto).Assembly));

// Integración con Inventario (Servicios Externos)
builder.Services.AddHttpClient<Compras.API.Application.Interfaces.IInventarioServicio, Compras.API.Application.Integracion.InventarioServicio>(client =>
{
    client.BaseAddress = new Uri(builder.Configuration["ExternalServices:InventarioUrl"] ?? "http://localhost:5004/api/");
});

// CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend",
        policy => policy.WithOrigins("http://localhost:5180")
                        .AllowAnyMethod()
                        .AllowAnyHeader());
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowFrontend");

app.UseHttpsRedirection();

// Map Endpoints
app.MapProveedorEndpoints();
app.MapOrdenCompraEndpoints();
app.MapCompraEndpoints();

app.Run();
