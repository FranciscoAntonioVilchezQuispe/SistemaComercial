# Plan de Implementación de Tests — Backend Sistema Comercial

**Fecha**: 2026-04-21 (actualizado)
**Autor**: Claude Sonnet 4.6
**Versión**: 2.0
**Modo de ejecución**: Multi-agente (Gemini Flash)

---

## IMPORTANTE PARA AGENTES

Este plan está diseñado para ejecución **multi-agente independiente**. Cada sección marcada con `[AGENTE-N]` es una unidad de trabajo autocontenida. Cada agente debe:

1. Leer **solo** su sección asignada.
2. Crear los archivos de test **exactamente** en las rutas indicadas.
3. No modificar archivos fuera de la carpeta `tests/`.
4. Usar los paquetes NuGet de la Sección 2 (sin agregar otros).
5. Seguir el patrón AAA (Arrange / Act / Assert) en todos los tests.
6. Nombrar tests con el formato: `[Metodo]_[Condicion]_[ResultadoEsperado]`

---

## 1. Mapa de Nuevos Servicios Implementados (v2.0)

Servicios nuevos desde la versión 1.0 del plan que deben ser cubiertos:

| Servicio | Qué se implementó | Dónde |
|----------|-------------------|-------|
| **Turnos y Cajas (Ventas)** | CRUD de Cajas + ciclo Abrir/Cerrar turno + Arqueo + Movimientos manuales | `Ventas.API.Application/Features/Turnos/TurnosManejadores.cs` |
| **Integración HTTP Ventas→Inventario** | `IInventarioServicio` con HttpClient para registrar salidas/anulaciones de venta y notas | `Ventas.API.Application/Integracion/InventarioServicio.cs` |
| **Integración HTTP Compras→Inventario** | `IInventarioServicio` con HttpClient para registrar entradas/anulaciones de compra y notas | `Compras.API.Application/Integracion/InventarioServicio.cs` |
| **Evento de Dominio VentaCreada** | `VentaCreadaEvento` (INotification) + `VentaCreadaIntegracionHandler` dispara actualización de stock | `Ventas.API.Application/Eventos/VentaCreadaEvento.cs` |
| **Gestión Granular de Roles (Identidad)** | Endpoints `/api/roles`, `POST /permisos`, `POST /acceso-granular` con RolMenu + RolMenuPermiso | `Identidad.API.Application/Features/Roles/` |
| **Reportes Ventas** | `GET /api/ventas/reportes/ranking-productos` y `/top-clientes` | `Ventas.API.API/Endpoints/ReportesEndpoints.cs` |
| **Reportes Compras** | `GET /api/compras/reportes/compras-proveedor` | `Compras.API.API/Endpoints/ReportesComprasEndpoints.cs` |

---

## 2. Stack de Testing (igual para todos los agentes)

```xml
<PackageReference Include="xunit" Version="2.9.0" />
<PackageReference Include="xunit.runner.visualstudio" Version="2.8.2" />
<PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.11.0" />
<PackageReference Include="Moq" Version="4.20.72" />
<PackageReference Include="FluentAssertions" Version="6.12.1" />
<PackageReference Include="Testcontainers.PostgreSql" Version="3.10.0" />
<PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="8.0.8" />
<PackageReference Include="Microsoft.EntityFrameworkCore.InMemory" Version="8.0.8" />
<PackageReference Include="Bogus" Version="35.6.1" />
<PackageReference Include="AutoFixture" Version="4.18.1" />
<PackageReference Include="AutoFixture.AutoMoq" Version="4.18.1" />
```

**Convención de nombre de tests**:
```
[Metodo]_[Condicion]_[ResultadoEsperado]

Ejemplos válidos:
  Handle_ConDatosValidos_DebeCrearProducto()
  Handle_ConUsuarioConTurnoAbierto_DebeLanzarException()
  GET_SinToken_DebeRetornar401()
  POST_ConArqueoNegativo_DebePermitirConObservacion()
```

**Patrón AAA obligatorio**:
```csharp
[Fact]
public async Task Handle_ConDatosValidos_DebeCrearTurno()
{
    // Arrange
    // ...

    // Act
    var resultado = await _handler.Handle(comando, CancellationToken.None);

    // Assert
    resultado.Should().NotBeNull();
    resultado.Estado.Should().Be("ABIERTO");
}
```

---

## 3. Estructura de Carpetas

```
D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\
├── src/                          (código fuente existente — NO modificar)
└── tests/                        ← CREAR ESTA CARPETA
    ├── Nucleo.Tests.Shared/       ← AGENTE-0 (base compartida)
    ├── Nucleo.Tests/              ← AGENTE-0
    ├── Identidad.API.Tests/       ← AGENTE-1
    ├── Configuracion.API.Tests/   ← AGENTE-2
    ├── Catalogo.API.Tests/        ← AGENTE-3
    ├── Clientes.API.Tests/        ← AGENTE-4
    ├── Inventario.API.Tests/      ← AGENTE-5
    ├── Compras.API.Tests/         ← AGENTE-6
    ├── Ventas.API.Tests/          ← AGENTE-7
    ├── Contabilidad.API.Tests/    ← AGENTE-8
    └── Gateway.API.Tests/         ← AGENTE-9
```

---

## 4. Orden de Ejecución de Agentes

Los agentes se ejecutan en este orden estricto (hay dependencias):

```
AGENTE-0  →  AGENTE-1  →  AGENTES 2,3,4 (paralelos)
                       →  AGENTE-5
                       →  AGENTES 6,7 (paralelos, dependen de 5)
                       →  AGENTES 8,9 (paralelos)
```

**Dependencias**:
- AGENTE-0 debe completarse antes que cualquier otro (provee fixtures compartidas).
- AGENTE-1 debe completarse antes de AGENTES 2–9 (provee AuthHelper con JWT real).
- AGENTE-5 debe completarse antes de AGENTES 6 y 7 (Inventario es núcleo de integraciones).

---

## AGENTE-0: Nucleo.Tests.Shared + Nucleo.Tests

**Carpeta objetivo**: `tests/Nucleo.Tests.Shared/` y `tests/Nucleo.Tests/`

**Archivos a crear**:

### `tests/Nucleo.Tests.Shared/Nucleo.Tests.Shared.csproj`
```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <IsPackable>false</IsPackable>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="xunit" Version="2.9.0" />
    <PackageReference Include="Moq" Version="4.20.72" />
    <PackageReference Include="FluentAssertions" Version="6.12.1" />
    <PackageReference Include="Testcontainers.PostgreSql" Version="3.10.0" />
    <PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="8.0.8" />
    <PackageReference Include="Microsoft.Extensions.Http" Version="8.0.0" />
    <PackageReference Include="Microsoft.IdentityModel.Tokens" Version="7.6.0" />
    <PackageReference Include="System.IdentityModel.Tokens.Jwt" Version="7.6.0" />
    <PackageReference Include="Bogus" Version="35.6.1" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\..\src\Nucleo\Nucleo.csproj" />
  </ItemGroup>
</Project>
```

### `tests/Nucleo.Tests.Shared/Fixtures/PostgreSqlFixture.cs`
```csharp
using Testcontainers.PostgreSql;
using Xunit;

namespace Nucleo.Tests.Shared.Fixtures;

public class PostgreSqlFixture : IAsyncLifetime
{
    private readonly PostgreSqlContainer _container = new PostgreSqlBuilder()
        .WithImage("postgres:15-alpine")
        .WithDatabase("sistema_comercial_test")
        .WithUsername("postgres")
        .WithPassword("test123")
        .Build();

    public string ConnectionString => _container.GetConnectionString();

    public Task InitializeAsync() => _container.StartAsync();
    public Task DisposeAsync() => _container.DisposeAsync().AsTask();
}
```

### `tests/Nucleo.Tests.Shared/Helpers/AuthHelper.cs`

> **Contexto**: El sistema usa JWT con Issuer="SistemaComercial", Audience="SistemaComercialAPI".
> El secreto de test debe ser el mismo que está en `src/Identidad.API/Identidad.API.API/appsettings.json`.
> Los claims propagados por el Gateway son: `X-User-Id`, `X-User-Roles`, `X-User-Permisos`.

```csharp
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Nucleo.Tests.Shared.Helpers;

public static class AuthHelper
{
    private const string SecretKey = "SUPER_SECRET_KEY_PROVISIONAL_1234567890";
    private const string Issuer = "SistemaComercial";
    private const string Audience = "SistemaComercialAPI";

    public static string GenerarTokenAdmin(long userId = 1) =>
        GenerarToken(userId, "ADMIN", ["ventas:crear", "ventas:ver", "compras:ver", "compras:crear", "catalogo:ver"]);

    public static string GenerarTokenVendedor(long userId = 2) =>
        GenerarToken(userId, "VENDEDOR", ["ventas:crear", "ventas:ver"]);

    public static string GenerarToken(long userId, string rol, string[] permisos)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, userId.ToString()),
            new(ClaimTypes.Role, rol),
            new("uid", userId.ToString()),
        };
        claims.AddRange(permisos.Select(p => new Claim("permiso", p)));

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(SecretKey));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: Issuer,
            audience: Audience,
            claims: claims,
            expires: DateTime.UtcNow.AddHours(1),
            signingCredentials: creds);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    public static string GenerarTokenExpirado(long userId = 99) =>
        GenerarTokenConExpiracion(userId, "ADMIN", [], DateTime.UtcNow.AddHours(-1));

    private static string GenerarTokenConExpiracion(long userId, string rol, string[] permisos, DateTime expira)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, userId.ToString()),
            new(ClaimTypes.Role, rol)
        };
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(SecretKey));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var token = new JwtSecurityToken(Issuer, Audience, claims, expires: expira, signingCredentials: creds);
        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
```

### `tests/Nucleo.Tests.Shared/Helpers/HttpClientExtensions.cs`
```csharp
using System.Net.Http.Headers;
using System.Net.Http.Json;

namespace Nucleo.Tests.Shared.Helpers;

public static class HttpClientExtensions
{
    public static HttpClient ConToken(this HttpClient client, string token)
    {
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        return client;
    }

    public static HttpClient ConHeadersGateway(this HttpClient client, long userId, string rol)
    {
        client.DefaultRequestHeaders.Add("X-User-Id", userId.ToString());
        client.DefaultRequestHeaders.Add("X-User-Roles", rol);
        return client;
    }

    public static async Task<T?> LeerComoAsync<T>(this HttpResponseMessage response)
        => await response.Content.ReadFromJsonAsync<T>();
}
```

### `tests/Nucleo.Tests/Nucleo.Tests.csproj`
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
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\..\src\Nucleo\Nucleo.csproj" />
    <ProjectReference Include="..\Nucleo.Tests.Shared\Nucleo.Tests.Shared.csproj" />
  </ItemGroup>
</Project>
```

### Tests que AGENTE-0 debe implementar

**`tests/Nucleo.Tests/Unit/Paginacion/PagedResponseTests.cs`**
- `Crear_ConTotalMayorQuePageSize_DebeCalcularTotalPaginasCorrectamente()`
- `Crear_ConPagina1_DebeIndicarQueNoHayPaginaAnterior()`
- `Crear_ConUltimaPagina_DebeIndicarQueNoHayPaginaSiguiente()`
- `Crear_ConTotal0_DebeRetornarCeroTotalPaginas()`

**`tests/Nucleo.Tests/Unit/Comportamientos/ComportamientoValidacionTests.cs`**
- `Handle_ConDatosValidos_DebeLlamarAlSiguienteHandler()`
- `Handle_ConDatosInvalidos_DebeLanzarValidationException()`
- `Handle_ConMultiplesErrores_DebeAcumularTodos()`

**`tests/Nucleo.Tests/Unit/Helpers/DateTimeHelperTests.cs`**
- `ObtenerAhoraLima_DebeRetornarHoraUTCMenos5()`

---

## AGENTE-1: Identidad.API.Tests

**Carpeta objetivo**: `tests/Identidad.API.Tests/`

**Archivos fuente de referencia** (solo leer, no modificar):
- `src/Identidad.API/Identidad.API.Application/Features/Auth/Login/LoginManejador.cs`
- `src/Identidad.API/Identidad.API.Application/Features/Auth/Refresh/RefreshTokenManejador.cs`
- `src/Identidad.API/Identidad.API.Application/Features/Roles/ActualizarAccesoRol/ActualizarAccesoRolCommand.cs`
- `src/Identidad.API/Identidad.API.Application/Features/Roles/ActualizarPermisosRol/ActualizarPermisosRolCommand.cs`
- `src/Identidad.API/Identidad.API.Application/Features/Usuarios/CrearUsuario/CrearUsuarioCommand.cs`
- `src/Identidad.API/Identidad.API.Infrastructure/Servicios/BCryptPasswordHasher.cs`
- `src/Identidad.API/Identidad.API.Infrastructure/Servicios/JwtTokenService.cs`
- `src/Identidad.API/Identidad.API.API/Endpoints/IdentidadEndpoints.cs`
- `src/Identidad.API/Identidad.API.API/Endpoints/AuthEndpoints.cs`

### `tests/Identidad.API.Tests/Identidad.API.Tests.csproj`
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
    <PackageReference Include="Testcontainers.PostgreSql" Version="3.10.0" />
    <PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="8.0.8" />
    <PackageReference Include="Bogus" Version="35.6.1" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\..\src\Identidad.API\Identidad.API.API\Identidad.API.API.csproj" />
    <ProjectReference Include="..\Nucleo.Tests.Shared\Nucleo.Tests.Shared.csproj" />
  </ItemGroup>
</Project>
```

### Tests que AGENTE-1 debe implementar

**`Unit/Servicios/BCryptPasswordHasherTests.cs`**
- `Hashear_ConPasswordValido_DebeRetornarHashDistintoAlTextoOriginal()`
- `Hashear_MismoPassword_DebeGenerarHashesDiferentes()`
- `Verificar_ConPasswordCorrecto_DebeRetornarTrue()`
- `Verificar_ConPasswordIncorrecto_DebeRetornarFalse()`
- `Verificar_ConHashVacio_DebeRetornarFalse()`

**`Unit/Servicios/JwtTokenServiceTests.cs`**
- `GenerarToken_ConUsuarioValido_DebeIncluirClaimUserId()`
- `GenerarToken_ConRolAdmin_DebeIncluirClaimRol()`
- `GenerarToken_DebeUsarIssuerYAudienceCorrectos()`
- `GenerarRefreshToken_DebeRetornarStringBase64NoVacio()`
- `GenerarRefreshToken_DosLlamadas_DebeRetornarValoresDiferentes()`

**`Unit/Comandos/LoginComandoHandlerTests.cs`**

> El LoginManejador: busca usuario por email, verifica password con BCrypt, genera JWT+RefreshToken.

- `Handle_ConCredencialesValidas_DebeRetornarTokenJwt()`
- `Handle_ConEmailInexistente_DebeLanzarAppException()`
- `Handle_ConPasswordIncorrecto_DebeLanzarAppException()`
- `Handle_ConUsuarioInactivo_DebeLanzarAppException()`
- `Handle_ConLoginExitoso_DebeGuardarRefreshTokenEnBD()`

**`Unit/Comandos/RefreshTokenHandlerTests.cs`**
- `Handle_ConRefreshTokenValido_DebeRetornarNuevoJwt()`
- `Handle_ConRefreshTokenExpirado_DebeLanzarAppException()`
- `Handle_ConRefreshTokenNoExistente_DebeLanzarAppException()`

**`Unit/Roles/ActualizarPermisosRolHandlerTests.cs`**

> El handler llama a `_repoRol.ObtenerPorIdAsync` y luego `SincronizarPermisosAsync`.

- `Handle_ConRolExistente_DebeLlamarSincronizarPermisos()`
- `Handle_ConRolInexistente_DebeRetornarError404()`
- `Handle_ConListaPermisoVacia_DebeVaciarPermisosDelRol()`

**`Unit/Roles/ActualizarAccesoRolHandlerTests.cs`**

> El handler gestiona RolMenu + RolMenuPermiso: elimina accesos viejos, agrega nuevos, sincroniza permisos granulares por menú.

- `Handle_ConRolInexistente_DebeRetornarError404()`
- `Handle_ConNuevoAcceso_DebeCrearRolMenu()`
- `Handle_ConAccesoEliminado_DebeEliminarRolMenuObsoleto()`
- `Handle_ConPermisosActualizados_DebeSincronizarRolMenuPermiso()`

**`Unit/Validadores/LoginComandoValidatorTests.cs`**
- `Validar_ConEmailVacio_DebeFallar()`
- `Validar_ConEmailFormatoInvalido_DebeFallar()`
- `Validar_ConPasswordVacio_DebeFallar()`
- `Validar_ConDatosCompletos_DebePasar()`

**`Integration/Endpoints/AuthEndpointTests.cs`**

> Usar `WebApplicationFactory<Program>` de Identidad.API. Arrancar con BD en memoria o SQLite para tests.

- `POST_Login_ConCredencialesValidas_DebeRetornar200ConToken()`
- `POST_Login_ConPasswordIncorrecto_DebeRetornar401()`
- `POST_Login_ConEmailInexistente_DebeRetornar400()`
- `POST_RefreshToken_ConTokenValido_DebeRetornarNuevoJwt()`

**`Integration/Endpoints/RolesEndpointTests.cs`**
- `GET_Roles_ConTokenAdmin_DebeRetornar200ConLista()`
- `POST_Roles_Permisos_ConRolValido_DebeActualizarPermisos()`
- `POST_Roles_AccesoGranular_ConMenusValidos_DebeActualizarAccesos()`
- `POST_Roles_AccesoGranular_ConRolInexistente_DebeRetornar404()`

---

## AGENTE-2: Configuracion.API.Tests

**Carpeta objetivo**: `tests/Configuracion.API.Tests/`

**Archivos fuente de referencia**:
- `src/Configuracion.API/Configuracion.API.API/Endpoints/EmpresaEndpoints.cs`
- `src/Configuracion.API/Configuracion.API.API/Endpoints/ImpuestoEndpoints.cs`
- `src/Configuracion.API/Configuracion.API.API/Endpoints/MatrizSunatEndpoints.cs`
- `src/Configuracion.API/Configuracion.API.API/Endpoints/TipoAfectacionIgvEndpoints.cs`
- `src/Configuracion.API/Configuracion.API.API/Endpoints/TipoTributoEndpoints.cs`
- `src/Configuracion.API/Configuracion.API.Application/DTOs/ConfiguracionDtos.cs`
- `src/Configuracion.API/Configuracion.API.Domain/Entidades/MatrizReglaSunat.cs`
- `src/Configuracion.API/Configuracion.API.Domain/Entidades/TipoAfectacionIgv.cs`

### Tests que AGENTE-2 debe implementar

**`Unit/Validadores/EmpresaValidatorTests.cs`**
- `Validar_ConRucDe11Digitos_DebePasar()`
- `Validar_ConRucMenorDe11Digitos_DebeFallar()`
- `Validar_ConRazonSocialVacia_DebeFallar()`
- `Validar_ConDireccionFiscalVacia_DebeFallar()`

**`Unit/Validadores/SerieComprobanteValidatorTests.cs`**

> Formato válido: `F001` (Factura), `B001` (Boleta), `FC01` (NC), `FD01` (ND).

- `Validar_ConSerieFormatoF001_DebePasar()`
- `Validar_ConSerieFormatoB001_DebePasar()`
- `Validar_ConSerieConMenos4Caracteres_DebeFallar()`
- `Validar_ConSerieSinPrefijoCorrecto_DebeFallar()`

**`Integration/Endpoints/EmpresaEndpointTests.cs`**
- `GET_Empresa_ConTokenAdmin_DebeRetornar200()`
- `PUT_Empresa_ConDatosValidos_DebeActualizar()`
- `PUT_Empresa_ConRucInvalido_DebeRetornar400()`

**`Integration/Endpoints/MatrizSunatEndpointTests.cs`**

> La matriz SUNAT mapea tipo comprobante + tipo operación → reglas de emisión.

- `GET_MatrizSunat_DebeRetornarListaCompleta()`
- `GET_MatrizSunat_FiltradoPorTipoComprobante_DebeRetornarSubconjunto()`

**`Integration/Endpoints/TipoAfectacionIgvEndpointTests.cs`**

> Catálogo 07 SUNAT: 10=Gravado, 20=Exonerado, 30=Inafecto, etc.

- `GET_TipoAfectacionIgv_DebeRetornarCatalogo07Sunat()`
- `GET_TipoAfectacionIgv_DebeIncluirCodigo10GravadoOperacionOnerosa()`

---

## AGENTE-3: Catalogo.API.Tests

**Carpeta objetivo**: `tests/Catalogo.API.Tests/`

**Archivos fuente de referencia**:
- `src/Catalogo.API/Catalogo.Application/Manejadores/CrearProductoManejador.cs`
- `src/Catalogo.API/Catalogo.Application/Manejadores/ActualizarProductoManejador.cs`
- `src/Catalogo.API/Catalogo.Application/Comandos/CrearProductoComando.cs`
- `src/Catalogo.API/Catalogo.Application/Comandos/ActualizarProductoComando.cs`
- `src/Catalogo.API/Catalogo.Application/DTOs/ActualizarProductoRequest.cs`
- `src/Catalogo.API/Catalogo.Domain/Entidades/Producto.cs`
- `src/Catalogo.API/Catalogo.API/Endpoints/ProductoEndpoints.cs`
- `src/Catalogo.API/Catalogo.Infrastructure/Repositorios/ProductoRepositorio.cs`

### Tests que AGENTE-3 debe implementar

**`Unit/Comandos/CrearProductoManejadorTests.cs`**
- `Handle_ConDatosCompletos_DebeCrearProductoConId()`
- `Handle_ConCodigoDuplicado_DebeLanzarAppException()`
- `Handle_ConCategoriaInexistente_DebeLanzarAppException()`
- `Handle_ConMarcaInexistente_DebeLanzarAppException()`
- `Handle_ConMetodoValuacionPP_DebeAsignarCorrecto()`

**`Unit/Comandos/ActualizarProductoManejadorTests.cs`**
- `Handle_ConProductoExistente_DebeActualizarCampos()`
- `Handle_ConProductoInexistente_DebeLanzarAppException()`
- `Handle_ConPrecioNegativo_DebeLanzarValidationException()`

**`Unit/Validadores/CrearProductoComandoValidatorTests.cs`**
- `Validar_ConNombreVacio_DebeFallar()`
- `Validar_ConPrecioNegativo_DebeFallar()`
- `Validar_ConIdCategoria0_DebeFallar()`
- `Validar_ConMetodoValuacionInvalido_DebeFallar()` — valores válidos: "PP", "PE", "UE"
- `Validar_ConDatosCompletos_DebePasar()`

**`Integration/Repositorios/ProductoRepositorioTests.cs`**

> Usar TestContainers (PostgreSqlFixture). Aplicar migrations antes de correr tests.

- `ObtenerPaginadoAsync_ConPagina1Size10_DebeRetornar10Items()`
- `ObtenerPorIdAsync_ConIdExistente_DebeRetornarProductoConRelaciones()`
- `CrearAsync_ConProductoValido_DebeGuardarConId()`
- `EliminarAsync_ConProductoExistente_DebeSoftDeleteActivadoFalse()`

**`Integration/Endpoints/ProductosEndpointTests.cs`**
- `GET_Productos_DebeRetornarListaPaginada()`
- `GET_Productos_PorId_ConIdValido_DebeRetornarDetalle()`
- `GET_Productos_PorId_ConIdInexistente_DebeRetornar404()`
- `POST_Productos_ConDatosValidos_DebeRetornar201()`
- `POST_Productos_ConNombreVacio_DebeRetornar400()`
- `PUT_Productos_ConDatosValidos_DebeActualizar()`
- `DELETE_Productos_ConIdValido_DebeDesactivar()`

**`Integration/Endpoints/CategoriasEndpointTests.cs`**
- `GET_Categorias_DebeRetornarLista()`
- `POST_Categorias_ConNombreValido_DebeCrear()`

---

## AGENTE-4: Clientes.API.Tests

**Carpeta objetivo**: `tests/Clientes.API.Tests/`

**Archivos fuente de referencia**:
- `src/Clientes.API/Clientes.API.API/Endpoints/ClienteEndpoints.cs`
- `src/Clientes.API/Clientes.API.Infrastructure/Repositorios/ClienteRepositorio.cs`
- `src/Clientes.API/Clientes.API.Domain/DTOs/ClienteDetalleDto.cs`
- `src/Clientes.API/Clientes.API.Domain/DTOs/ClienteListDto.cs`

### Tests que AGENTE-4 debe implementar

**`Unit/Comandos/CrearClienteHandlerTests.cs`**
- `Handle_ConDniValido_DebeCrearCliente()`
- `Handle_ConRucValido_DebeCrearCliente()`
- `Handle_ConDocumentoDuplicado_DebeLanzarException()`

**`Unit/Validadores/ClienteValidatorTests.cs`**

> Reglas peruanas: DNI = 8 dígitos, RUC = 11 dígitos con algoritmo verificador.

- `Validar_ConDni8Digitos_DebePasar()`
- `Validar_ConDni7Digitos_DebeFallar()`
- `Validar_ConRuc11Digitos_DebePasar()`
- `Validar_ConRuc10Digitos_DebeFallar()`
- `Validar_ConNombreVacio_DebeFallar()`

**`Integration/Endpoints/ClientesEndpointTests.cs`**
- `GET_Clientes_ConTokenAdmin_DebeRetornarListaPaginada()`
- `GET_Clientes_PorId_ConIdValido_DebeRetornarDetalle()`
- `POST_Clientes_ConDniValido_DebeCrear()`
- `POST_Clientes_ConRucInvalido_DebeRetornar400()`
- `PUT_Clientes_ConDatosValidos_DebeActualizar()`
- `DELETE_Clientes_ConIdValido_DebeSoftDelete()`

---

## AGENTE-5: Inventario.API.Tests

**Carpeta objetivo**: `tests/Inventario.API.Tests/`

> **PRIORIDAD MÁXIMA**: Este es el microservicio más complejo. El Kardex maneja valuación de inventario (PP=Promedio Ponderado, PE=FIFO, UE=LIFO). AGENTES-6 y AGENTE-7 dependen de que los mocks de `IInventarioServicio` sean correctos.

**Archivos fuente de referencia**:
- `src/Inventario.API/Inventario.API.Application/Servicios/KardexService.cs`
- `src/Inventario.API/Inventario.API.Application/Servicios/KardexRecalculoService.cs`
- `src/Inventario.API/Inventario.API.Application/Manejadores/CrearMovimientoInventarioManejador.cs`
- `src/Inventario.API/Inventario.API.Application/Manejadores/Kardex/AbrirPeriodoManejador.cs`
- `src/Inventario.API/Inventario.API.Application/Manejadores/Kardex/CerrarPeriodoManejador.cs`
- `src/Inventario.API/Inventario.API.Application/Manejadores/Kardex/GenerarReporteKardexManejador.cs`
- `src/Inventario.API/Inventario.API.Application/Interfaces/IInventarioDbContext.cs`
- `src/Inventario.API/Inventario.API.Domain/Entidades/Kardex/KardexMovimiento.cs`
- `src/Inventario.API/Inventario.API.Domain/Interfaces/IKardexMovimientoRepositorio.cs`
- `src/Inventario.API/Inventario.API.Domain/Interfaces/IStockRepositorio.cs`

### Tests que AGENTE-5 debe implementar

**`Unit/Servicios/KardexServiceTests.cs`**

> Prueba el cálculo del costo según método de valuación.

```
ESCENARIO PP (Promedio Ponderado):
  Entrada:  100 unidades a $10.00  → Costo promedio: $10.00
  Entrada:   50 unidades a $14.00  → Costo promedio: $11.33
  Salida:    80 unidades           → Costo: 80 × $11.33 = $906.67
  Saldo:     70 unidades a $11.33
```

- `CalcularCostoPP_ConUnaEntrada_DebeRetornarMismoCosto()`
- `CalcularCostoPP_ConDosEntradas_DebePromediarPonderado()`
- `RegistrarSalida_ConStockSuficiente_DebeReducirSaldo()`
- `RegistrarSalida_ConStockInsuficiente_DebeLanzarException()`
- `RegistrarEntrada_DebeActualizarCostoPromedioYSaldo()`

**`Unit/Servicios/KardexRecalculoServiceTests.cs`**

> El recálculo reordena todos los movimientos cronológicamente y recalcula costos/saldos.

- `Recalcular_ConMovimientosDesordenados_DebeReordenarCronologicamente()`
- `Recalcular_DespuesDeEliminarEntrada_DebeAjustarCostoPromedio()`
- `Recalcular_ConPeriodoCerrado_DebeLanzarException()`

**`Unit/Comandos/CrearMovimientoInventarioHandlerTests.cs`**
- `Handle_ConTipoIngreso_DebeAumentarStock()`
- `Handle_ConTipoSalida_DebeDisminuirStock()`
- `Handle_ConSalidaYStockInsuficiente_DebeLanzarException()`
- `Handle_ConAlmacenInexistente_DebeLanzarException()`
- `Handle_ConProductoInexistente_DebeLanzarException()`

**`Unit/Comandos/AbrirCerrarPeriodoHandlerTests.cs`**
- `AbrirPeriodo_ConFechaValida_DebeCrearPeriodoAbierto()`
- `AbrirPeriodo_ConPeriodoYaAbierto_DebeLanzarException()`
- `CerrarPeriodo_ConPeriodoAbierto_DebeCambiarEstado()`
- `CerrarPeriodo_ConMovimientosPendientes_DebeLanzarException()`

**`Integration/Repositorios/StockRepositorioTests.cs`**
- `ObtenerStockActual_ConProductoYAlmacen_DebeRetornarStockCorrecto()`
- `ActualizarStock_ConCantidadPositiva_DebeAumentar()`
- `ActualizarStock_ConCantidadNegativa_DebeDisminuir()`

**`Integration/Repositorios/KardexMovimientoRepositorioTests.cs`**
- `ObtenerPorPeriodo_ConFechasFiltradas_DebeRetornarSoloMovimientosEnRango()`
- `ObtenerUltimoMovimiento_ConProductoYAlmacen_DebeRetornarElMasReciente()`

**`Integration/Endpoints/MovimientosEndpointTests.cs`**
- `POST_Movimientos_ConTipoIngreso_DebeRegistrar()`
- `POST_Movimientos_ConTipoSalida_DebeRegistrar()`
- `POST_Movimientos_ConStockInsuficiente_DebeRetornar400()`
- `GET_Stock_PorAlmacen_DebeRetornarStockActual()`

**`Integration/Endpoints/KardexEndpointTests.cs`**
- `GET_Kardex_ConPeriodoValido_DebeRetornarReporte()`
- `POST_AbrirPeriodo_ConFechaValida_DebeRetornar200()`
- `POST_CerrarPeriodo_ConPeriodoAbierto_DebeRetornar200()`

---

## AGENTE-6: Compras.API.Tests

**Carpeta objetivo**: `tests/Compras.API.Tests/`

**Archivos fuente de referencia**:
- `src/Compras.API/Compras.API.Application/Manejadores/CrearCompraManejador.cs`
- `src/Compras.API/Compras.API.Application/Manejadores/AnularCompraManejador.cs`
- `src/Compras.API/Compras.API.Application/Manejadores/CrearNotaCreditoCompraManejador.cs`
- `src/Compras.API/Compras.API.Application/Manejadores/CrearNotaDebitoCompraManejador.cs`
- `src/Compras.API/Compras.API.Application/Interfaces/IInventarioServicio.cs`
- `src/Compras.API/Compras.API.Application/Integracion/InventarioServicio.cs`
- `src/Compras.API/Compras.API.Application/Validadores/CrearCompraValidator.cs`
- `src/Compras.API/Compras.API.API/Endpoints/CompraEndpoints.cs`
- `src/Compras.API/Compras.API.API/Endpoints/ReportesComprasEndpoints.cs`
- `src/Compras.API/Compras.API.Domain/Entidades/Compra.cs`

### Tests que AGENTE-6 debe implementar

**`Unit/Comandos/CrearCompraHandlerTests.cs`**

> El handler crea la compra, calcula totales (subtotal + IGV) y luego llama a `IInventarioServicio.RegistrarEntradaCompraAsync` por cada línea con el tipo `ING_COM (id=19)`.

- `Handle_ConDetallesValidos_DebeCrearCompraConId()`
- `Handle_ConUnDetalle_DebeCalcularIgvCorrecto()` — Subtotal=100, IGV=18%, Total=118
- `Handle_ConMultiplesDetalles_DebeSumarTotalesCorrectamente()`
- `Handle_ConCompraCreada_DebeLlamarInventarioUnaVezPorLinea()`
- `Handle_ConInventarioFallando_DebeGuardarCompraIgual()` — el servicio de inventario falla silenciosamente

**`Unit/Comandos/AnularCompraHandlerTests.cs`**

> Anulación: cambia `id_estado = 61`, llama `IInventarioServicio.EliminarMovimientosCompraAsync`.

- `Handle_ConCompraRegistrada_DebeCambiarEstadoA61()`
- `Handle_ConCompraAnulada_DebeLlamarEliminarMovimientosInventario()`
- `Handle_ConCompraYaAnulada_DebeLanzarException()`
- `Handle_ConCompraCompletada_DebeLanzarException()`

**`Unit/Comandos/CrearNotaCreditoCompraHandlerTests.cs`**

> NC Compra: referencia a compra origen, llama `IInventarioServicio.RegistrarSalidaNotaCreditoAsync` con tipo `DevolucionCompra (id=24)`.

- `Handle_ConCompraReferenciada_DebeCrearNotaCredito()`
- `Handle_ConMontoMayorQueCompra_DebeLanzarException()`
- `Handle_ConNotaCreada_DebeLlamarInventarioConTipo24()`

**`Unit/Integracion/InventarioServicioTests.cs`**

> Prueba el cliente HTTP que llama a Inventario.API. Usar `HttpMessageHandler` mockeado.

- `RegistrarEntradaCompraAsync_ConRespuesta200_DebeRetornarTrue()`
- `RegistrarEntradaCompraAsync_ConRespuesta500_DebeRetornarFalse()`
- `RegistrarEntradaCompraAsync_ConExcepcionDeRed_DebeRetornarFalseYLoguear()`
- `EliminarMovimientosCompraAsync_ConRespuesta200_DebeRetornarTrue()`
- `RegistrarSalidaNotaCreditoAsync_DebeEnviarTipoMovimiento24()`
- `RegistrarEntradaNotaDebitoAsync_DebeEnviarTipoMovimiento26()`

**`Unit/Validadores/CrearCompraValidatorTests.cs`**
- `Validar_SinDetalles_DebeFallar()`
- `Validar_ConCantidadCero_DebeFallar()`
- `Validar_ConPrecioUnitarioNegativo_DebeFallar()`
- `Validar_SinProveedor_DebeFallar()`
- `Validar_ConDatosCompletos_DebePasar()`

**`Integration/Endpoints/ComprasEndpointTests.cs`**
- `GET_Compras_DebeRetornarListaPaginada()`
- `GET_Compras_PorId_ConIdValido_DebeRetornarDetalle()`
- `POST_Compras_ConDatosValidos_DebeRetornar201()`
- `POST_Compras_SinDetalles_DebeRetornar400()`
- `PUT_Compras_Anular_ConMotivoValido_DebeAnular()`

**`Integration/Endpoints/ReportesComprasEndpointTests.cs`**

> Endpoint: `GET /api/compras/reportes/compras-proveedor?fechaInicio=&fechaFin=&top=10`

- `GET_ComprasProveedor_SinFiltroFecha_UsaUltimos30Dias()`
- `GET_ComprasProveedor_ConFiltroFecha_DebeRetornarSoloPeriodo()`
- `GET_ComprasProveedor_ConTop5_DebeRetornarMaximo5()`

---

## AGENTE-7: Ventas.API.Tests

**Carpeta objetivo**: `tests/Ventas.API.Tests/`

> **SECCIÓN MÁS GRANDE**: Ventas tiene el mayor número de tests por incluir el sistema de Turnos/Cajas, el evento de dominio VentaCreada, y la integración HTTP con Inventario.

**Archivos fuente de referencia**:
- `src/Ventas.API/Ventas.API.Application/Manejadores/CrearVentaManejador.cs`
- `src/Ventas.API/Ventas.API.Application/Manejadores/AnularVentaManejador.cs`
- `src/Ventas.API/Ventas.API.Application/Manejadores/CrearNotaCreditoManejador.cs`
- `src/Ventas.API/Ventas.API.Application/Manejadores/CrearNotaDebitoManejador.cs`
- `src/Ventas.API/Ventas.API.Application/Manejadores/VentaCreadaIntegracionHandler.cs`
- `src/Ventas.API/Ventas.API.Application/Eventos/VentaCreadaEvento.cs`
- `src/Ventas.API/Ventas.API.Application/Features/Turnos/TurnosManejadores.cs`
- `src/Ventas.API/Ventas.API.Application/Features/Turnos/TurnosRequests.cs`
- `src/Ventas.API/Ventas.API.Application/Interfaces/IInventarioServicio.cs`
- `src/Ventas.API/Ventas.API.Application/Integracion/InventarioServicio.cs`
- `src/Ventas.API/Ventas.API.API/Endpoints/VentaEndpoints.cs`
- `src/Ventas.API/Ventas.API.API/Endpoints/TurnosEndpoints.cs`
- `src/Ventas.API/Ventas.API.API/Endpoints/CajaEndpoints.cs`
- `src/Ventas.API/Ventas.API.API/Endpoints/ReportesEndpoints.cs`

### Tests que AGENTE-7 debe implementar

#### Subgrupo A: Ventas principales

**`Unit/Comandos/CrearVentaHandlerTests.cs`**

> El handler: crea la venta, calcula IGV según tipo afectación, registra pagos, luego publica `VentaCreadaEvento` via MediatR.Publish para que el handler de integración actualice inventario.

- `Handle_ConClienteYDetalles_DebeCrearVentaConId()`
- `Handle_ConAfectacionGravada_DebeCalcularIgv18Porciento()`
- `Handle_ConAfectacionExonerada_DebeCalcularIgvCero()`
- `Handle_ConPagoEfectivo_DebeRegistrarPago()`
- `Handle_AlCrearVenta_DebePublicarVentaCreadaEvento()`
- `Handle_ConVentaCreada_DebeAsignarNumeroCorrelativo()`

**`Unit/Comandos/AnularVentaHandlerTests.cs`**

> Anulación: cambia `id_estado = 61`, llama `IInventarioServicio.AnularMovimientosVentaAsync`.

- `Handle_ConVentaRegistrada_DebeCambiarEstadoA61()`
- `Handle_ConVentaAnulada_DebeLlamarAnularMovimientosInventario()`
- `Handle_ConVentaYaAnulada_DebeLanzarException()`

**`Unit/Eventos/VentaCreadaIntegracionHandlerTests.cs`**

> El handler: itera los items del evento y llama `IInventarioServicio.RegistrarSalidaVentaAsync` por cada uno con tipo `SAL_VEN (id=20)`.

- `Handle_ConVentaCreada_DebeLlamarRegistrarSalidaPorCadaItem()`
- `Handle_ConInventarioRetornandoFalse_DebeLoguearWarningYContinuar()`
- `Handle_ConInventarioLanzandoException_DebeLoguearErrorYContinuar()`
- `Handle_ConVentaDe3Items_DebeLlamar3VecesInventario()`

**`Unit/Integracion/InventarioServicioTests.cs`** (Ventas)

> Igual que AGENTE-6 pero para los métodos de Ventas: RegistrarSalidaVenta, AnularMovimientosVenta, RegistrarEntradaNotaCredito, RegistrarSalidaNotaDebito.

- `RegistrarSalidaVentaAsync_ConRespuesta200_DebeRetornarTrue()`
- `RegistrarSalidaVentaAsync_ConRespuesta500_DebeRetornarFalseYLoguear()`
- `RegistrarSalidaVentaAsync_ConExcepcionRed_DebeRetornarFalse()`
- `AnularMovimientosVentaAsync_ConRespuesta200_DebeRetornarTrue()`
- `RegistrarEntradaNotaCreditoAsync_DebeEnviarTipoMovimiento25()`
- `RegistrarSalidaNotaDebitoAsync_DebeEnviarTipoMovimiento27()`

#### Subgrupo B: Sistema de Turnos

**`Unit/Turnos/AbrirTurnoHandlerTests.cs`**

> El handler: verifica que el usuario no tenga turno abierto, crea `TurnoVendedor` con estado="ABIERTO".

- `Handle_ConUsuarioSinTurnoAbierto_DebeCrearTurnoAbierto()`
- `Handle_ConUsuarioConTurnoYaAbierto_DebeLanzarException()`
- `Handle_ConCajaYMontoApertura_DebeAsignarALTurno()`

**`Unit/Turnos/CerrarTurnoHandlerTests.cs`**

> El handler: carga el turno con ventas y pagos, calcula totales por método de pago, calcula diferencia de arqueo (MontoFísicoContado - MontoEsperado), crea `CierreTurno`.

```
ESCENARIO DE ARQUEO:
  MontoApertura:          S/ 200.00
  Ventas en efectivo:     S/ 800.00
  Ingresos manuales:      S/ 100.00
  Egresos manuales:       S/  50.00
  ─────────────────────────────────
  MontoEsperado:          S/ 1,050.00
  MontoFísicoContado:     S/ 1,020.00
  DiferenciaArqueo:       S/   -30.00 (faltante)
```

- `Handle_ConTurnoAbierto_DebeCerrarTurnoConEstadoCerrado()`
- `Handle_ConVentasEfectivo_DebeCalcularMontoEsperadoCorrectamente()`
- `Handle_ConMovimientosManualesIngreso_DebeAgregarAlMontoEsperado()`
- `Handle_ConMovimientosManualesEgreso_DebeRestarDelMontoEsperado()`
- `Handle_ConArqueoCorrecto_DebeDiferenciaArqueoEnCero()`
- `Handle_ConArqueoConFaltante_DebeDiferenciaArqueoNegativa()`
- `Handle_ConVentasAnuladas_DebeExcluirlas_DelCalculoTotales()` — excluir id_estado 61, 64, 65
- `Handle_ConTurnoCerrado_DebeLanzarException()`
- `Handle_ConTurnoDeOtroUsuario_DebeLanzarException()`

**`Unit/Turnos/ObtenerResumenPrevioCierreHandlerTests.cs`**

> El handler calcula el resumen sin cerrar el turno: igual que CerrarTurno pero sin commit.

- `Handle_ConTurnoAbierto_DebeRetornarResumenConTotales()`
- `Handle_ConPagosPorMetodo_DebeDesglosarCorrectamente()`
- `Handle_ConTurnoDeOtroUsuario_DebeLanzarException()`

**`Unit/Turnos/ObtenerHistorialTurnosHandlerTests.cs`**

> El handler usa Dapper con `COUNT(*) OVER()` para paginación.

- `Handle_ConFiltroEstadoAbierto_DebeRetornarSoloAbiertos()`
- `Handle_ConFiltroCaja_DebeRetornarSoloDeCaja()`
- `Handle_ConFiltroFecha_DebeRetornarEnRango()`
- `Handle_ConPaginacion_DebeRetornarPagedResponse()`

**`Unit/Turnos/RegistrarMovimientoCajaHandlerTests.cs`**
- `Handle_ConMontoPositivo_DebeRegistrarIngreso()`
- `Handle_ConMontoNegativo_DebeRegistrarEgreso()`
- `Handle_ConMontoCero_DebeLanzarException()`

#### Subgrupo C: CRUD de Cajas

**`Unit/Cajas/CrearActualizarCajaHandlerTests.cs`**
- `CrearCaja_ConDatosValidos_DebeCrearConEstado60()`
- `ActualizarCaja_ConCajaExistente_DebeActualizarNombreYAlmacen()`
- `ActualizarCaja_ConCajaInexistente_DebeRetornarNull()`
- `CambiarEstado_ConActivadoFalse_DebeDesactivarCaja()`

#### Subgrupo D: Endpoints de integración

**`Integration/Endpoints/TurnosEndpointTests.cs`**
- `POST_Turnos_Abrir_ConTokenVendedor_DebeRetornar200ConTurnoAbierto()`
- `POST_Turnos_Abrir_ConTurnoYaAbierto_DebeRetornar400()`
- `POST_Turnos_Cerrar_ConMontoFisico_DebeRetornar200ConCierreTurno()`
- `GET_Turnos_Actual_ConTokenVendedor_DebeRetornarTurnoAbierto()`
- `GET_Turnos_Actual_SinTurnoAbierto_DebeRetornar404()`
- `GET_Turnos_ResumenPrevio_DebeRetornarTotalesPorMetodoPago()`
- `GET_Turnos_Historial_ConFiltros_DebeRetornarPaginado()`

**`Integration/Endpoints/CajaEndpointTests.cs`**
- `GET_Cajas_DebeRetornarTodasLasCajas()`
- `GET_Cajas_PorId_ConIdValido_DebeRetornarDetalle()`
- `POST_Cajas_ConDatosValidos_DebeCrear()`
- `PUT_Cajas_ConDatosValidos_DebeActualizar()`
- `PATCH_Cajas_Estado_DebeActivarDesactivar()`
- `POST_Cajas_Movimientos_ConMontoPositivo_DebeRegistrar()`
- `GET_Cajas_Movimientos_ConTurnoId_DebeRetornarMovimientos()`

**`Integration/Endpoints/VentasEndpointTests.cs`**
- `GET_Ventas_DebeRetornarListaPaginada()`
- `POST_Ventas_Factura_ConClienteRuc_DebeRetornar201()`
- `POST_Ventas_Boleta_ConClienteDni_DebeRetornar201()`
- `POST_Ventas_SinCliente_DebeRetornar400()`
- `PUT_Ventas_Anular_ConMotivoValido_DebeAnular()`

**`Integration/Endpoints/ReportesVentasEndpointTests.cs`**

> Endpoint: `GET /api/ventas/reportes/ranking-productos?fechaInicio=&fechaFin=&top=10`

- `GET_RankingProductos_SinFiltros_UsaUltimos30Dias()`
- `GET_RankingProductos_ConTop5_DebeRetornarMaximo5()`
- `GET_TopClientes_SinFiltros_DebeRetornarLista()`
- `GET_TopClientes_ConFechas_DebeRetornarEnRango()`

---

## AGENTE-8: Contabilidad.API.Tests

**Carpeta objetivo**: `tests/Contabilidad.API.Tests/`

**Archivos fuente de referencia**:
- `src/Contabilidad.API/Contabilidad.API.Infrastructure/Datos/ContabilidadDbContext.cs`

### Tests que AGENTE-8 debe implementar

**`Unit/Domain/AsientoContableTests.cs`**
- `Crear_ConLineasBalanceadas_DebeCalcularDebito0YCredito0()`
- `Crear_SinBalanceo_DebeFallarValidacion()`
- `Crear_ConMenos2Lineas_DebeFallarValidacion()`

**`Integration/Endpoints/ContabilidadEndpointTests.cs`**
- `GET_Asientos_ConTokenAdmin_DebeRetornarListaPaginada()`
- `POST_Asientos_ConLineasBalanceadas_DebeCrear()`
- `POST_Asientos_DesbalanceadoDebeRetornar400()`
- `GET_PlanCuentas_DebeRetornarArbol()`

---

## AGENTE-9: Gateway.API.Tests (E2E)

**Carpeta objetivo**: `tests/Gateway.API.Tests/`

**Archivos fuente de referencia**:
- `src/Gateway.API/Program.cs`
- `src/Gateway.API/appsettings.json`

> El Gateway (YARP) enruta, verifica JWT y propaga headers `X-User-Id`, `X-User-Roles`, `X-User-Permisos`.

### Tests que AGENTE-9 debe implementar

**`Integration/Auth/AuthorizationTests.cs`**
- `Request_SinToken_AEndpointProtegido_DebeRetornar401()`
- `Request_ConTokenExpirado_DebeRetornar401()`
- `Request_ConTokenAdmin_AEndpointAdmin_DebeRetornar200()`
- `Request_ConTokenVendedor_AEndpointAdmin_DebeRetornar403()`
- `Request_ConTokenVendedor_AEndpointVentas_DebeRetornar200()`

**`Integration/Auth/PropagacionHeadersTests.cs`**

> Verificar que el Gateway propagué correctamente los headers al microservicio destino.

- `Request_ConToken_DebePropagarXUserId_AlMicroservicio()`
- `Request_ConToken_DebePropagarXUserRoles_AlMicroservicio()`

**`Integration/Auth/SeguridadRutasTests.cs`**
- `Ruta_Configuracion_SoloAccesible_PorAdmin()`
- `Ruta_Identidad_SoloAccesible_PorAdmin()`
- `Ruta_Catalogo_GET_AccesiblePorTodos()`
- `Ruta_Catalogo_POST_SoloAdmin()`

**`Integration/Flujos/FlujoVentaCompletaTests.cs`**

> Flujo E2E: Login → Abrir Turno → Crear Venta → Verificar Stock Actualizado → Cerrar Turno

- `FlujoCompleto_Login_AbrirTurno_CrearVenta_CerrarTurno_DebeCompletarSinError()`
- `FlujoAnulacion_CrearVenta_AnularVenta_VerificarInventarioRevertido()`

---

## 5. Consideraciones Especiales para Gemini Flash

### 5.1 Mock de IInventarioServicio (patrón estándar)

Todos los agentes que prueben handlers que dependen de `IInventarioServicio` deben usar este patrón:

```csharp
// En Ventas.API.Tests y Compras.API.Tests
var inventarioMock = new Mock<IInventarioServicio>();

// Simular éxito (default)
inventarioMock
    .Setup(s => s.RegistrarSalidaVentaAsync(
        It.IsAny<long>(), It.IsAny<long>(), It.IsAny<decimal>(),
        It.IsAny<long>(), It.IsAny<long>(), It.IsAny<string>(),
        It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<string>()))
    .ReturnsAsync(true);

// Verificar que se llamó exactamente 1 vez por ítem
inventarioMock.Verify(
    s => s.RegistrarSalidaVentaAsync(
        It.IsAny<long>(), It.IsAny<long>(), It.IsAny<decimal>(),
        It.IsAny<long>(), It.IsAny<long>(), It.IsAny<string>(),
        It.IsAny<string>(), It.IsAny<DateTime?>(), It.IsAny<string>()),
    Times.Once);
```

### 5.2 Mock de HttpMessageHandler para tests de InventarioServicio

```csharp
// Para probar InventarioServicio.cs (que usa HttpClient)
var handlerMock = new Mock<HttpMessageHandler>();
handlerMock
    .Protected()
    .Setup<Task<HttpResponseMessage>>(
        "SendAsync",
        ItExpr.IsAny<HttpRequestMessage>(),
        ItExpr.IsAny<CancellationToken>())
    .ReturnsAsync(new HttpResponseMessage(HttpStatusCode.OK));

var httpClient = new HttpClient(handlerMock.Object)
{
    BaseAddress = new Uri("http://gateway-test/")
};
var servicio = new InventarioServicio(httpClient, Mock.Of<ILogger<InventarioServicio>>());
```

### 5.3 Test de Diferencia de Arqueo (Cierre de Turno)

```csharp
[Fact]
public async Task Handle_ConArqueoCorrecto_DebeDiferenciaArqueoEnCero()
{
    // Arrange
    decimal montoApertura = 200m;
    decimal ventasEfectivo = 800m;
    decimal ingresosManual = 100m;
    decimal egresosManual = 50m;
    decimal montoEsperado = montoApertura + ventasEfectivo + ingresosManual - egresosManual; // 1050
    decimal montoFisico = 1050m;

    // Act + Assert
    var cierre = await _handler.Handle(new CerrarTurnoComando
    {
        TurnoVendedorId = _turnoId,
        UsuarioVendedorId = _usuarioId,
        MontoFisicoContado = montoFisico
    }, CancellationToken.None);

    cierre.DiferenciaArqueo.Should().Be(0m);
    cierre.MontoEsperado.Should().Be(1050m);
}
```

### 5.4 Tipos de Movimiento de Inventario (hardcoded en los servicios)

| ID | Tipo | Usado en |
|----|------|----------|
| 19 | ING_COM (Ingreso por Compra) | `Compras.API.Application/Integracion/InventarioServicio.cs` |
| 20 | SAL_VEN (Salida por Venta) | `Ventas.API.Application/Integracion/InventarioServicio.cs` |
| 24 | DevolucionCompra (NC Compra) | `Compras.API.Application/Integracion/InventarioServicio.cs` |
| 25 | DevolucionVenta (NC Venta) | `Ventas.API.Application/Integracion/InventarioServicio.cs` |
| 26 | NotaDebitoCompra (ND Compra) | `Compras.API.Application/Integracion/InventarioServicio.cs` |
| 27 | NotaDebitoVenta (ND Venta) | `Ventas.API.Application/Integracion/InventarioServicio.cs` |

Los tests del AGENTE-6 y AGENTE-7 que verifiquen el tipo de movimiento deben inspeccionar el body HTTP enviado:

```csharp
handlerMock.Protected().Verify(
    "SendAsync",
    Times.Once(),
    ItExpr.Is<HttpRequestMessage>(req =>
        req.RequestUri!.ToString().Contains("inventario/movimientos") &&
        req.Method == HttpMethod.Post),
    ItExpr.IsAny<CancellationToken>());
```

### 5.5 Estados excluidos en cálculo de arqueo

Al calcular totales en el cierre de turno, los agentes deben verificar que se excluyen:
- `id_estado = 61` (Anulado Directo)
- `id_estado = 64` (Anulado NC)
- `id_estado = 65` (Anulado ND)

---

## 6. Cronograma Actualizado

| Sprint | Agentes | Duración estimada |
|--------|---------|-------------------|
| Sprint 1 | AGENTE-0 (Shared) | 1 día |
| Sprint 2 | AGENTE-1 (Identidad) | 3 días |
| Sprint 3 | AGENTES 2, 3, 4 en paralelo | 3 días |
| Sprint 4 | AGENTE-5 (Inventario/Kardex) | 5 días |
| Sprint 5 | AGENTES 6, 7 en paralelo | 5 días |
| Sprint 6 | AGENTES 8, 9 en paralelo | 2 días |
| **Total** | | **~19 días** |

---

## 7. Metas de Cobertura Actualizadas

| API | Unit | Integration | E2E | Objetivo |
|-----|------|-------------|-----|----------|
| Identidad.API | 95% handlers+servicios+roles | 90% endpoints | - | **93%** |
| Configuracion.API | 80% | 85% | - | **83%** |
| Catalogo.API | 90% | 85% | - | **88%** |
| Clientes.API | 85% | 90% | - | **87%** |
| Inventario.API | 95% Kardex+Stock | 85% endpoints | - | **90%** |
| Compras.API | 90% handlers+integración | 85% endpoints | - | **88%** |
| Ventas.API | 92% handlers+turnos+integración | 87% endpoints | - | **90%** |
| Contabilidad.API | 80% | 80% | - | **80%** |
| Gateway.API | - | - | 85% | **85%** |
| Nucleo | 95% | - | - | **95%** |

---

*Versión 2.0 — Actualizado 2026-04-21. Incluye: Sistema de Turnos/Cajas, Integración HTTP entre microservicios, Evento VentaCreada, Gestión Granular de Roles, Reportes de Ventas y Compras.*
