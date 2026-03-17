$ErrorActionPreference = "Stop"

$modules = @("Catalogo", "Clientes", "Compras", "Configuracion", "Identidad", "Inventario", "Ventas")
$outDir = ".\BaseDeDatos\MigracionesFaltantes"

if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

foreach ($mod in $modules) {
    Write-Host "Generando script SQL para: $mod"
    
    # Encontrar Infraestructura
    $infraProjects = Get-ChildItem -Path ".\Backend\src\$mod.API" -Recurse -Filter "*Infrastructure*.csproj"
    # Encontrar API (Startup)
    $apiProjects = Get-ChildItem -Path ".\Backend\src\$mod.API" -Recurse -Filter "*.API.csproj"
    
    if ($infraProjects.Count -gt 0 -and $apiProjects.Count -gt 0) {
        $projectPath = $infraProjects[0].FullName
        $startupPath = $apiProjects[0].FullName
        
        $outFile = "$outDir\00_$mod`_Migrations.sql"
        dotnet ef migrations script --idempotent --output $outFile --project "$projectPath" --startup-project "$startupPath"
    } else {
        Write-Host "No se encontraron los proyectos para $mod"
    }
}
Write-Host "Generacion terminada."
