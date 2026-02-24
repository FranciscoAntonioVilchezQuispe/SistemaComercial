using System;
using System.Threading.Tasks;

namespace Inventario.API.Application.DTOs
{
    public class RegistrarMovimientoKardexDto
    {
        // Documento
        public string ModuloOrigen { get; set; } = null!;
        public string TipoDocumento { get; set; } = null!; // 01, 03...
        public string SerieDocumento { get; set; } = null!;
        public string NumeroDocumento { get; set; } = null!;
        
        // Operación
        public string TipoOperacion { get; set; } = null!; // 'E' o 'S'
        public string MotivoTrasladoSunat { get; set; } = null!; // 01, 02, 04...
        public string DescripcionMovimiento { get; set; } = null!;

        // Base
        public long AlmacenId { get; set; }
        public long ProductoId { get; set; }
        public string UnidadMedidaCodigo { get; set; } = null!; // 'NIU', 'KG'
        public decimal FactorConversion { get; set; } = 1;

        // Trazabilidad Opcional
        public long? AlmacenOrigenId { get; set; }
        public long? AlmacenDestinoId { get; set; }
        public long? ReferenciaId { get; set; }
        public string? ReferenciaTipo { get; set; }
        public long? LoteId { get; set; }
        public long? ProveedorClienteId { get; set; }
        public string? Observaciones { get; set; }

        // Auditoría
        public long UsuarioRegistroId { get; set; }
        public DateTime FechaMovimiento { get; set; }
        public TimeSpan HoraMovimiento { get; set; }

        // Valores
        public decimal Cantidad { get; set; }
        
        // SOLO si es una ENTRADA importa el costo; en salidas el kardex lo determina
        public decimal? CostoUnitarioIngreso { get; set; }

        // Validaciones internas obligatorias (Producto)
        public bool ProductoPermiteStockNegativo { get; set; }
        public string ProductoMetodoValuacion { get; set; } = "PP"; // PP, PE, UE
    }
}
