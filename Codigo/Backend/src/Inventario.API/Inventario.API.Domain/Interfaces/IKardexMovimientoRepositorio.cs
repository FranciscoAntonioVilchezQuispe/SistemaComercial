using Inventario.API.Domain.Entidades.Kardex;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Inventario.API.Domain.Interfaces
{
    public interface IKardexMovimientoRepositorio
    {
        Task<KardexMovimiento> ObtenerUltimoMovimientoAsync(long almacenId, long productoId, DateTime hastaFecha, TimeSpan hastaHora);
        Task<List<KardexMovimiento>> ObtenerMovimientosDesdeAsync(long almacenId, long productoId, DateTime desdeFecha, TimeSpan desdeHora);
        Task<KardexMovimiento?> ObtenerPorIdAsync(long id);
        Task<List<KardexMovimiento>> ObtenerPorReferenciaAsync(long referenciaId, string referenciaTipo);
        Task AgregarAsync(KardexMovimiento movimiento);
        Task ActualizarAsync(KardexMovimiento movimiento);
        Task BloquearFilaParaCalculoAsync(long almacenId, long productoId);
        Task<(IEnumerable<KardexMovimiento> Datos, int Total)> ObtenerPaginadoAsync(long? idAlmacen, long? idProducto, int pagina, int elementosPorPagina);
    }
}
