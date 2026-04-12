using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades.Referencias
{
    [Table("tablas_generales_detalle", Schema = "configuracion")]
    public class TipoMovimientoReferencia
    {
        public long Id { get; set; }

        public int IdTabla { get; set; }

        public string Codigo { get; set; } = null!;

        public string Nombre { get; set; } = null!;

        public decimal Factor { get; set; }

        public bool MueveStock { get; set; }
    }
}
