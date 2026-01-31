namespace Catalogo.Application.DTOs
{
    public class CrearListaPrecioDto
    {
        public string NombreLista { get; set; } = null!;
        public bool EsBase { get; set; } = false;
        public decimal? PorcentajeGananciaSugerido { get; set; }
    }

    public class ListaPrecioDto : CrearListaPrecioDto
    {
        public long Id { get; set; }
    }
}
