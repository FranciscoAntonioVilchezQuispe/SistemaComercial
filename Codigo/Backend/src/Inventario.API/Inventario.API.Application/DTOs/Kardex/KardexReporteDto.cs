using System;
using System.Collections.Generic;

namespace Inventario.API.Application.DTOs.Kardex
{
    public class KardexReporteDto
    {
        // Cabecera del Formato 13.1 (Libro de Inventarios y Balances - Registro de Inventario Permanente Valorizado)
        public string Periodo { get; set; } = string.Empty;
        public string RucEmpresa { get; set; } = string.Empty;
        public string RazonSocialEmpresa { get; set; } = string.Empty;
        
        public string Establecimiento { get; set; } = string.Empty;
        public string CodigoExistencia { get; set; } = string.Empty;
        public string TipoExistencia { get; set; } = string.Empty; // Tabla 5 (01: Mercaderia, 02: Prod Terminados...)
        public string DescripcionExistencia { get; set; } = string.Empty;
        public string CodigoUnidadMedida { get; set; } = string.Empty; // Tabla 6 (NIU: Unidades, KGM: Kilogramos...)
        public string MetodoValuacion { get; set; } = "1"; // Tabla 14 (1: Primeras Entradas Primeras Salidas, 9: Promedio PP)

        public List<KardexReporteItemDto> Detalles { get; set; } = new List<KardexReporteItemDto>();
    }

    public class KardexReporteItemDto
    {
        // 1. Fecha
        public DateTime Fecha { get; set; }

        // 2. Documento de Traslado, Comprobante de Pago, Documento Interno o Similar
        public string TipoDocumentoSunat { get; set; } = string.Empty; // Tabla 10
        public string SerieDocumento { get; set; } = string.Empty;
        public string NumeroDocumento { get; set; } = string.Empty;

        // 3. Tipo de Operación
        public string TipoOperacionSunat { get; set; } = string.Empty; // Tabla 12 (01=Venta, 02=Compra, 11=Traslado)
        
        // 4. Entradas
        public decimal EntradaCantidad { get; set; }
        public decimal EntradaCostoUnitario { get; set; }
        public decimal EntradaCostoTotal { get; set; }

        // 5. Salidas
        public decimal SalidaCantidad { get; set; }
        public decimal SalidaCostoUnitario { get; set; }
        public decimal SalidaCostoTotal { get; set; }

        // 6. Saldo Final
        public decimal SaldoCantidad { get; set; }
        public decimal SaldoCostoUnitario { get; set; }
        public decimal SaldoCostoTotal { get; set; }
    }
}
