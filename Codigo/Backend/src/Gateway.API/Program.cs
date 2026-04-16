using Yarp.ReverseProxy.Transforms;
using Nucleo.Comun.API.Extensions;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using System.Security.Claims;
using System.Linq;

var builder = WebApplication.CreateBuilder(args);

// Configurar JWT Authentication
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.RequireHttpsMetadata = false;
        options.SaveToken = true;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"] ?? "SistemaComercial",
            ValidAudience = builder.Configuration["Jwt:Audience"] ?? "SistemaComercialAPI",
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:SecretKey"] ?? "SUPER_SECRET_KEY_PROVISIONAL_1234567890"))
        };
    });

builder.Services.AddAuthorization();

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add YARP
builder.Services.AddReverseProxy()
    .LoadFromConfig(builder.Configuration.GetSection("ReverseProxy"))
    .AddTransforms(builderContext =>
    {
        builderContext.AddRequestTransform(transformContext =>
        {
            var user = transformContext.HttpContext.User;
            if (user?.Identity?.IsAuthenticated == true)
            {
                var userId = user.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                var rolesList = user.FindAll("roles").Select(c => c.Value);
                var permisosList = user.FindAll("permisos").Select(c => c.Value);

                if (!string.IsNullOrEmpty(userId))
                    transformContext.ProxyRequest.Headers.Add("X-User-Id", userId);
                
                if (rolesList.Any())
                    transformContext.ProxyRequest.Headers.Add("X-User-Roles", string.Join(",", rolesList));
                    
                if (permisosList.Any())
                    transformContext.ProxyRequest.Headers.Add("X-User-Permisos", string.Join(",", permisosList));
            }
            return ValueTask.CompletedTask;
        });

        builderContext.AddResponseTransform(transformContext =>
        {
            if (transformContext.ProxyResponse != null)
            {
                transformContext.ProxyResponse.Headers.Remove("Access-Control-Allow-Origin");
                transformContext.ProxyResponse.Headers.Remove("Access-Control-Allow-Credentials");
                transformContext.ProxyResponse.Headers.Remove("Access-Control-Allow-Methods");
                transformContext.ProxyResponse.Headers.Remove("Access-Control-Allow-Headers");
            }
            return ValueTask.CompletedTask;
        });
    });

// Add Global CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.SetIsOriginAllowed(_ => true) 
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});

var app = builder.Build();

app.UseManejoExcepcionesGlobal();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowFrontend");

app.UseAuthentication();
app.UseAuthorization();

// CUSTOM ENFORCEMENT MIDDLEWARE
app.Use(async (context, next) =>
{
    var path = context.Request.Path.Value?.ToLower() ?? "";
    var method = context.Request.Method;

    // By-pass auth (dejamos pasar al proxy AuthEndpoints)
    if (path.StartsWith("/api/auth"))
    {
        await next();
        return;
    }

    // Require Auth para todo lo de /api/ salvo estáticos
    if (path.StartsWith("/api/") && context.User?.Identity?.IsAuthenticated != true)
    {
        context.Response.StatusCode = 401;
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsJsonAsync(new { 
            status = 401, 
            message = "No autorizado. Token requerido o inválido.",
            transactionId = DateTime.Now.ToString("yyyyMMddHHmmssfff")
        });
        return;
    }

    var roles = context.User?.FindAll("roles").Select(c => c.Value).ToList() ?? new List<string>();
    var permisos = context.User?.FindAll("permisos").Select(c => c.Value).ToList() ?? new List<string>();

    bool esAdmin = roles.Contains("ADMIN");
    bool esVendedor = roles.Contains("VENDEDOR");

    // Seguridad: Rutas de administración
    bool authRutaAdmin = path.StartsWith("/api/identidad") || 
                         path.StartsWith("/api/configuracion") || 
                         path.StartsWith("/api/contabilidad") ||
                         (path.StartsWith("/api/catalogo") && method != "GET") ||
                         (path.StartsWith("/api/clientes") && method != "GET");

    if (authRutaAdmin && !esAdmin)
    {
        context.Response.StatusCode = 403;
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsJsonAsync(new { 
            status = 403, 
            message = "Acceso denegado. Se requieren privilegios administrativos.",
            transactionId = DateTime.Now.ToString("yyyyMMddHHmmssfff")
        });
        return;
    }

    // Seguridad Granular Permisos (Sistema Dinámico)
    var pathLower = path.ToLower();
    
    // Mapeo simple de rutas a códigos de menú
    string? menuCodigo = null;
    if (pathLower.StartsWith("/api/ventas")) menuCodigo = "VENTAS";
    else if (pathLower.StartsWith("/api/compras")) menuCodigo = "COMPRAS";
    else if (pathLower.StartsWith("/api/inventario")) menuCodigo = "INVENTARIO";
    else if (pathLower.StartsWith("/api/clientes")) menuCodigo = "CLIENTES";
    else if (pathLower.StartsWith("/api/productos")) menuCodigo = "CATALOGO";

    if (menuCodigo != null && !esAdmin)
    {
        string permisoRequerido = method switch
        {
            "GET" => "VER",
            "POST" => "CREAR",
            "PUT" => "EDITAR",
            "PATCH" => "EDITAR",
            "DELETE" => "ELIMINAR",
            _ => "VER"
        };

        string permisoFull = $"{menuCodigo}:{permisoRequerido}";
        
        if (!permisos.Contains(permisoFull))
        {
            context.Response.StatusCode = 403;
            context.Response.ContentType = "application/json";
            await context.Response.WriteAsJsonAsync(new { 
                status = 403, 
                message = $"Permiso insuficiente ({permisoRequerido}) para el módulo {menuCodigo}.",
                transactionId = DateTime.Now.ToString("yyyyMMddHHmmssfff")
            });
            return;
        }
    }

    await next();
});

// Map YARP
app.MapReverseProxy();

app.MapGet("/", () => "API Gateway Running");

app.Run();
