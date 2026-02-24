using Inventario.API.Application.DTOs;
using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Entidades.Kardex;
using Inventario.API.Domain.Interfaces;
using System;
using System.Threading.Tasks;

namespace Inventario.API.Application.Servicios
{
    public class KardexService : IKardexService
    {
        private readonly IKardexMovimientoRepositorio _kardexRepo;
        private readonly IKardexPeriodoControlRepositorio _periodoRepo;

        public KardexService(IKardexMovimientoRepositorio kardexRepo, IKardexPeriodoControlRepositorio periodoRepo)
        {
            _kardexRepo = kardexRepo;
            _periodoRepo = periodoRepo;
        }

        public async Task AnularMovimientoAsync(long movimientoId, string motivoAnulacion, long usuarioId)
        {
            var mov = await _kardexRepo.ObtenerPorIdAsync(movimientoId);
            if (mov == null || mov.Anulado) throw new Exception("Movimiento no encontrado o ya anulado.");

            // Validar Periodo
            if (await _periodoRepo.EstaPeriodoCerradoAsync(mov.Periodo))
                throw new Exception($"El periodo {mov.Periodo} se encuentra cerrado. No se puede anular.");

            // Bloqueo Concurrente
            await _kardexRepo.BloquearFilaParaCalculoAsync(mov.AlmacenId, mov.ProductoId);

            mov.Anulado = true;
            mov.MotivoAnulacion = motivoAnulacion;
            mov.FechaAnulacion = DateTime.UtcNow.Date;
            mov.UsuarioAnulacionId = usuarioId;

            await _kardexRepo.ActualizarAsync(mov);

            // TODO: Disparar el Recálculo Retroactivo enviando el Punto de Quiebre (mov.FechaHoraCompuesta)
        }

        public async Task<KardexMovimiento> RegistrarEntradaAsync(RegistrarMovimientoKardexDto dto)
        {
            return await RegistrarMovimientoInternoAsync(dto, "E");
        }

        public async Task<KardexMovimiento> RegistrarSalidaAsync(RegistrarMovimientoKardexDto dto)
        {
            return await RegistrarMovimientoInternoAsync(dto, "S");
        }

        private async Task<KardexMovimiento> RegistrarMovimientoInternoAsync(RegistrarMovimientoKardexDto dto, string operacion)
        {
            // 1. Validar Periodo Cerrado
            string periodoActual = $"{dto.FechaMovimiento:yyyy-MM}";
            if (await _periodoRepo.EstaPeriodoCerradoAsync(periodoActual))
                throw new Exception($"El periodo {periodoActual} contable está cerrado. Operación rechazada.");

            // 2. Adquirir candado SQL por combinacion Producto-Almacén para evitar Race Conditions calculando promedios
            await _kardexRepo.BloquearFilaParaCalculoAsync(dto.AlmacenId, dto.ProductoId);

            // 3. Obtener el saldo inmediatamente anterior (El último registro válido hasta la fecha especificada)
            var saldoAnterior = await _kardexRepo.ObtenerUltimoMovimientoAsync(dto.AlmacenId, dto.ProductoId, dto.FechaMovimiento, dto.HoraMovimiento);

            decimal qtyAnterior = saldoAnterior?.SaldoCantidad ?? 0;
            decimal costoAnteriorUnit = saldoAnterior?.SaldoCostoUnitario ?? 0;
            decimal costoAnteriorTotal = saldoAnterior?.SaldoCostoTotal ?? 0;

            // 4. Instanciar Nuevo Movimiento
            var movimiento = ConstruirMovimientoBase(dto, operacion, periodoActual);

            decimal qtyNueva = 0, costoNuevoTotal = 0, costoNuevoUnitario = 0;

            if (operacion == "E")
            {
                if (!dto.CostoUnitarioIngreso.HasValue) throw new ArgumentException("El costo unitario de ingreso es obligatorio para ENTRADAS.");
                if (dto.CostoUnitarioIngreso < 0) throw new Exception("Validación SUNAT 3: El costo unitario de ingreso no puede ser negativo."); // REGLA 3

                movimiento.EntradaCantidad = dto.Cantidad;
                movimiento.EntradaCostoUnitario = dto.CostoUnitarioIngreso.Value;
                movimiento.EntradaCostoTotal = Math.Round(dto.Cantidad * dto.CostoUnitarioIngreso.Value, 6);

                qtyNueva = qtyAnterior + dto.Cantidad;
                costoNuevoTotal = costoAnteriorTotal + movimiento.EntradaCostoTotal.Value;

                if (qtyNueva > 0)
                    costoNuevoUnitario = Math.Round(costoNuevoTotal / qtyNueva, 6);
                else
                    costoNuevoUnitario = 0; // Reinicio Promedio
            }
            else // "S" SALIDA
            {
                // REGLA 1: Control Saldo Negativo
                if ((qtyAnterior - dto.Cantidad) < 0 && !dto.ProductoPermiteStockNegativo)
                    throw new Exception($"Stock insuficiente. Saldo disponible: {qtyAnterior}, Solicitado: {dto.Cantidad}");

                // REGLA Promedio Ponderado: La salida asume el último costo promedio
                decimal costoSalidaAplicado = dto.ProductoMetodoValuacion == "PP" ? costoAnteriorUnit : EjecutarMetodoLotes(dto);

                if (costoSalidaAplicado < 0) throw new Exception("Validación SUNAT 3: El costo de salida calculado no puede ser negativo."); // REGLA 3

                movimiento.SalidaCantidad = dto.Cantidad;
                movimiento.SalidaCostoUnitario = costoSalidaAplicado;
                movimiento.SalidaCostoTotal = Math.Round(dto.Cantidad * costoSalidaAplicado, 6);

                qtyNueva = qtyAnterior - dto.Cantidad;
                costoNuevoTotal = Math.Round(costoAnteriorTotal - movimiento.SalidaCostoTotal.Value, 6);

                if (qtyNueva > 0)
                    costoNuevoUnitario = Math.Round(costoNuevoTotal / qtyNueva, 6);
                else
                    costoNuevoUnitario = 0; // Reinicio Promedio
            }

            // Asignar los Saldos Resultantes (Recalculados)
            movimiento.SaldoCantidad = qtyNueva;
            movimiento.SaldoCostoTotal = costoNuevoTotal;
            movimiento.SaldoCostoUnitario = costoNuevoUnitario;

            // REGLA 2: CUADRE MONETARIO (Tolerancia +- 0.01)
            decimal cuadreEsperado = costoAnteriorTotal + (movimiento.EntradaCostoTotal ?? 0) - (movimiento.SalidaCostoTotal ?? 0);
            if (Math.Abs(movimiento.SaldoCostoTotal - cuadreEsperado) > 0.01m)
            {
                throw new Exception($"Inconsistencia de Cuadre Monetario en el Kardex. Diferencia superó 0.01: SaldoGuardado: {movimiento.SaldoCostoTotal} vs Esperado: {cuadreEsperado}");
            }

            // 5. Persistir en la Base de Datos
            await _kardexRepo.AgregarAsync(movimiento);

            // TODO: Si es un registro con fecha retrasada, disparar recálculo retroactivo asíncrono aquí.

            return movimiento;
        }

        private KardexMovimiento ConstruirMovimientoBase(RegistrarMovimientoKardexDto dto, string tpOpe, string periodo)
        {
            return new KardexMovimiento
            {
                Periodo = periodo,
                FechaMovimiento = dto.FechaMovimiento.Date,
                HoraMovimiento = dto.HoraMovimiento,
                FechaHoraCompuesta = dto.FechaMovimiento.Date.Add(dto.HoraMovimiento),
                ModuloOrigen = dto.ModuloOrigen,
                TipoDocumento = dto.TipoDocumento,
                SerieDocumento = dto.SerieDocumento,
                NumeroDocumento = dto.NumeroDocumento,
                TipoOperacion = tpOpe,
                MotivoTrasladoSunat = dto.MotivoTrasladoSunat,
                DescripcionMovimiento = dto.DescripcionMovimiento,
                AlmacenId = dto.AlmacenId,
                AlmacenOrigenId = dto.AlmacenOrigenId,
                AlmacenDestinoId = dto.AlmacenDestinoId,
                ProductoId = dto.ProductoId,
                UnidadMedidaCodigo = dto.UnidadMedidaCodigo,
                FactorConversion = dto.FactorConversion,
                ReferenciaId = dto.ReferenciaId,
                ReferenciaTipo = dto.ReferenciaTipo,
                LoteId = dto.LoteId,
                ProveedorClienteId = dto.ProveedorClienteId,
                Observaciones = dto.Observaciones,
                UsuarioRegistroId = dto.UsuarioRegistroId
            };
        }

        private decimal EjecutarMetodoLotes(RegistrarMovimientoKardexDto dto)
        {
            // TODO: Fase 2 - Implementación de consumo de Lotes FIF/LIFO
            return 0; // Placeholder
        }
    }
}
