using Configuracion.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Domain.Interfaces
{
    public interface IEmpresaRepositorio
    {
        Task<Empresa?> ObtenerActualAsync();
        Task ActualizarAsync(Empresa empresa);
    }

    public interface ISucursalRepositorio
    {
        Task<Sucursal?> ObtenerPorIdAsync(long id);
        Task<Sucursal> AgregarAsync(Sucursal sucursal);
        Task ActualizarAsync(Sucursal sucursal);
        Task<IEnumerable<Sucursal>> ObtenerTodasAsync();
        Task<(IEnumerable<Sucursal> Datos, int Total)> ObtenerPaginadoAsync(string? search, bool? activo, int pageNumber, int pageSize);
        Task EliminarAsync(long id);
    }
}
