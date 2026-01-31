using Identidad.API.Infrastructure.Datos;
using Identidad.API.Domain.Interfaces;
using Identidad.API.Infrastructure.Repositorios;
using Microsoft.EntityFrameworkCore;
using Identidad.API.Endpoints;

var builder = WebApplication.CreateBuilder(args);

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
app.MapUsuarioEndpoints();
app.MapRolEndpoints();
app.MapPermisoEndpoints();

// Map Endpoints del sistema de permisos granulares
app.MapMenuEndpoints();
app.MapTipoPermisoEndpoints();
app.MapRolMenuEndpoints();
app.MapUsuarioPermisoEndpoints();

app.Run();
