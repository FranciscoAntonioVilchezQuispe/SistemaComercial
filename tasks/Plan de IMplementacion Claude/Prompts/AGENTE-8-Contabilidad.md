# AGENTE-8 — Contabilidad.API.Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para un microservicio .NET 8.0. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\`

La carpeta `src/` contiene el código fuente (NO modificar).
La carpeta `tests/Nucleo.Tests.Shared/` ya existe con `AuthHelper` y `PostgreSqlFixture`.

## Tu misión

Crear `tests/Contabilidad.API.Tests/` con tests para el microservicio de contabilidad (asientos contables, plan de cuentas, centros de costo).

## Archivos fuente que DEBES leer primero

```
src/Contabilidad.API/Contabilidad.API.Infrastructure/Datos/ContabilidadDbContext.cs
src/Contabilidad.API/Contabilidad.API.API/Program.cs
```

Busca también estos archivos si existen:
```
src/Contabilidad.API/Contabilidad.API.Domain/Entidades/
src/Contabilidad.API/Contabilidad.API.Application/Comandos/
src/Contabilidad.API/Contabilidad.API.Application/Manejadores/
src/Contabilidad.API/Contabilidad.API.API/Endpoints/
```

Lee todos los archivos que encuentres en esas rutas antes de escribir cualquier test.

## Archivo .csproj a crear

`tests/Contabilidad.API.Tests/Contabilidad.API.Tests.csproj`:
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
    <PackageReference Include="Microsoft.EntityFrameworkCore.InMemory" Version="8.0.8" />
    <PackageReference Include="Bogus" Version="35.6.1" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\..\src\Contabilidad.API\Contabilidad.API.API\Contabilidad.API.API.csproj" />
    <ProjectReference Include="..\Nucleo.Tests.Shared\Nucleo.Tests.Shared.csproj" />
  </ItemGroup>
</Project>
```

## Regla de negocio crítica: Balance contable

Un asiento contable válido DEBE cumplir:
```
SUM(DebeLineas) == SUM(HaberLineas)
```
Si no están balanceados, el asiento es inválido y debe rechazarse con error.

Un asiento debe tener al menos 2 líneas (una de Debe y una de Haber).

## Tests que debes implementar

### `Unit/Domain/AsientoContableTests.cs`

Si existe una clase `AsientoContable` con lógica de dominio, léela e instancia directamente. Si no tiene lógica propia (es solo una entidad), crea tests que prueben la regla de negocio a nivel de validador o handler.

1. `Crear_ConLineasBalanceadas_DebeSerValido()`
   - Línea Debe=500, Línea Haber=500 → SUM(Debe)==SUM(Haber) → válido

2. `Crear_SinBalanceo_DebeSerInvalido()`
   - Línea Debe=500, Línea Haber=300 → SUM(Debe)≠SUM(Haber) → inválido

3. `Crear_ConMenos2Lineas_DebeSerInvalido()`
   - Solo 1 línea → inválido (mínimo 2 líneas)

4. `Crear_ConMontoCero_DebeSerInvalido()`
   - Línea con Monto=0 → inválido

### `Unit/Comandos/CrearAsientoContableHandlerTests.cs`

Leer el handler si existe. Si el microservicio aún no tiene handlers CQRS (solo repositorios), crear el test mockeando el repositorio directamente.

1. `Handle_ConLineasBalanceadas_DebeCrearAsiento()`
   - Debe=1000, Haber=1000 → asiento creado con Id > 0

2. `Handle_ConAsientoDesbalanceado_DebeLanzarException()`
   - Debe=1000, Haber=800 → excepción de negocio

3. `Handle_ConMenos2Lineas_DebeLanzarException()`
   - Solo 1 línea → excepción

4. `Handle_ConAsientoCreado_DebeAsignarNumeroCorrrelativo()`
   - Assert: asiento tiene Numero no vacío (correlativo asignado)

### `Integration/Endpoints/ContabilidadEndpointTests.cs`

Usar `WebApplicationFactory<Program>`. Los endpoints requieren rol ADMIN.

Lee el archivo `src/Contabilidad.API/Contabilidad.API.API/Endpoints/` para conocer las rutas exactas antes de escribir los tests.

1. `GET_Asientos_ConTokenAdmin_DebeRetornar200()`
   - GET /api/contabilidad (o la ruta que encuentres) → 200 OK

2. `POST_Asientos_ConLineasBalanceadas_DebeCrear()`
   - POST con asiento balanceado y token Admin → 200 OK o 201

3. `POST_Asientos_ConAsientoDesbalanceado_DebeRetornar400()`
   - POST con Debe≠Haber → 400 BadRequest

4. `GET_PlanCuentas_DebeRetornarArbol()`
   - Si existe endpoint de plan de cuentas → GET → 200 OK con estructura de árbol/lista

## Instrucción especial

Si el microservicio de Contabilidad tiene pocos endpoints implementados (es el más simple del sistema), adapta los tests a lo que realmente existe. Lee primero los endpoints y handlers disponibles, y escribe tests solo para lo que está implementado. No inventes endpoints o handlers que no existan en el código.

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[Metodo]_[Condicion]_[ResultadoEsperado]`
- Usar `FluentAssertions` (`.Should()`)
- No agregar paquetes NuGet extra
- No modificar nada en `src/`
- Los endpoints requieren rol ADMIN: usar `AuthHelper.GenerarTokenAdmin()`

## Verificación final

```
dotnet build tests/Contabilidad.API.Tests/Contabilidad.API.Tests.csproj
```
