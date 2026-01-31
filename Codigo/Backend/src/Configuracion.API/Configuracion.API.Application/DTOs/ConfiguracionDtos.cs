namespace Configuracion.API.Application.DTOs
{
    public class EmpresaDto
    {
        public long Id { get; set; }
        public string Ruc { get; set; } = null!;
        public string RazonSocial { get; set; } = null!;
        public string? NombreComercial { get; set; }
        public string DireccionFiscal { get; set; } = null!;
        public string? Telefono { get; set; }
        public string? CorreoContacto { get; set; }
        public string? SitioWeb { get; set; }
        public string? LogoUrl { get; set; }
        public string MonedaPrincipal { get; set; } = "PEN";
    }

    public class SucursalDto
    {
        public long Id { get; set; }
        public long IdEmpresa { get; set; }
        public string NombreSucursal { get; set; } = null!;
        public string? Direccion { get; set; }
        public string? Telefono { get; set; }
        public bool EsPrincipal { get; set; }
    }

    public class ImpuestoDto
    {
        public long Id { get; set; }
        public string Codigo { get; set; } = null!;
        public string Nombre { get; set; } = null!;
        public decimal Porcentaje { get; set; }
        public bool EsIgv { get; set; }
    }

    public class MetodoPagoDto
    {
        public long Id { get; set; }
        public string Codigo { get; set; } = null!;
        public string Nombre { get; set; } = null!;
        public bool EsEfectivo { get; set; }
        public long? IdTipoDocumentoPago { get; set; }
    }
}
