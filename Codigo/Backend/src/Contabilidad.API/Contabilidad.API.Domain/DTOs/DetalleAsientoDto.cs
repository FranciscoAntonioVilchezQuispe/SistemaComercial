namespace Contabilidad.API.Domain.DTOs
{
    public class DetalleAsientoDto
    {
        public long Id { get; set; }
        public long IdCuenta { get; set; }
        public string? CuentaCodigo { get; set; }
        public string? CuentaNombre { get; set; }
        public long? IdCentroCosto { get; set; }
        public string? CentroCostoNombre { get; set; }
        public decimal Debe { get; set; }
        public decimal Haber { get; set; }
        public string? Nota { get; set; }
    }
}
