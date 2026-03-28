using System.Collections.Generic;
using System.Threading.Tasks;
using Configuracion.API.Domain.DTOs;

namespace Configuracion.API.Domain.Interfaces
{
    public interface IUbigeoRepository
    {
        Task<IEnumerable<UbigeoItemDto>> GetDepartamentosAsync();
        Task<IEnumerable<UbigeoItemDto>> GetProvinciasByDepartamentoAsync(string codigoDept);
        Task<IEnumerable<UbigeoItemDto>> GetDistritosByProvinciaAsync(string codigoProv);
        Task<UbigeoDetalleDto?> GetDetalleByCodigoAsync(string codigo6);
        Task<IEnumerable<UbigeoSearchResultDto>> SearchAsync(string termino, int limit = 15);
    }
}
