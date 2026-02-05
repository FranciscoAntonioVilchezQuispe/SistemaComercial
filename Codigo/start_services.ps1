$ErrorActionPreference = "Stop"

Write-Host "=== INICIANDO SISTEMA COMERCIAL (MODO EJECUCION) ===" -ForegroundColor Cyan

# Definir la raíz basada en la ubicación del script
$RootPath = $PSScriptRoot

# Función helper
function Start-Service {
    param (
        [string]$Name,
        [string]$ProjectFolder
    )
    Write-Host "Iniciando $Name..." -ForegroundColor Yellow
    # Construir ruta absoluta
    $projectPath = Join-Path $RootPath "Backend\src\$ProjectFolder"
    
    if (!(Test-Path $projectPath)) {
        Write-Error "Ruta no encontrada: $projectPath"
        return
    }

    Start-Process -FilePath "dotnet" -ArgumentList "run --no-build" -WorkingDirectory $projectPath
}

# 1. Build (Opcional, pero recomendado hacerlo una vez antes)
# Write-Host "Compilando Backend..." -ForegroundColor Yellow
# dotnet build "$RootPath\Backend\src\SistemaComercial.sln" /v:m

# 2. Iniciar APIs
Start-Service -Name "Gateway.API" -ProjectFolder "Gateway.API"
Start-Service -Name "Identidad.API" -ProjectFolder "Identidad.API\Identidad.API.API"
Start-Service -Name "Configuracion.API" -ProjectFolder "Configuracion.API\Configuracion.API.API"
Start-Service -Name "Inventario.API" -ProjectFolder "Inventario.API\Inventario.API.API"
Start-Service -Name "Contabilidad.API" -ProjectFolder "Contabilidad.API\Contabilidad.API.API"
Start-Service -Name "Ventas.API" -ProjectFolder "Ventas.API\Ventas.API.API"
Start-Service -Name "Catalogo.API" -ProjectFolder "Catalogo.API\Catalogo.API"
Start-Service -Name "Clientes.API" -ProjectFolder "Clientes.API\Clientes.API.API"
Start-Service -Name "Compras.API" -ProjectFolder "Compras.API\Compras.API.API"

# 3. Iniciar Frontend
Write-Host "Iniciando Frontend..." -ForegroundColor Green
$FrontendPath = Join-Path $RootPath "Frontend"

if (Test-Path $FrontendPath) {
    Start-Process -FilePath "npm" -ArgumentList "run dev" -WorkingDirectory $FrontendPath
} else {
    Write-Error "Ruta Frontend no encontrada: $FrontendPath"
}

Write-Host "`nTodos los servicios han sido lanzados en ventanas independientes." -ForegroundColor Cyan
Write-Host "Presione cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
