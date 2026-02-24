using Configuracion.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Domain.Interfaces
{
    public interface IMatrizReglaSunatRepositorio
    {
        Task<IEnumerable<MatrizReglaSunat>> ObtenerTodasAsync();
        Task<IEnumerable<MatrizReglaSunat>> ObtenerPorOperacionAsync(string codigoOperacion);
        Task<MatrizReglaSunat?> ObtenerPorIdAsync(long id);
        Task<MatrizReglaSunat> AgregarAsync(MatrizReglaSunat matrizRegla);
        Task ActualizarAsync(MatrizReglaSunat matrizRegla);
        Task EliminarAsync(long id);
    }
}
