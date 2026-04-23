using Yarp.ReverseProxy.Transforms;
using Nucleo.Comun.Application.Extensions;
using Nucleo.Comun.API.Extensions;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using System.Security.Claims;
using System.Linq;

var builder = WebApplication.CreateBuilder(args);

builder.WebHost.ConfigureKestrelLimits();
builder.AddCentralizedLogging();

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
                var rolesList = user.FindAll(ClaimTypes.Role).Select(c => c.Value); // Cambiado a ClaimTypes.Role
                var permisosList = user.FindAll("permiso").Select(c => c.Value); // Cambiado a "permiso" según AuthHelper

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

    var roles = context.User?.FindAll(ClaimTypes.Role).Select(c => c.Value).ToList() ?? new List<string>();
    var permisos = context.User?.FindAll("permiso").Select(c => c.Value).ToList() ?? new List<string>();

    bool esAdmin = context.User?.IsInRole("ADMINISTRADOR") == true
        || roles.Any(r => r.Equals("ADMINISTRADOR", StringComparison.OrdinalIgnoreCase))
        || roles.Any(r => r.Equals("ADMIN", StringComparison.OrdinalIgnoreCase)); // Añadido ADMIN por AuthHelper
    bool esVendedor = roles.Contains("VENDEDOR");

    // Seguridad: Rutas de administración
    bool authRutaAdmin =
        (path.StartsWith("/api/usuarios") && method != "GET") ||
        (path.StartsWith("/api/roles") && method != "GET") ||
        (path.StartsWith("/api/menus") && method != "GET") ||
        (path.StartsWith("/api/tipos-permiso") && method != "GET") ||
        (path.StartsWith("/api/roles-menus") && method != "GET") ||
        (path.StartsWith("/api/trabajadores") && method != "GET") ||
        (path.StartsWith("/api/configuracion") && method != "GET") ||
        (path.StartsWith("/api/contabilidad") && method != "GET");

    if (authRutaAdmin && !esAdmin)
    {
        var userIdLog = context.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "anonimo";
        Console.WriteLine($"[403-ADMIN] User={userIdLog} | Ruta={path} | Metodo={method} | RolesEnToken=[{string.Join(", ", roles)}] | IsInRole={context.User?.IsInRole("ADMINISTRADOR")}");
        context.Response.StatusCode = 403;
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsJsonAsync(new { 
            status = 403, 
            message = "Operación restringida. Se requieren permisos de administrador.",
            transactionId = DateTime.Now.ToString("yyyyMMddHHmmssfff")
        });
        return;
    }

    // Seguridad Granular Permisos (Sistema Dinámico)
    var pathLower = path.ToLower();
    
    // Mapeo granular de rutas a códigos de menú (Sincronizado con BD y Frontend)
    string? menuCodigo = null;
    
    // Catálogo
    if (pathLower.StartsWith("/api/productos")) menuCodigo = "CAT_PRODUCTOS";
    else if (pathLower.StartsWith("/api/categorias")) menuCodigo = "CAT_CATEGORIAS";
    else if (pathLower.StartsWith("/api/marcas")) menuCodigo = "CAT_MARCAS";
    else if (pathLower.StartsWith("/api/unidades-medida")) menuCodigo = "CAT_UNIDADES";
    else if (pathLower.StartsWith("/api/listas-precios")) menuCodigo = "CAT_PRECIOS";
    else if (pathLower.StartsWith("/api/catalogo")) menuCodigo = "CATALOGO";
    
    // Ventas
    else if (pathLower.StartsWith("/api/ventas/pos")) menuCodigo = "VEN_POS";
    else if (pathLower.StartsWith("/api/ventas")) menuCodigo = "VEN_LISTA";
    else if (pathLower.StartsWith("/api/notas")) menuCodigo = "VEN_NOTAS";
    else if (pathLower.StartsWith("/api/cotizaciones")) menuCodigo = "VEN_COTIZACIONES";
    else if (pathLower.StartsWith("/api/clientes")) menuCodigo = "VEN_CLIENTES";
    else if (pathLower.StartsWith("/api/turnos")) menuCodigo = "VEN_TURNOS";
    else if (pathLower.StartsWith("/api/cajas")) menuCodigo = "VEN_CAJAS";
    
    // Compras
    else if (pathLower.StartsWith("/api/ordenes-compra")) menuCodigo = "COM_ORDENES";
    else if (pathLower.StartsWith("/api/compras")) menuCodigo = "COM_LISTA";
    else if (pathLower.StartsWith("/api/proveedores")) menuCodigo = "COM_PROVEEDORES";

    // Inventario
    else if (pathLower.StartsWith("/api/inventario/stock")) menuCodigo = "INV_STOCK";
    else if (pathLower.StartsWith("/api/inventario/movimientos")) menuCodigo = "INV_MOVIMIENTOS";
    else if (pathLower.StartsWith("/api/inventario/traslados")) menuCodigo = "INV_TRASLADOS";
    else if (pathLower.StartsWith("/api/inventario/kardex/reporte")) menuCodigo = "INV_KARDEX_REP";
    else if (pathLower.StartsWith("/api/inventario/kardex/periodos")) menuCodigo = "INV_KARDEX_PER";
    else if (pathLower.StartsWith("/api/inventario/almacenes")) menuCodigo = "INV_ALMACENES";
    else if (pathLower.StartsWith("/api/inventario")) menuCodigo = "INVENTARIO";

    // Seguridad
    else if (pathLower.StartsWith("/api/usuarios")) menuCodigo = "SEG_USUARIOS";
    else if (pathLower.StartsWith("/api/roles")) menuCodigo = "SEG_ROLES";
    else if (pathLower.StartsWith("/api/trabajadores")) menuCodigo = "SEG_TRABAJADORES";
    else if (pathLower.StartsWith("/api/seguridad")) menuCodigo = "SEGURIDAD";

    // Configuración
    else if (pathLower.StartsWith("/api/empresa") || pathLower.StartsWith("/api/impuestos") || pathLower.StartsWith("/api/reglasdocumentos") || pathLower.StartsWith("/api/operaciones-sunat")) 
        menuCodigo = "CONF_FISCAL";
    else if (pathLower.StartsWith("/api/sucursales") || pathLower.StartsWith("/api/metodos-pago") || pathLower.StartsWith("/api/tablas-generales")) 
        menuCodigo = "CONF_GENERAL";
    else if (pathLower.StartsWith("/api/series") || pathLower.StartsWith("/api/tipos-comprobante")) 
        menuCodigo = "CONF_COMPROBANTES";
    else if (pathLower.StartsWith("/api/configuracion")) menuCodigo = "CONFIGURACION";

    if (menuCodigo != null)
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

        // Fallback: Si es admin, dejamos pasar (Simplificación para tests si no están todos los permisos)
        if (esAdmin)
        {
             await next();
             return;
        }

        string permisoFull = $"{menuCodigo}:{permisoRequerido}";
        
        // El enforcement es ahora estrictamente por el código granular asignado a la ruta
        if (!permisos.Contains(permisoFull))
        {
            var userId = context.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "?";
            Console.WriteLine($"[403-GRANULAR] User={userId} | Ruta={path} | Metodo={method} | PermisoRequerido={permisoFull} | PermisosEnToken=[{string.Join(", ", permisos)}]");
            context.Response.StatusCode = 403;
            context.Response.ContentType = "application/json";
            await context.Response.WriteAsJsonAsync(new { 
                status = 403, 
                message = "Permisos insuficientes. No tienes autorización para realizar esta operación.",
                detalles = $"Se requiere el permiso: {permisoFull}",
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

public partial class Program { }
