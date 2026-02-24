using Inventario.API.Domain.Entidades.Kardex;
using Inventario.API.Domain.Interfaces;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Inventario.API.Application.Servicios
{
    public interface IKardexRecalculoService
    {
        Task RecalcularDesdePuntoDeQuiebreAsync(long almacenId, long productoId, DateTime desdeFecha, TimeSpan desdeHora, string motivo, long usuarioId);
    }

    public class KardexRecalculoService : IKardexRecalculoService
    {
        private readonly IKardexMovimientoRepositorio _kardexRepo;
        private readonly IKardexRecalculoLogRepositorio _logRepo;
        // Dependencia al catálogo mock/servicio para leer si producto permite stock negativo y su metodo de valuacion

        public KardexRecalculoService(
            IKardexMovimientoRepositorio kardexRepo, 
            IKardexRecalculoLogRepositorio logRepo)
        {
            _kardexRepo = kardexRepo;
            _logRepo = logRepo;
        }

        public async Task RecalcularDesdePuntoDeQuiebreAsync(long almacenId, long productoId, DateTime desdeFecha, TimeSpan desdeHora, string motivo, long usuarioId)
        {
            // Opcional: Iniciar TransactionScope (o se asume transaccional desde el UnitOfWork del Controller)

            var startTime = DateTime.UtcNow;

            // PASO 1: Obtener saldo ANTERIOR al punto de quiebre
            var saldoBase = await _kardexRepo.ObtenerUltimoMovimientoAsync(almacenId, productoId, desdeFecha, desdeHora);
            
            decimal saldoAcumQty = saldoBase?.SaldoCantidad ?? 0;
            decimal saldoAcumCostoUnitario = saldoBase?.SaldoCostoUnitario ?? 0;
            decimal saldoAcumCostoTotal = saldoBase?.SaldoCostoTotal ?? 0;

            // PASO 2: Obtener TODOS los movimientos posteriores, ORDENADOS
            // Bloqueo pesimista concurrente (Ya bloqueado arriba, pero reforzamos)
            await _kardexRepo.BloquearFilaParaCalculoAsync(almacenId, productoId);

            var movimientos = await _kardexRepo.ObtenerMovimientosDesdeAsync(almacenId, productoId, desdeFecha, desdeHora);
            int regsAfectados = 0;

            // PASO 3: Recalcular secuencialmente
            foreach (var mov in movimientos)
            {
                if (mov.Anulado) continue; // Los anulados no afectan el saldo

                decimal costoMovimientoUnitarioAplicable = 0;
                decimal costoMovimientoTotalAplicable = 0;

                if (mov.TipoOperacion == "E")
                {
                    // ENTRADA: Trae su propio costo original, recalculamos el TOTAL en base a ese costo
                    costoMovimientoUnitarioAplicable = mov.EntradaCostoUnitario ?? 0;
                    costoMovimientoTotalAplicable = Math.Round((mov.EntradaCantidad ?? 0) * costoMovimientoUnitarioAplicable, 6);

                    // Actualizar Saldo
                    saldoAcumQty += (mov.EntradaCantidad ?? 0);
                    saldoAcumCostoTotal += costoMovimientoTotalAplicable;

                    if (saldoAcumQty > 0)
                        saldoAcumCostoUnitario = Math.Round(saldoAcumCostoTotal / saldoAcumQty, 6);
                    else
                        saldoAcumCostoUnitario = 0;

                    // Actualizar Fila
                    mov.EntradaCostoTotal = costoMovimientoTotalAplicable; // Por si hubo precision error antes
                }
                else if (mov.TipoOperacion == "S")
                {
                    // SALIDA: Dependerá del método. Por ahora, Promedio Ponderado => Toma Costo Promedio Unitario INMEDIATO ANTERIOR (saldoAcumCostoUnitario)
                    costoMovimientoUnitarioAplicable = saldoAcumCostoUnitario;
                    costoMovimientoTotalAplicable = Math.Round((mov.SalidaCantidad ?? 0) * costoMovimientoUnitarioAplicable, 6);

                    // Actualizar Saldo
                    saldoAcumQty -= (mov.SalidaCantidad ?? 0);
                    saldoAcumCostoTotal = Math.Round(saldoAcumCostoTotal - costoMovimientoTotalAplicable, 6);

                    if (saldoAcumQty > 0)
                        saldoAcumCostoUnitario = Math.Round(saldoAcumCostoTotal / saldoAcumQty, 6);
                    else
                        saldoAcumCostoUnitario = 0;

                    // Actualizar Fila (se reescriben los costos que tuvo históricamente porque el pasado cambió)
                    mov.SalidaCostoUnitario = costoMovimientoUnitarioAplicable;
                    mov.SalidaCostoTotal = costoMovimientoTotalAplicable;
                }

                // Escribir nuevos saldos a la fila
                mov.SaldoCantidad = saldoAcumQty;
                mov.SaldoCostoUnitario = saldoAcumCostoUnitario;
                mov.SaldoCostoTotal = saldoAcumCostoTotal;
                mov.RecalculadoAt = DateTime.UtcNow;

                await _kardexRepo.ActualizarAsync(mov);
                regsAfectados++;
            }

            // PASO 4 (Para Futuro PEPS/UEPS)
            // if (producto.MetodoValuacion in ("PE", "UE")) -> ReconstruirLotesAsync(almacenId, productoId, desdeFecha);

            // PASO 5: Registrar la tabla de bitácora
            var endTime = DateTime.UtcNow;
            await _logRepo.AgregarAsync(new KardexRecalculoLog
            {
                AlmacenId = (int)almacenId,
                ProductoId = (int)productoId,
                DesdeFecha = DateOnly.FromDateTime(desdeFecha),
                Motivo = motivo,
                RegistrosAfect = regsAfectados,
                UsuarioId = (int)usuarioId,
                DuracionMs = (int)(endTime - startTime).TotalMilliseconds
            });
        }
    }
}
