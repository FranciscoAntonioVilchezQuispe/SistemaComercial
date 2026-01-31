using Configuracion.API.Application.Consultas;
using Configuracion.API.Application.DTOs;
using Configuracion.API.Application.Interfaces;

namespace Configuracion.API.Application.Manejadores
{
    /// <summary>
    /// Manejador para obtener un catálogo completo por código
    /// </summary>
    public class ObtenerCatalogoPorCodigoManejador
    {
        private readonly ITablaGeneralRepositorio _repositorio;

        public ObtenerCatalogoPorCodigoManejador(ITablaGeneralRepositorio repositorio)
        {
            _repositorio = repositorio;
        }

        public async Task<ObtenerCatalogoPorCodigoRespuesta> Handle(ObtenerCatalogoPorCodigoConsulta consulta)
        {
            var catalogo = await _repositorio.ObtenerPorCodigoAsync(consulta.Codigo, consulta.IncluirInactivos);

            if (catalogo == null)
            {
                return new ObtenerCatalogoPorCodigoRespuesta(null);
            }

            var catalogoDto = new TablaGeneralDto
            {
                IdTabla = catalogo.Id,
                Codigo = catalogo.Codigo,
                Nombre = catalogo.Nombre,
                Descripcion = catalogo.Descripcion,
                EsSistema = catalogo.EsSistema,
                CantidadValores = catalogo.Detalles.Count
            };

            var valoresDto = catalogo.Detalles
                .OrderBy(d => d.Orden)
                .ThenBy(d => d.Nombre)
                .Select(d => new TablaGeneralDetalleDto
                {
                    IdDetalle = d.Id,
                    IdTabla = d.IdTablaGeneral,
                    Codigo = d.Codigo,
                    Nombre = d.Nombre,
                    Orden = d.Orden,
                    Estado = d.Estado
                }).ToList();

            var catalogoCompleto = new CatalogoCompletoDto
            {
                Catalogo = catalogoDto,
                Valores = valoresDto
            };

            return new ObtenerCatalogoPorCodigoRespuesta(catalogoCompleto);
        }
    }
}
