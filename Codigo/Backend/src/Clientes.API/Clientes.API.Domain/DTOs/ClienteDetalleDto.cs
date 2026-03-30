using System;
using System.Collections.Generic;

namespace Clientes.API.Domain.DTOs
{
    /// <summary>
    /// DTO detallado para la ficha del socio de negocio (Clientes).
    /// Incluye datos SUNAT, líneas de crédito, contactos y direcciones.
    /// </summary>
    public class ClienteDetalleDto
    {
        public long Id { get; set; }
        public long IdTipoDocumento { get; set; }
        public string? TipoDocumentoNombre { get; set; }
        public string NumeroDocumento { get; set; } = null!;
        public string RazonSocial { get; set; } = null!;
        public string? NombreComercial { get; set; }
        public string? Direccion { get; set; }
        public string? Telefono { get; set; }
        public string? Email { get; set; }
        
        // Configuración de Negocio
        public long? IdTipoCliente { get; set; }
        public string? TipoClienteNombre { get; set; }
        public decimal? LimiteCredito { get; set; }
        public int? DiasCredito { get; set; }
        public long? IdListaPrecioAsignada { get; set; }
        
        // --- Campos SUNAT UBL 2.1 / Auditoría Fiscal ---
        public string? Ubigeo { get; set; }
        public string? CondicionSunat { get; set; }
        public string? EstadoSunat { get; set; }
        public bool EsAgenteRetencion { get; set; }
        public bool EsBuenContribuyente { get; set; }
        public bool EsAgentePercepcion { get; set; }
        public DateTime? FechaUltimaConsultaSunat { get; set; }
        
        // Colecciones Anidadas
        public List<ContactoClienteDto> Contactos { get; set; } = new();

        public bool Activado { get; set; }
    }
}
