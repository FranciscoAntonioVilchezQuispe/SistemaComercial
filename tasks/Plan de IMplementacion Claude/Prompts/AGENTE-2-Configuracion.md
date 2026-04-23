# AGENTE-2 — Configuracion.API.Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para un microservicio .NET 8.0. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\`

La carpeta `src/` contiene el código fuente (NO modificar).
La carpeta `tests/Nucleo.Tests.Shared/` ya existe con `AuthHelper` y `PostgreSqlFixture`.

## Tu misión

Crear `tests/Configuracion.API.Tests/` con tests para el microservicio de configuración global del sistema (empresa, impuestos, series, tipos de comprobante, catálogos SUNAT).

## Archivos fuente que DEBES leer primero

```
src/Configuracion.API/Configuracion.API.API/Endpoints/EmpresaEndpoints.cs
src/Configuracion.API/Configuracion.API.API/Endpoints/ImpuestoEndpoints.cs
src/Configuracion.API/Configuracion.API.API/Endpoints/MatrizSunatEndpoints.cs
src/Configuracion.API/Configuracion.API.API/Endpoints/TipoAfectacionIgvEndpoints.cs
src/Configuracion.API/Configuracion.API.API/Endpoints/TipoTributoEndpoints.cs
src/Configuracion.API/Configuracion.API.API/Endpoints/SerieComprobanteEndpoints.cs
src/Configuracion.API/Configuracion.API.Application/DTOs/ConfiguracionDtos.cs
src/Configuracion.API/Configuracion.API.Domain/Entidades/MatrizReglaSunat.cs
src/Configuracion.API/Configuracion.API.Domain/Entidades/TipoAfectacionIgv.cs
src/Configuracion.API/Configuracion.API.Domain/Entidades/TipoComprobante.cs
src/Configuracion.API/Configuracion.API.API/Program.cs
```

## Archivo .csproj a crear

`tests/Configuracion.API.Tests/Configuracion.API.Tests.csproj`:
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
    <PackageReference Include="Bogus" Version="35.6.1" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\..\src\Configuracion.API\Configuracion.API.API\Configuracion.API.API.csproj" />
    <ProjectReference Include="..\Nucleo.Tests.Shared\Nucleo.Tests.Shared.csproj" />
  </ItemGroup>
</Project>
```

## Dominio peruano importante

Este microservicio maneja datos fiscales de SUNAT. Reglas críticas:
- **RUC**: exactamente 11 dígitos numéricos
- **Series de comprobante**: formato `[FBCE][0-9A-Z]{3}` (ej: F001, B001, FC01, FD01)
- **TipoAfectacionIgv**: Catálogo 07 SUNAT (10=Gravado Onerosa, 20=Exonerado, 30=Inafecto)
- **MatrizReglaSunat**: mapea TipoComprobante + TipoOperacion → reglas de emisión

## Tests que debes implementar

### `Unit/Validadores/EmpresaValidatorTests.cs`

Busca el validador de Empresa en `src/Configuracion.API/Configuracion.API.Application/`. Si no existe un `AbstractValidator`, crea el test asumiendo validación manual con FluentValidation.

1. `Validar_ConRucDe11Digitos_DebePasar()`
   - RUC: "20123456789" (11 dígitos) → IsValid=true

2. `Validar_ConRucMenorDe11Digitos_DebeFallar()`
   - RUC: "2012345678" (10 dígitos) → IsValid=false

3. `Validar_ConRazonSocialVacia_DebeFallar()`
   - RazonSocial: "" → IsValid=false

4. `Validar_ConDireccionFiscalVacia_DebeFallar()`
   - DireccionFiscal: "" → IsValid=false

### `Unit/Validadores/SerieComprobanteValidatorTests.cs`

1. `Validar_ConSerieFormatoF001_DebePasar()` — "F001" es válida (Factura)
2. `Validar_ConSerieFormatoB001_DebePasar()` — "B001" es válida (Boleta)
3. `Validar_ConSerieConMenos4Caracteres_DebeFallar()` — "F01" → inválida
4. `Validar_ConSerieSinPrefijoCorrecto_DebeFallar()` — "X001" → inválida (X no es F/B/C/E)

### `Integration/Endpoints/EmpresaEndpointTests.cs`

Usar `WebApplicationFactory<Program>`. Los endpoints requieren token Admin (usar `AuthHelper.GenerarTokenAdmin()`).

1. `GET_Empresa_ConTokenAdmin_DebeRetornar200()`
   - GET /api/empresa con Bearer token Admin → 200 OK

2. `PUT_Empresa_ConDatosValidos_DebeActualizar()`
   - PUT /api/empresa con body válido → 200 OK

3. `PUT_Empresa_ConRucInvalido_DebeRetornar400()`
   - PUT /api/empresa con RUC de 10 dígitos → 400 BadRequest

### `Integration/Endpoints/MatrizSunatEndpointTests.cs`

La matriz SUNAT define qué tipos de comprobante se pueden usar con qué tipos de operación.

1. `GET_MatrizSunat_DebeRetornarListaCompleta()`
   - GET /api/matriz-sunat → 200 OK con lista no vacía

2. `GET_MatrizSunat_FiltradoPorTipoComprobante_DebeRetornarSubconjunto()`
   - GET /api/matriz-sunat?tipoComprobanteId=1 → 200 OK, todos los items tienen mismo TipoComprobanteId

### `Integration/Endpoints/TipoAfectacionIgvEndpointTests.cs`

El Catálogo 07 de SUNAT define cómo se afecta el IGV por línea de detalle.

1. `GET_TipoAfectacionIgv_DebeRetornarCatalogo07Sunat()`
   - GET /api/tipos-afectacion-igv → 200 OK con lista

2. `GET_TipoAfectacionIgv_DebeIncluirCodigo10GravadoOperacionOnerosa()`
   - La lista debe incluir un item con Codigo="10" o Descripcion que contenga "Gravado"

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[Metodo]_[Condicion]_[ResultadoEsperado]`
- Usar `FluentAssertions` (`.Should()`)
- No agregar paquetes NuGet extra
- No modificar nada en `src/`
- Los endpoints de Configuracion requieren rol ADMIN → usar `AuthHelper.GenerarTokenAdmin()`

## Verificación final

```
dotnet build tests/Configuracion.API.Tests/Configuracion.API.Tests.csproj
```
