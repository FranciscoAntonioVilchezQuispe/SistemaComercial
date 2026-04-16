using Compras.API.Domain.DTOs;
using Compras.API.Domain.Entidades;
using Compras.API.Domain.DTOs.Reportes;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Compras.API.Domain.Interfaces
{
    public interface ICompraRepositorio
    {
        Task<CompraDetalleDto?> ObtenerDetallePorIdAsync(long id);
        Task<Compra?> ObtenerPorIdAsync(long id); // Auditoría y escrituras internas
        Task<Compra> AgregarAsync(Compra compra);
        Task<IEnumerable<Compra>> ObtenerTodosAsync();
        Task<IEnumerable<Compra>> ObtenerPorProveedorAsync(long idProveedor);
        Task<(IEnumerable<CompraListDto> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, int pagina, int elementosPorPagina);
        Task<IEnumerable<CompraProveedorDto>> ObtenerComprasPorProveedorAsync(DateTime fechaInicio, DateTime fechaFin, int top);
    }
}
