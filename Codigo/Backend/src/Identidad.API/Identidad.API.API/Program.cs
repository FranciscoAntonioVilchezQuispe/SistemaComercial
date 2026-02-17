using Identidad.API.Infrastructure.Datos;
using Identidad.API.Domain.Interfaces;
using Identidad.API.Infrastructure.Repositorios;
using Microsoft.EntityFrameworkCore;
using Identidad.API.Endpoints;
using Nucleo.Comun.Application.Extensions;
using Nucleo.Comun.API.Extensions;

var builder = WebApplication.CreateBuilder(args);
builder.AddCentralizedLogging();

// Add services to the container.
builder.Services.AddDbContext<IdentidadDbContext>(options =>
{
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"));
    options.UseSnakeCaseNamingConvention();
});

// Registros de Infraestructura
builder.Services.AddScoped<IUsuarioRepositorio, UsuarioRepositorio>();
builder.Services.AddScoped<IRolRepositorio, RolRepositorio>();
builder.Services.AddScoped<IPermisoRepositorio, PermisoRepositorio>();

// Registros del sistema de permisos granulares
builder.Services.AddScoped<IMenuRepositorio, MenuRepositorio>();
builder.Services.AddScoped<ITipoPermisoRepositorio, TipoPermisoRepositorio>();
builder.Services.AddScoped<IRolMenuRepositorio, RolMenuRepositorio>();
builder.Services.AddScoped<IRolMenuPermisoRepositorio, RolMenuPermisoRepositorio>();
builder.Services.AddScoped<IUsuarioRolRepositorio, UsuarioRolRepositorio>();

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
app.MapUsuarioEndpoints();
app.MapRolEndpoints();
app.MapPermisoEndpoints();

// Map Endpoints del sistema de permisos granulares
app.MapMenuEndpoints();
app.MapTipoPermisoEndpoints();
app.MapRolMenuEndpoints();
app.MapUsuarioPermisoEndpoints();

app.Run();
