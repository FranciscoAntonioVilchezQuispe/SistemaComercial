using Contabilidad.API.Infrastructure.Datos;
using Contabilidad.API.Domain.Interfaces;
using Contabilidad.API.Infrastructure.Repositorios;
using Microsoft.EntityFrameworkCore;
using Contabilidad.API.Endpoints;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddDbContext<ContabilidadDbContext>(options =>
{
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"));
    options.UseSnakeCaseNamingConvention();
});

// Registros de Infraestructura
builder.Services.AddScoped<IPlanCuentaRepositorio, PlanCuentaRepositorio>();
builder.Services.AddScoped<ICentroCostoRepositorio, CentroCostoRepositorio>();

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
app.MapPlanCuentaEndpoints();
app.MapCentroCostoEndpoints();

app.Run();
