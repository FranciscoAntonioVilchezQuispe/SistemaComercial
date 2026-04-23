# AGENTE-0 — Nucleo.Tests.Shared + Nucleo.Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para un sistema de microservicios .NET 8.0. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\`

La carpeta `src/` contiene el código fuente existente. Tu trabajo es crear la carpeta `tests/` con los proyectos de test.

**NO modificar ningún archivo dentro de `src/`.**

## Tu misión

Crear dos proyectos:
1. `tests/Nucleo.Tests.Shared/` — librería compartida que usarán TODOS los demás agentes
2. `tests/Nucleo.Tests/` — tests del núcleo del sistema

## Archivos fuente que DEBES leer primero

Antes de escribir código, lee estos archivos para entender las clases reales:

- `src/Nucleo/Comun.Application/Paginacion/PagedResponse.cs`
- `src/Nucleo/Comun.Application/Paginacion/PagedRequest.cs`
- `src/Nucleo/Comun.Application/Comportamientos/ComportamientoValidacion.cs`
- `src/Nucleo/Comun.Domain/Helpers/DateTimeHelper.cs`
- `src/Nucleo/Comun.Domain/AppException.cs`
- `src/Identidad.API/Identidad.API.API/appsettings.json` — para leer el SecretKey JWT real

## Archivos que debes CREAR

### 1. `tests/Nucleo.Tests.Shared/Nucleo.Tests.Shared.csproj`

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

### 2. `tests/Nucleo.Tests.Shared/Fixtures/PostgreSqlFixture.cs`

Clase que levanta un contenedor PostgreSQL 15-alpine para integration tests. Implementa `IAsyncLifetime`. Base de datos: `sistema_comercial_test`, usuario: `postgres`, contraseña: `test123`.

### 3. `tests/Nucleo.Tests.Shared/Helpers/AuthHelper.cs`

Clase estática que genera tokens JWT válidos para tests. Usar el SecretKey que encuentres en `appsettings.json` de Identidad.API.

Métodos requeridos:
- `GenerarTokenAdmin(long userId = 1)` — rol ADMIN con permisos: ventas:crear, ventas:ver, compras:ver, compras:crear, catalogo:ver
- `GenerarTokenVendedor(long userId = 2)` — rol VENDEDOR con permisos: ventas:crear, ventas:ver
- `GenerarToken(long userId, string rol, string[] permisos)` — genérico
- `GenerarTokenExpirado(long userId = 99)` — token ya expirado (DateTime.UtcNow.AddHours(-1))

Claims que debe incluir: `ClaimTypes.NameIdentifier`, `ClaimTypes.Role`, `"uid"`, y uno `"permiso"` por cada permiso.

### 4. `tests/Nucleo.Tests.Shared/Helpers/HttpClientExtensions.cs`

Métodos de extensión para `HttpClient`:
- `ConToken(string token)` — agrega Authorization: Bearer {token}
- `ConHeadersGateway(long userId, string rol)` — agrega X-User-Id y X-User-Roles

### 5. `tests/Nucleo.Tests/Nucleo.Tests.csproj`

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

## Tests que debes implementar (con código completo)

### `tests/Nucleo.Tests/Unit/Paginacion/PagedResponseTests.cs`

Implementa estos 4 tests con el patrón AAA. Lee `PagedResponse.cs` para conocer el constructor exacto:

1. `Crear_ConTotalMayorQuePageSize_DebeCalcularTotalPaginasCorrectamente()`
   - Total=25, PageSize=10, PageNumber=1 → TotalPages debe ser 3

2. `Crear_ConPagina1_DebeIndicarQueNoHayPaginaAnterior()`
   - PageNumber=1 → HasPreviousPage debe ser false

3. `Crear_ConUltimaPagina_DebeIndicarQueNoHayPaginaSiguiente()`
   - Total=20, PageSize=10, PageNumber=2 → HasNextPage debe ser false

4. `Crear_ConTotal0_DebeRetornarCeroTotalPaginas()`
   - Total=0 → TotalPages debe ser 0

### `tests/Nucleo.Tests/Unit/Comportamientos/ComportamientoValidacionTests.cs`

Lee `ComportamientoValidacion.cs` para ver cómo usa FluentValidation con MediatR Pipeline.

1. `Handle_ConDatosValidos_DebeLlamarAlSiguienteHandler()`
   - Sin errores de validación → debe llamar al delegate next

2. `Handle_ConDatosInvalidos_DebeLanzarValidationException()`
   - Con errores → debe lanzar `ValidationException`

3. `Handle_ConMultiplesErrores_DebeAcumularTodos()`
   - Con 2+ errores → la excepción debe contener todos los errores

### `tests/Nucleo.Tests/Unit/Helpers/DateTimeHelperTests.cs`

1. `ObtenerAhoraLima_DebeRetornarHoraUTCMenos5()`
   - La hora de Lima = UTC - 5 horas. Verificar que la diferencia es aproximadamente -5h (usar tolerancia de 1 minuto).

## Reglas obligatorias

- Patrón AAA en cada test: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[Metodo]_[Condicion]_[ResultadoEsperado]`
- Usar `FluentAssertions`: `.Should().Be()`, `.Should().NotBeNull()`, etc.
- No usar `Assert.Equal()` de xUnit directamente
- No agregar paquetes NuGet extra
- No crear archivos fuera de `tests/`
- Todos los tests deben ser `async Task` aunque no necesiten await (usar `Task.CompletedTask`)
- Los tests deben compilar sin errores

## Verificación final

Después de crear todos los archivos, ejecuta:
```
dotnet build tests/Nucleo.Tests/Nucleo.Tests.csproj
```
Si hay errores de compilación, corrígelos antes de terminar.
