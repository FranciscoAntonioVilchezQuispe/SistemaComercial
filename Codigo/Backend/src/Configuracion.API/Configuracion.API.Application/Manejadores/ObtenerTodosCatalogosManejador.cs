using Configuracion.API.Application.Consultas;
using Configuracion.API.Application.DTOs;
using Configuracion.API.Application.Interfaces;

namespace Configuracion.API.Application.Manejadores
{
    /// <summary>
    /// Manejador para obtener todos los catálogos
    /// </summary>
    public class ObtenerTodosCatalogosManejador
    {
        private readonly ITablaGeneralRepositorio _repositorio;

        public ObtenerTodosCatalogosManejador(ITablaGeneralRepositorio repositorio)
        {
            _repositorio = repositorio;
        }

        public async Task<ObtenerTodosCatalogosRespuesta> Handle(ObtenerTodosCatalogosConsulta consulta)
        {
            var catalogos = await _repositorio.ObtenerTodosAsync();

            var catalogosDto = catalogos.Select(c => new TablaGeneralDto
            {
                IdTabla = c.Id,
                Codigo = c.Codigo,
                Nombre = c.Nombre,
                Descripcion = c.Descripcion,
                EsSistema = c.EsSistema,
                CantidadValores = c.Detalles.Count
            }).ToList();

            return new ObtenerTodosCatalogosRespuesta(catalogosDto);
        }
    }
}
