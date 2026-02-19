$ErrorActionPreference = "Stop"

Write-Host "=== INICIANDO CONFIGURACION DE BASE DE DATOS ===" -ForegroundColor Cyan

# 00. Crear Base de Datos
Write-Host "1/11 Creando Base de Datos..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\00_CrearBase.sql"

# 01. Estructura
Write-Host "2/11 Creando Estructura..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\01_Estructura.sql"

# 02. Menus
Write-Host "3/11 Insertando Menus..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\02_Datos_Menus.sql"

# 03. Permisos
Write-Host "4/11 Configurando Permisos..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\03_Permisos.sql"

# 04. Semilla
Write-Host "5/11 Datos de Prueba (Semilla)..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\04_Datos_Semilla.sql"

# 06. Faltantes Config
Write-Host "6/11 Tablas Faltantes Configuracion..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\06_Faltantes_Configuracion.sql"

# 07. Datos Config
Write-Host "7/11 Datos Configuracion..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\07_Datos_Configuracion.sql"

# 08. Restaurados
Write-Host "8/11 Restaurando Datos Historicos..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\08_Datos_Restaurados.sql"

# 09. Migracion Fase 1 (Kardex y Notas)
Write-Host "9/11 Migracion Fase 1 (Kardex y Notas)..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\09_Migracion_Fase1.sql"

# 10. Actualizar FKs Tipo Documento
Write-Host "10/11 Actualizando FKs de Tipo Documento..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\10_Migracion_TipoDocumento_FK.sql"

# 11. Modulos Tipo Comprobante
Write-Host "11/11 Configurando Modulos de Comprobante..." -ForegroundColor Yellow
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\11_Migracion_TipoComprobante_Modulos.sql"

# 99. Verificacion
Write-Host "VERIFICACION FINAL" -ForegroundColor Cyan
dotnet run --project Backend\scripts\SqlRunner\SqlRunner.csproj "BaseDeDatos\99_Verificacion.sql"

Write-Host "=== PROCESO COMPLETADO EXITOSAMENTE ===" -ForegroundColor Green
