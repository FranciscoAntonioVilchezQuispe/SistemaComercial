using Configuracion.API.Application.Consultas;
using Configuracion.API.Application.DTOs;
using Configuracion.API.Application.Interfaces;

namespace Configuracion.API.Application.Manejadores
{
    /// <summary>
    /// Manejador para obtener solo los valores de un catálogo
    /// </summary>
    public class ObtenerValoresCatalogoManejador
    {
        private readonly ITablaGeneralRepositorio _repositorio;

        public ObtenerValoresCatalogoManejador(ITablaGeneralRepositorio repositorio)
        {
            _repositorio = repositorio;
        }

        public async Task<ObtenerValoresCatalogoRespuesta> Handle(ObtenerValoresCatalogoConsulta consulta)
        {
            var valores = await _repositorio.ObtenerValoresPorCodigoAsync(consulta.Codigo, consulta.IncluirInactivos);

            var valoresDto = valores.Select(v => new TablaGeneralDetalleDto
            {
                IdDetalle = v.Id,
                IdTabla = v.IdTablaGeneral,
                Codigo = v.Codigo,
                Nombre = v.Nombre,
                Orden = v.Orden,
                Estado = v.Estado
            }).ToList();

            return new ObtenerValoresCatalogoRespuesta(valoresDto);
        }
    }
}
