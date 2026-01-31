using Ventas.API.Infrastructure.Datos;
using Ventas.API.Domain.Interfaces;
using Ventas.API.Infrastructure.Repositorios;
using Microsoft.EntityFrameworkCore;
using Ventas.API.Endpoints;

var builder = WebApplication.CreateBuilder(args);

// DbContext e Interfaz
builder.Services.AddDbContext<VentasDbContext>(options =>
{
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"));
    options.UseSnakeCaseNamingConvention();
});

// Registrar la interfaz para los manejadores de MediatR
builder.Services.AddScoped<Ventas.API.Application.Interfaces.IVentasDbContext>(provider => provider.GetRequiredService<VentasDbContext>());

// Registros de Infraestructura
builder.Services.AddScoped<ICajaRepositorio, CajaRepositorio>();
builder.Services.AddScoped<IVentaRepositorio, VentaRepositorio>();
builder.Services.AddScoped<ICotizacionRepositorio, CotizacionRepositorio>();

// MediatR
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(Ventas.API.Application.DTOs.VentaDto).Assembly));

// Integración con Inventario (Servicios Externos)
builder.Services.AddHttpClient<Ventas.API.Application.Interfaces.IInventarioServicio, Ventas.API.Application.Integracion.InventarioServicio>(client =>
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
app.MapCajaEndpoints();
app.MapVentaEndpoints();
app.MapCotizacionEndpoints();

app.Run();
