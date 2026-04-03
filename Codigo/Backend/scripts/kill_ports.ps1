$ports = (5000..5010) + 5180

Write-Host "Revisando y liberando puertos: $ports" -ForegroundColor Yellow

foreach ($port in $ports) {
    $process = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -First 1
    if ($process) {
        Write-Host "Matando proceso $process en puerto $port..." -ForegroundColor Cyan
        Stop-Process -Id $process -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "Limpieza de puertos completada." -ForegroundColor Green
