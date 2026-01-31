using Configuracion.API.Domain.Entidades;

namespace Configuracion.API.Application.Interfaces
{
    /// <summary>
    /// Interfaz para el repositorio de TablaGeneral
    /// </summary>
    public interface ITablaGeneralRepositorio
    {
        /// <summary>
        /// Obtiene todos los catálogos activos
        /// </summary>
        Task<List<TablaGeneral>> ObtenerTodosAsync();

        /// <summary>
        /// Obtiene un catálogo por su código incluyendo sus valores
        /// </summary>
        Task<TablaGeneral?> ObtenerPorCodigoAsync(string codigo, bool incluirInactivos = false);

        /// <summary>
        /// Obtiene solo los valores de un catálogo por código
        /// </summary>
        Task<List<TablaGeneralDetalle>> ObtenerValoresPorCodigoAsync(string codigo, bool incluirInactivos = false);

        /// <summary>
        /// Obtiene un valor específico por su ID
        /// </summary>
        Task<TablaGeneralDetalle?> ObtenerValorPorIdAsync(long idDetalle);

        Task<TablaGeneral?> ObtenerPorIdAsync(long id);
        Task<TablaGeneral> AgregarAsync(TablaGeneral entidad);
        Task ActualizarAsync(TablaGeneral entidad);
        Task EliminarAsync(long id);

        Task<TablaGeneralDetalle> AgregarDetalleAsync(TablaGeneralDetalle entidad);
        Task ActualizarDetalleAsync(TablaGeneralDetalle entidad);
        Task EliminarDetalleAsync(long id);
    }
}
