# AGENTE-9 — Gateway.API.Tests (E2E)

## Contexto del proyecto

Eres un agente especializado en crear tests E2E para un API Gateway .NET 8.0. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\`

La carpeta `src/` contiene el código fuente (NO modificar).
La carpeta `tests/Nucleo.Tests.Shared/` ya existe con `AuthHelper` y `PostgreSqlFixture`.

## Tu misión

Crear `tests/Gateway.API.Tests/` con tests de autorización, propagación de headers y seguridad de rutas para el Gateway (YARP — Yet Another Reverse Proxy).

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/Gateway.API/Program.cs
src/Gateway.API/appsettings.json
src/Gateway.API/Gateway.API.csproj
```

## Arquitectura del Gateway

El Gateway usa **YARP** como reverse proxy. Sus responsabilidades son:
1. Verificar el JWT Bearer token
2. Rechazar requests sin token (401) o con token inválido (401)
3. Rechazar requests de usuarios sin el rol correcto (403)
4. Propagar headers `X-User-Id`, `X-User-Roles`, `X-User-Permisos` al microservicio destino

### Configuración JWT (del appsettings.json)
```json
{
  "Jwt": {
    "Issuer": "SistemaComercial",
    "Audience": "SistemaComercialAPI",
    "SecretKey": "SUPER_SECRET_KEY_PROVISIONAL_1234567890"
  }
}
```

### Reglas de autorización por ruta (leer Program.cs para confirmar)
| Ruta | Roles permitidos |
|------|-----------------|
| `/api/configuracion/**` | Solo ADMIN |
| `/api/identidad/**` | Solo ADMIN |
| `/api/contabilidad/**` | Solo ADMIN |
| `/api/catalogo` GET | Todos |
| `/api/catalogo` POST/PUT/DELETE | Solo ADMIN |
| `/api/ventas/**` | ADMIN, VENDEDOR |
| `/api/compras/**` | ADMIN |
| `/api/inventario/**` | ADMIN |

## Archivo .csproj a crear

`tests/Gateway.API.Tests/Gateway.API.Tests.csproj`:
```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <IsTestProject>true</IsTestProject>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.11.0" />
    <PackageReference Include="xunit" Version="2.9.0" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.8.2" />
    <PackageReference Include="FluentAssertions" Version="6.12.1" />
    <PackageReference Include="Moq" Version="4.20.72" />
    <PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="8.0.8" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\..\src\Gateway.API\Gateway.API.csproj" />
    <ProjectReference Include="..\Nucleo.Tests.Shared\Nucleo.Tests.Shared.csproj" />
  </ItemGroup>
</Project>
```

## Estrategia para los tests del Gateway

El Gateway redirige a microservicios reales. En tests, los microservicios no estarán corriendo. Por eso:

**Los tests del Gateway verifican la CAPA DE AUTORIZACIÓN, no la respuesta del microservicio.**

Cuando el Gateway no puede conectar al upstream, devuelve 502 (Bad Gateway). Esto es ESPERADO en tests. Lo que nos importa es:
- Sin token → 401 (antes de intentar conectar al upstream)
- Token inválido → 401
- Token con rol incorrecto → 403
- Token válido con rol correcto → 200, 201, o 502 (conectó al Gateway pero no al upstream)

**Fixture especial para Gateway:**
```csharp
public class GatewayWebApplicationFactory : WebApplicationFactory<Program>
{
    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureAppConfiguration((ctx, config) =>
        {
            // Sobrescribir URLs de microservicios con URLs inválidas para test
            config.AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["ReverseProxy:Clusters:catalogo:Destinations:default:Address"] = "http://localhost:1",
                ["ReverseProxy:Clusters:ventas:Destinations:default:Address"] = "http://localhost:1",
                // Agregar todos los clusters que encuentres en appsettings.json
            });
        });
    }
}
```

## Tests que debes implementar

### `Integration/Auth/AuthorizationTests.cs`

Usar `GatewayWebApplicationFactory`. Los resultados aceptables son:
- **Sin token**: 401 Unauthorized (SIEMPRE, antes del proxy)
- **Token inválido**: 401
- **Rol incorrecto**: 403 Forbidden
- **Token válido, rol correcto**: cualquier código que NO sea 401 o 403 (puede ser 200, 502, etc.)

```csharp
// Helper
private HttpClient CrearClienteSinToken() =>
    _factory.CreateClient();

private HttpClient CrearClienteConToken(string token)
{
    var client = _factory.CreateClient();
    client.DefaultRequestHeaders.Authorization =
        new AuthenticationHeaderValue("Bearer", token);
    return client;
}
```

1. `Request_SinToken_AEndpointProtegido_DebeRetornar401()`
   ```csharp
   var response = await CrearClienteSinToken().GetAsync("/api/catalogo");
   response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
   ```

2. `Request_ConTokenExpirado_DebeRetornar401()`
   ```csharp
   var token = AuthHelper.GenerarTokenExpirado();
   var response = await CrearClienteConToken(token).GetAsync("/api/catalogo");
   response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
   ```

3. `Request_ConTokenAdmin_AEndpointAdmin_DebeRetornarNoEsUnauthorizedNiForbidden()`
   ```csharp
   var token = AuthHelper.GenerarTokenAdmin();
   var response = await CrearClienteConToken(token).GetAsync("/api/configuracion/empresa");
   response.StatusCode.Should().NotBe(HttpStatusCode.Unauthorized);
   response.StatusCode.Should().NotBe(HttpStatusCode.Forbidden);
   ```

4. `Request_ConTokenVendedor_AEndpointAdmin_DebeRetornar403()`
   ```csharp
   var token = AuthHelper.GenerarTokenVendedor();
   var response = await CrearClienteConToken(token).GetAsync("/api/configuracion/empresa");
   response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
   ```

5. `Request_ConTokenVendedor_AEndpointVentas_DebeRetornarNoEsUnauthorizedNiForbidden()`
   ```csharp
   var token = AuthHelper.GenerarTokenVendedor();
   var response = await CrearClienteConToken(token).GetAsync("/api/ventas");
   response.StatusCode.Should().NotBe(HttpStatusCode.Unauthorized);
   response.StatusCode.Should().NotBe(HttpStatusCode.Forbidden);
   ```

### `Integration/Auth/SeguridadRutasTests.cs`

Tests parametrizados con `[Theory]` y `[InlineData]` para verificar reglas de acceso por ruta.

```csharp
[Theory]
[InlineData("/api/configuracion/empresa", "VENDEDOR", 403)]
[InlineData("/api/identidad/usuarios", "VENDEDOR", 403)]
[InlineData("/api/contabilidad", "VENDEDOR", 403)]
public async Task Ruta_ConRolSinAcceso_DebeRetornar403(
    string ruta, string rol, int codigoEsperado)
{
    // Arrange
    var token = AuthHelper.GenerarToken(99, rol, []);
    var client = CrearClienteConToken(token);

    // Act
    var response = await client.GetAsync(ruta);

    // Assert
    ((int)response.StatusCode).Should().Be(codigoEsperado);
}
```

Implementar estos tests:

1. `Ruta_Configuracion_ConVendedor_DebeRetornar403()`
2. `Ruta_Identidad_ConVendedor_DebeRetornar403()`
3. `Ruta_Contabilidad_ConVendedor_DebeRetornar403()`
4. `Ruta_Catalogo_GET_ConVendedor_DebePermitirAcceso()`
   - GET /api/catalogo con token vendedor → no es 401 ni 403
5. `Ruta_Catalogo_POST_ConVendedor_DebeRetornar403()`
   - POST /api/catalogo con token vendedor → 403

### `Integration/Auth/PropagacionHeadersTests.cs`

> **NOTA**: Verificar propagación de headers requiere interceptar la petición al upstream. Esto es difícil sin un servidor upstream real. Estos tests pueden implementarse como tests de **transformación del token**, verificando que el middleware del Gateway extrae y mapea correctamente los claims del JWT.

Alternativa viable: crear un handler de test que capture los headers recibidos:

```csharp
public class CapturadorHeadersHandler : DelegatingHandler
{
    public IHeaderDictionary? HeadersCapturados { get; private set; }

    protected override Task<HttpResponseMessage> SendAsync(
        HttpRequestMessage request, CancellationToken ct)
    {
        // Capturar headers de la petición
        HeadersCapturados = new HeaderDictionary();
        foreach (var header in request.Headers)
            HeadersCapturados[header.Key] = header.Value.ToArray();
        return Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK));
    }
}
```

1. `Request_ConToken_DebeExtraerUserId_DelJwt()`
   - Verificar que el claim `NameIdentifier` del JWT corresponde al userId esperado

2. `Request_ConToken_DebeExtraerRol_DelJwt()`
   - Verificar que el claim `Role` del JWT corresponde al rol esperado

### `Integration/Flujos/FlujoVentaCompletaTests.cs`

> **NOTA IMPORTANTE**: Los tests E2E de flujo completo requieren que TODOS los microservicios estén corriendo. En un entorno de CI sin los servicios levantados, estos tests se marcan como `[Trait("Category", "E2E")]` y se excluyen de la ejecución normal.

Implementar como tests marcados para ejecutar solo en entorno local:

```csharp
[Trait("Category", "E2E")]
public class FlujoVentaCompletaTests : IClassFixture<GatewayWebApplicationFactory>
{
    // Estos tests asumen que todos los microservicios están corriendo en sus puertos
}
```

1. `FlujoCompleto_Login_AbrirTurno_CrearVenta_CerrarTurno_DebeCompletarSinError()`
   - Pasos:
     1. POST /api/identidad/auth/login → obtener token
     2. POST /api/ventas/turnos/abrir → obtener turnoId
     3. POST /api/ventas → crear venta con turnoId
     4. POST /api/ventas/turnos/cerrar → cierre con monto físico
   - Assert: cada paso devuelve 2xx

2. `FlujoAnulacion_CrearVenta_AnularVenta_VerificarEstado()`
   - Crear venta → anular → verificar estado=61

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[Metodo]_[Condicion]_[ResultadoEsperado]`
- Usar `FluentAssertions` (`.Should()`)
- No agregar paquetes NuGet extra
- No modificar nada en `src/`
- Tests E2E marcar con `[Trait("Category", "E2E")]`
- Tests de integración marcar con `[Trait("Category", "Integration")]`
- Para correr solo unit tests: `dotnet test --filter "Category!=Integration&Category!=E2E"`

## Verificación final

```
dotnet build tests/Gateway.API.Tests/Gateway.API.Tests.csproj
dotnet test tests/Gateway.API.Tests/Gateway.API.Tests.csproj --filter "Category!=Integration&Category!=E2E"
```
