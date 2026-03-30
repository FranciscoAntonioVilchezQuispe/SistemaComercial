using Inventario.API.Application.Consultas;
using Inventario.API.Domain.DTOs;
using Inventario.API.Application.Interfaces;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Dapper;
using System.Threading;
using System.Threading.Tasks;
using System.Data;
using System.Linq;

namespace Inventario.API.Application.Manejadores
{
    public class ObtenerMovimientoInventarioPorIdManejador : IRequestHandler<ObtenerMovimientoInventarioPorIdConsulta, MovimientoDetalleDto?>
    {
        private readonly IInventarioDbContext _context;

        public ObtenerMovimientoInventarioPorIdManejador(IInventarioDbContext context)
        {
            _context = context;
        }

        public async Task<MovimientoDetalleDto?> Handle(ObtenerMovimientoInventarioPorIdConsulta request, CancellationToken cancellationToken)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) connection.Open();

            var sql = @"
                SELECT 
                    m.id_movimiento as Id,
                    m.id_tipo_movimiento,
                    t.nombre as TipoMovimientoNombre,
                    s.id_producto as IdProducto,
                    p.nombre_producto as ProductoNombre,
                    a.nombre_almacen as AlmacenNombre,
                    m.cantidad,
                    m.cantidad_anterior,
                    m.cantidad_nueva,
                    m.costo_unitario_movimiento,
                    m.saldo_cantidad,
                    m.saldo_valorizado,
                    m.costo_promedio_actual,
                    m.referencia_modulo,
                    m.id_referencia,
                    m.observaciones,
                    m.fecha_creacion,
                    m.usuario_creacion
                FROM inventario.movimientos_inventario m
                INNER JOIN inventario.stock s ON s.id_stock = m.id_stock
                INNER JOIN inventario.almacenes a ON a.id_almacen = s.id_almacen
                INNER JOIN catalogo.productos p ON p.id_producto = s.id_producto
                LEFT JOIN configuracion.tablas_generales_detalle t ON t.id_tabla = 6 AND t.id_detalle = m.id_tipo_movimiento
                WHERE m.id_movimiento = @id";

            return await connection.QueryFirstOrDefaultAsync<MovimientoDetalleDto>(sql, new { id = request.Id });
        }
    }
}
