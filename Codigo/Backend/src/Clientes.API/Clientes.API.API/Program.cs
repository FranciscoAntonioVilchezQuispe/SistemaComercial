using Clientes.API.Infrastructure.Datos;
using Clientes.API.Domain.Interfaces;
using Clientes.API.Infrastructure.Repositorios;
using Microsoft.EntityFrameworkCore;
using Clientes.API.Endpoints;
using Nucleo.Comun.Application.Extensions;
using Nucleo.Comun.API.Extensions;

var builder = WebApplication.CreateBuilder(args);
builder.AddCentralizedLogging();

// Add services to the container.
builder.Services.AddDbContext<ClientesDbContext>(options =>
{
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"));
    options.UseSnakeCaseNamingConvention();
});

// Registros de Infraestructura
builder.Services.AddScoped<IClienteRepositorio, ClienteRepositorio>();
builder.Services.AddScoped<IContactoClienteRepositorio, ContactoClienteRepositorio>();

// CORS
// CORS
var frontendUrl = builder.Configuration.GetValue<string>("FrontendUrl") ?? "http://localhost:5180";

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend",
        policy => policy.SetIsOriginAllowed(_ => true)
                        .AllowAnyMethod()
                        .AllowAnyHeader()
                        .AllowCredentials());
});

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
app.MapClienteEndpoints();
app.MapContactoClienteEndpoints();

app.Run();
