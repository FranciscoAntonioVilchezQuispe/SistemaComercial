using Inventario.API.Application.DTOs;
using Inventario.API.Domain.Entidades.Kardex;
using System.Threading.Tasks;

namespace Inventario.API.Application.Interfaces
{
    public interface IKardexService
    {
        Task<KardexMovimiento> RegistrarEntradaAsync(RegistrarMovimientoKardexDto dto);
        Task<KardexMovimiento> RegistrarSalidaAsync(RegistrarMovimientoKardexDto dto);
        Task AnularMovimientoAsync(long movimientoId, string motivoAnulacion, long usuarioId);
    }
}
