using MediatR;
using System;
using Inventario.API.Application.DTOs.Kardex;

namespace Inventario.API.Application.Consultas.Kardex
{
    public class GenerarReporteKardexConsulta : IRequest<KardexReporteDto>
    {
        public long IdEmpresa { get; set; } // En un ERP full, para filtrar por empresa
        public long IdAlmacen { get; set; }
        public long IdProducto { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaFin { get; set; }
        
        // Opcionales para llenar la cabecera
        public string RucEmpresa { get; set; } = "20000000000";
        public string RazonSocialEmpresa { get; set; } = "EMPRESA COMERCIALIZADORA S.A.";
        
        public GenerarReporteKardexConsulta(long idAlmacen, long idProducto, DateTime fechaInicio, DateTime fechaFin)
        {
            IdAlmacen = idAlmacen;
            IdProducto = idProducto;
            FechaInicio = fechaInicio;
            FechaFin = fechaFin;
        }
    }
}
