namespace Configuracion.API.Domain.DTOs
{
    public record UbigeoItemDto(string Codigo, string Nombre);

    public record UbigeoDetalleDto(
        string Codigo,
        string Distrito,
        string CodigoProvincia,
        string Provincia,
        string CodigoDepartamento,
        string Departamento,
        string TextoCompleto
    );

    public record UbigeoSearchResultDto(
        string Codigo,
        string Nombre,
        string Provincia,
        string Departamento,
        string TextoCompleto
    );
}
