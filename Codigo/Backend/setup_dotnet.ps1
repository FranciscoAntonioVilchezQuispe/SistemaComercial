$root = "E:\ProyectosNuevos\SistemaComercial\Codigo\Backend"
$src = "$root\src"

# 1. Crear Solución
if (!(Test-Path "$root\SistemaComercial.sln")) {
    dotnet new sln -n SistemaComercial -o "$root"
}

# 2. Configurar Nucleo (BuildingBlocks)
# Vamos a crear 3 proyectos separados para Nucleo para respetar capas, o 1 solo si es SharedKernel simplificado.
# Dado el structure `Nucleo\Comun.Domain`, `Nucleo\Comun.Application`, haremos 1 solo proyecto "Nucleo" para simplificar referencias por ahora
# O mejor, 3 proyectos para evitar dependencias circulares si crece.
# Pero la carpeta es "Nucleo". Hagamos un ClassLib en Nucleo que incluya todo.
$nucleoPath = "$src\Nucleo"
if (!(Test-Path "$nucleoPath\Nucleo.csproj")) {
    dotnet new classlib -n Nucleo -o "$nucleoPath"
    # Eliminar Class1.cs
    Remove-Item "$nucleoPath\Class1.cs" -ErrorAction SilentlyContinue
}
dotnet sln "$root\SistemaComercial.sln" add "$nucleoPath\Nucleo.csproj"
# Agregar paquetes a Nucleo
dotnet add "$nucleoPath\Nucleo.csproj" package MediatR.Contracts
dotnet add "$nucleoPath\Nucleo.csproj" package FluentValidation

# 3. Limpieza y Configuración de Catalogo
$catPath = "$src\Catalogo.API"

# Limpiar carpetas incorrectas generadas por scaffold anterior (ej: Catalogo.API.Domain)
Remove-Item "$catPath\Catalogo.API.Domain" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$catPath\Catalogo.API.Application" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$catPath\Catalogo.API.Infrastructure" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$catPath\Catalogo.API.API" -Recurse -Force -ErrorAction SilentlyContinue

# Definir capas correctas
$layers = @{
    "Domain" = "Catalogo.Domain"
    "Application" = "Catalogo.Application"
    "Infrastructure" = "Catalogo.Infrastructure"
    "API" = "Catalogo.API"
}

# Crear proyectos por capa
foreach ($layerCtx in $layers.GetEnumerator()) {
    $layerName = $layerCtx.Key
    $projectName = $layerCtx.Value
    $projectPath = "$catPath\$projectName"

    # Asegurar que la carpeta existe (API foldes names might differ slightly in pathing logic)
    # The folder structure I wrote to was "Catalogo.API\Catalogo.Domain"
    # So $catPath is ...\Catalogo.API. 
    # Inside it matches $projectName ("Catalogo.Domain"). Good.
    
    if (!(Test-Path "$projectPath")) {
        New-Item -ItemType Directory -Path "$projectPath" -Force
    }

    if (!(Test-Path "$projectPath\$projectName.csproj")) {
        if ($layerName -eq "API") {
            dotnet new webapi -n $projectName -o "$projectPath" --use-controllers false
        } else {
            dotnet new classlib -n $projectName -o "$projectPath"
        }
        Remove-Item "$projectPath\Class1.cs" -ErrorAction SilentlyContinue
    }
    
    dotnet sln "$root\SistemaComercial.sln" add "$projectPath\$projectName.csproj"
}

# 4. Establecer Referencias entre Capas (Clean Arch)
# Domain no depende de nadie (solo Nucleo)
dotnet add "$catPath\Catalogo.Domain\Catalogo.Domain.csproj" reference "$nucleoPath\Nucleo.csproj"

# Application depende de Domain y Nucleo
dotnet add "$catPath\Catalogo.Application\Catalogo.Application.csproj" reference "$catPath\Catalogo.Domain\Catalogo.Domain.csproj"
dotnet add "$catPath\Catalogo.Application\Catalogo.Application.csproj" reference "$nucleoPath\Nucleo.csproj"
dotnet add "$catPath\Catalogo.Application\Catalogo.Application.csproj" package MediatR
dotnet add "$catPath\Catalogo.Application\Catalogo.Application.csproj" package FluentValidation

# Infrastructure depende de Application (para interfaces) y Domain
dotnet add "$catPath\Catalogo.Infrastructure\Catalogo.Infrastructure.csproj" reference "$catPath\Catalogo.Application\Catalogo.Application.csproj"
dotnet add "$catPath\Catalogo.Infrastructure\Catalogo.Infrastructure.csproj" reference "$catPath\Catalogo.Domain\Catalogo.Domain.csproj"
dotnet add "$catPath\Catalogo.Infrastructure\Catalogo.Infrastructure.csproj" reference "$nucleoPath\Nucleo.csproj"
dotnet add "$catPath\Catalogo.Infrastructure\Catalogo.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.PostgreSQL

# API depende de Application y Infrastructure
dotnet add "$catPath\Catalogo.API\Catalogo.API.csproj" reference "$catPath\Catalogo.Application\Catalogo.Application.csproj"
dotnet add "$catPath\Catalogo.API\Catalogo.API.csproj" reference "$catPath\Catalogo.Infrastructure\Catalogo.Infrastructure.csproj"
dotnet add "$catPath\Catalogo.API\Catalogo.API.csproj" reference "$nucleoPath\Nucleo.csproj"
dotnet add "$catPath\Catalogo.API\Catalogo.API.csproj" package MediatR

Write-Host "Configuración de proyectos completada. Intentando compilar..."
dotnet build "$root\SistemaComercial.sln"
