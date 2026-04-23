# AGENTE-5 — Inventario.API.Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para un microservicio .NET 8.0. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Backend\`

La carpeta `src/` contiene el código fuente (NO modificar).
La carpeta `tests/Nucleo.Tests.Shared/` ya existe con `AuthHelper` y `PostgreSqlFixture`.

## Tu misión

Crear `tests/Inventario.API.Tests/` — este es el microservicio MÁS COMPLEJO del sistema. Gestiona stock, movimientos y el Kardex (valuación de inventario). Los agentes AGENTE-6 y AGENTE-7 dependen de este microservicio.

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/Inventario.API/Inventario.API.Application/Servicios/KardexService.cs
src/Inventario.API/Inventario.API.Application/Servicios/KardexRecalculoService.cs
src/Inventario.API/Inventario.API.Application/Manejadores/CrearMovimientoInventarioManejador.cs
src/Inventario.API/Inventario.API.Application/Manejadores/Kardex/AbrirPeriodoManejador.cs
src/Inventario.API/Inventario.API.Application/Manejadores/Kardex/CerrarPeriodoManejador.cs
src/Inventario.API/Inventario.API.Application/Manejadores/Kardex/GenerarReporteKardexManejador.cs
src/Inventario.API/Inventario.API.Application/Comandos/CrearMovimientoInventarioComando.cs
src/Inventario.API/Inventario.API.Application/Interfaces/IInventarioDbContext.cs
src/Inventario.API/Inventario.API.Domain/Entidades/Kardex/KardexMovimiento.cs
src/Inventario.API/Inventario.API.Domain/Entidades/MovimientoInventario.cs
src/Inventario.API/Inventario.API.Domain/Interfaces/IKardexMovimientoRepositorio.cs
src/Inventario.API/Inventario.API.Domain/Interfaces/IStockRepositorio.cs
src/Inventario.API/Inventario.API.Infrastructure/Repositorios/KardexMovimientoRepositorio.cs
src/Inventario.API/Inventario.API.Infrastructure/Repositorios/StockRepositorio.cs
src/Inventario.API/Inventario.API.API/Endpoints/MovimientosEndpoints.cs
src/Inventario.API/Inventario.API.API/Endpoints/StockEndpoints.cs
src/Inventario.API/Inventario.API.API/Program.cs
```

## Archivo .csproj a crear

`tests/Inventario.API.Tests/Inventario.API.Tests.csproj`:
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
    <ProjectReference Include="..\..\src\Inventario.API\Inventario.API.API\Inventario.API.API.csproj" />
    <ProjectReference Include="..\Nucleo.Tests.Shared\Nucleo.Tests.Shared.csproj" />
  </ItemGroup>
</Project>
```

## Conocimiento del Kardex (LEER CUIDADOSAMENTE)

El Kardex registra cada movimiento de inventario y calcula el costo según el método de valuación:

### Método PP (Promedio Ponderado)
```
Entrada 1: 100 unidades × S/ 10.00 = S/ 1,000.00  →  Costo promedio: S/ 10.00
Entrada 2:  50 unidades × S/ 14.00 = S/   700.00  →  Costo promedio: S/ 11.33  (1700/150)
Salida:     80 unidades             = S/   906.67  (80 × 11.33)
Saldo:      70 unidades             × S/ 11.33
```

### Tipos de movimiento conocidos
| ID | Tipo | Dirección |
|----|------|-----------|
| 19 | ING_COM (Ingreso por Compra) | Entrada |
| 20 | SAL_VEN (Salida por Venta) | Salida |
| 24 | DevolucionCompra | Salida |
| 25 | DevolucionVenta | Entrada |
| 26 | NotaDebitoCompra | Entrada |
| 27 | NotaDebitoVenta | Salida |

## Tests que debes implementar

### `Unit/Servicios/KardexServiceTests.cs`

Leer `KardexService.cs` para conocer las firmas exactas de los métodos. Mockear `IKardexMovimientoRepositorio` e `IStockRepositorio`.

1. `CalcularCostoPP_ConUnaEntrada_DebeRetornarMismoCosto()`
   - 1 entrada de 100 u. a 10.00 → costo promedio = 10.00

2. `CalcularCostoPP_ConDosEntradas_DebePromediarPonderado()`
   - Entrada 1: 100u × 10.00. Entrada 2: 50u × 14.00
   - Costo promedio esperado: (1000 + 700) / 150 = 11.33 (tolerancia ±0.01)

3. `RegistrarSalida_ConStockSuficiente_DebeReducirSaldo()`
   - Stock actual: 150u. Salida: 80u. Saldo esperado: 70u

4. `RegistrarSalida_ConStockInsuficiente_DebeLanzarException()`
   - Stock actual: 50u. Salida: 80u → debe lanzar excepción

5. `RegistrarEntrada_DebeActualizarCostoPromedioYSaldo()`
   - Registrar entrada → el costo promedio se recalcula correctamente

### `Unit/Servicios/KardexRecalculoServiceTests.cs`

Leer `KardexRecalculoService.cs`. El recálculo procesa TODOS los movimientos de un producto cronológicamente y recalcula los campos de costo/saldo.

1. `Recalcular_ConMovimientosDesordenados_DebeReordenarCronologicamente()`
   - Movimientos con fechas en desorden → el recálculo los procesa en orden de fecha

2. `Recalcular_DespuesDeEliminarEntrada_DebeAjustarCostoPromedio()`
   - Simular eliminación de una entrada → el costo promedio debe cambiar al recalcular

3. `Recalcular_ConPeriodoCerrado_DebeLanzarException()`
   - Si existe un período cerrado en el rango → debe lanzar excepción (no se puede modificar)

### `Unit/Comandos/CrearMovimientoInventarioHandlerTests.cs`

Leer `CrearMovimientoInventarioManejador.cs`. Mockear repositorios e `IKardexService`.

1. `Handle_ConTipoIngreso_DebeAumentarStock()`
   - IdTipoMovimiento = 19 (ING_COM) → stock aumenta

2. `Handle_ConTipoSalida_DebeDisminuirStock()`
   - IdTipoMovimiento = 20 (SAL_VEN) → stock disminuye

3. `Handle_ConSalidaYStockInsuficiente_DebeLanzarException()`
   - Stock actual: 5. Cantidad salida: 10 → excepción

4. `Handle_ConAlmacenInexistente_DebeLanzarException()`
   - Repositorio de almacén devuelve null → excepción

5. `Handle_ConProductoInexistente_DebeLanzarException()`
   - Repositorio de producto devuelve null → excepción

### `Unit/Comandos/AbrirCerrarPeriodoHandlerTests.cs`

Leer `AbrirPeriodoManejador.cs` y `CerrarPeriodoManejador.cs`.

1. `AbrirPeriodo_ConFechaValida_DebeCrearPeriodoAbierto()`
   - No hay período activo → crear período con estado "ABIERTO"

2. `AbrirPeriodo_ConPeriodoYaAbierto_DebeLanzarException()`
   - Ya existe período abierto para ese producto/almacén → excepción

3. `CerrarPeriodo_ConPeriodoAbierto_DebeCambiarEstado()`
   - Período en estado "ABIERTO" → cambiar a "CERRADO"

4. `CerrarPeriodo_ConMovimientosPendientes_DebeLanzarException()`
   - Hay movimientos sin procesar en el período → excepción

### `Integration/Repositorios/StockRepositorioTests.cs`

Usar `PostgreSqlFixture` (IClassFixture). Aplicar migrations del InventarioDbContext.

1. `ObtenerStockActual_ConProductoYAlmacen_DebeRetornarStockCorrecto()`
   - Insertar registro de stock → consultar → recibir cantidad correcta

2. `ActualizarStock_ConCantidadPositiva_DebeAumentar()`
   - Stock inicial: 10. Aumentar 5 → stock final: 15

3. `ActualizarStock_ConCantidadNegativa_DebeDisminuir()`
   - Stock inicial: 10. Disminuir 3 → stock final: 7

### `Integration/Repositorios/KardexMovimientoRepositorioTests.cs`

1. `ObtenerPorPeriodo_ConFechasFiltradas_DebeRetornarSoloMovimientosEnRango()`
   - Insertar 3 movimientos en fechas distintas → filtrar por rango → solo los del rango

2. `ObtenerUltimoMovimiento_ConProductoYAlmacen_DebeRetornarElMasReciente()`
   - Insertar 2 movimientos → el método devuelve el de fecha más reciente

### `Integration/Endpoints/MovimientosEndpointTests.cs`

Usar `WebApplicationFactory<Program>`.

1. `POST_Movimientos_ConTipoIngreso_DebeRegistrar()`
   - POST /api/movimientos con TipoMovimiento=19 → 200 OK o 201

2. `POST_Movimientos_ConTipoSalida_DebeRegistrar()`
   - POST con TipoMovimiento=20 y stock suficiente → 200 OK

3. `POST_Movimientos_ConStockInsuficiente_DebeRetornar400()`
   - POST con salida mayor al stock disponible → 400 BadRequest

4. `GET_Stock_PorAlmacen_DebeRetornarStockActual()`
   - GET /api/stock?almacenId=1 → 200 OK con lista de stocks

### `Integration/Endpoints/KardexEndpointTests.cs`

1. `GET_Kardex_ConPeriodoValido_DebeRetornarReporte()`
   - GET /api/kardex con parámetros de período → 200 OK con movimientos

2. `POST_AbrirPeriodo_ConFechaValida_DebeRetornar200()`
   - POST /api/kardex/abrir-periodo → 200 OK

3. `POST_CerrarPeriodo_ConPeriodoAbierto_DebeRetornar200()`
   - POST /api/kardex/cerrar-periodo → 200 OK

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[Metodo]_[Condicion]_[ResultadoEsperado]`
- Usar `FluentAssertions` — tolerancia de 0.01 para decimales: `.Should().BeApproximately(11.33m, 0.01m)`
- No agregar paquetes NuGet extra
- No modificar nada en `src/`

## Verificación final

```
dotnet build tests/Inventario.API.Tests/Inventario.API.Tests.csproj
dotnet test tests/Inventario.API.Tests/Inventario.API.Tests.csproj --filter "Category!=Integration"
```
