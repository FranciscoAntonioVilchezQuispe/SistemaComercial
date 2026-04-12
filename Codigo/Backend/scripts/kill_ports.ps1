$ports = (5000..5010) + 5180 +5181

Write-Host "Revisando y liberando puertos: $ports" -ForegroundColor Yellow

foreach ($port in $ports) {
    # Usamos Get-NetTCPConnection para obtener todos los procesos que escuchan (State = Listen) o tienen una conexión activa
    $connections = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue 
    if ($connections) {
        $pids = $connections | Select-Object -ExpandProperty OwningProcess -Unique
        foreach ($procId in $pids) {
            if ($procId -gt 0) {
                Write-Host "Matando proceso $procId encontrado en puerto $port..." -ForegroundColor Cyan
                Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

Write-Host "Limpieza de puertos completada." -ForegroundColor Green
