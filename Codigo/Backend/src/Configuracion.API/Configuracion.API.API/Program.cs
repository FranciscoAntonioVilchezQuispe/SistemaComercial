using Configuracion.API.Application.Interfaces;
using Configuracion.API.Application.Manejadores;
using Configuracion.API.Infrastructure.Datos;
using Configuracion.API.Infrastructure.Repositorios;
using Microsoft.EntityFrameworkCore;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Endpoints;

var builder = WebApplication.CreateBuilder(args);

// Configuración de DbContext
builder.Services.AddDbContext<ConfiguracionDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"))
           .UseSnakeCaseNamingConvention());

// Configuración de Controllers
// Configuración de Controllers (Eliminado en refactorización)
// builder.Services.AddControllers();

// Configuración de Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new()
    {
        Title = "Configuracion API",
        Version = "v1",
        Description = "API para gestión de configuración y catálogos del sistema"
    });
});

// Configurar JSON para usar camelCase
builder.Services.ConfigureHttpJsonOptions(options =>
{
    options.SerializerOptions.PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase;
});

// Configuración de CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.WithOrigins("http://localhost:5180", "http://localhost:3000")
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

// Configuración de Autorización
builder.Services.AddAuthorization();

// Registro de Repositorios
builder.Services.AddScoped<ITablaGeneralRepositorio, TablaGeneralRepositorio>();
builder.Services.AddScoped<IEmpresaRepositorio, EmpresaRepositorio>();
builder.Services.AddScoped<ISucursalRepositorio, SucursalRepositorio>();
builder.Services.AddScoped<IImpuestoRepositorio, ImpuestoRepositorio>();
builder.Services.AddScoped<IMetodoPagoRepositorio, MetodoPagoRepositorio>();
builder.Services.AddScoped<ISerieComprobanteRepositorio, SerieComprobanteRepositorio>();
builder.Services.AddScoped<ITipoComprobanteRepositorio, TipoComprobanteRepositorio>();

// Registro de Manejadores
builder.Services.AddScoped<ObtenerTodosCatalogosManejador>();
builder.Services.AddScoped<ObtenerCatalogoPorCodigoManejador>();
builder.Services.AddScoped<ObtenerValoresCatalogoManejador>();

var app = builder.Build();

// Configuración del pipeline HTTP
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowFrontend");

app.UseAuthorization();

app.MapEmpresaEndpoints();
app.MapSucursalEndpoints();
app.MapImpuestoEndpoints();
app.MapMetodoPagoEndpoints();
app.MapSerieComprobanteEndpoints();
app.MapTipoComprobanteEndpoints();
app.MapTablaGeneralEndpoints();

app.MapGet("/", () => "Configuracion API Running - v1.0");

app.Run();
