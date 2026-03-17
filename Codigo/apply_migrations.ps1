$ErrorActionPreference = "Stop"
$sqlFiles = Get-ChildItem -Path ".\BaseDeDatos\MigracionesFaltantes" -Filter "*.sql"

foreach ($file in $sqlFiles) {
    Write-Host "Aplicando $($file.Name)..."
    $env:PGPASSWORD="aaAA11++"
    & "C:\Program Files\PostgreSQL\14\bin\psql.exe" -U postgres -d sistema_comercial -f $file.FullName
}
Write-Host "Todas las migraciones faltantes aplicadas exitosamente."
