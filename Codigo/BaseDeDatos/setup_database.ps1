$ErrorActionPreference = "Stop"

Write-Host "=== INICIANDO CONFIGURACION DE BASE DE DATOS ===" -ForegroundColor Cyan

# 00. Crear Base de Datos
Write-Host "1/8 Creando Base de Datos..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\00_CrearBase.sql"

# 01. Estructura
Write-Host "2/8 Creando Estructura..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\01_Estructura.sql"

# 02. Menus
Write-Host "3/8 Insertando Menus..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\02_Datos_Menus.sql"

# 03. Permisos
Write-Host "4/8 Configurando Permisos..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\03_Permisos.sql"

# 04. Semilla
Write-Host "5/8 Datos de Prueba (Semilla)..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\04_Datos_Semilla.sql"

# 06. Faltantes Config
Write-Host "6/8 Tablas Faltantes Configuracion..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\06_Faltantes_Configuracion.sql"

# 07. Datos Config
Write-Host "7/8 Datos Configuracion..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\07_Datos_Configuracion.sql"

# 08. Restaurados
Write-Host "8/8 Restaurando Datos Historicos..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\08_Datos_Restaurados.sql"

# 99. Verificacion
Write-Host "VERIFICACION FINAL" -ForegroundColor Cyan
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\99_Verificacion.sql"

Write-Host "=== PROCESO COMPLETADO EXITOSAMENTE ===" -ForegroundColor Green
