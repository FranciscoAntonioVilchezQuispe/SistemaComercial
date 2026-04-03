using Clientes.API.Domain.Entidades;
using Clientes.API.Domain.Interfaces;
using Clientes.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Dapper;
using Clientes.API.Domain.DTOs;
using System.Data;

namespace Clientes.API.Infrastructure.Repositorios
{
    public class ClienteRepositorio : IClienteRepositorio
    {
        private readonly ClientesDbContext _context;

        public ClienteRepositorio(ClientesDbContext context)
        {
            _context = context;
        }

        public async Task<ClienteDetalleDto?> ObtenerDetallePorIdAsync(long id)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();

            var sql = @"
                -- Cabecera de Cliente
                SELECT c.id_cliente as Id, c.id_tipo_documento, td.nombre as TipoDocumentoNombre,
                       c.numero_documento, c.razon_social, c.nombre_comercial, c.direccion,
                       c.telefono, c.email, c.id_tipo_cliente, c.limite_credito, c.dias_credito,
                       c.id_lista_precio_asignada, c.ubigeo, c.condicion_sunat, c.estado_sunat,
                       c.es_agente_retencion, c.es_buen_contribuyente, c.es_agente_percepcion,
                       c.fecha_ultima_consulta_sunat, c.activado
                FROM clientes.clientes c
                LEFT JOIN configuracion.tipo_documento td ON td.id_regla = c.id_tipo_documento
                WHERE c.id_cliente = @id;

                -- Contactos
                SELECT id_contacto as Id, nombres, cargo, telefono, email
                FROM clientes.contactos_cliente
                WHERE id_cliente = @id;";

            using var multi = await connection.QueryMultipleAsync(sql, new { id });
            var cliente = await multi.ReadFirstOrDefaultAsync<ClienteDetalleDto>();
            if (cliente != null)
            {
                cliente.Contactos = (await multi.ReadAsync<ContactoClienteDto>()).ToList();
            }

            return cliente;
        }

        public async Task<Cliente?> ObtenerPorIdAsync(long id)
        {
            return await _context.Clientes
                .Include(c => c.Contactos)
                .FirstOrDefaultAsync(c => c.Id == id);
        }

        public async Task<Cliente> AgregarAsync(Cliente cliente)
        {
            _context.Clientes.Add(cliente);
            await _context.SaveChangesAsync();
            return cliente;
        }

        public async Task ActualizarAsync(Cliente cliente)
        {
            _context.Entry(cliente).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var cliente = await _context.Clientes.FindAsync(id);
            if (cliente != null)
            {
                _context.Clientes.Remove(cliente);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<Cliente>> ObtenerTodosAsync(string? busqueda = null)
        {
            return await _context.Clientes
                .Where(c => string.IsNullOrEmpty(busqueda) || 
                            c.RazonSocial.ToLower().Contains(busqueda.ToLower()) || 
                            c.NumeroDocumento.Contains(busqueda))
                .Take(100)
                .ToListAsync();
        }

        public async Task<(IEnumerable<ClienteListDto> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();

            var offset = (pageNumber - 1) * pageSize;
            var sql = @"
                SELECT c.id_cliente as Id, c.id_tipo_documento, td.nombre as TipoDocumentoNombre,
                       c.numero_documento, c.razon_social, c.email, c.telefono, c.activado,
                       COUNT(*) OVER() AS TotalRegistros
                FROM clientes.clientes c
                LEFT JOIN configuracion.tipo_documento td ON td.id_regla = c.id_tipo_documento
                WHERE (@search IS NULL OR 
                       c.razon_social ILIKE '%' || @search || '%' OR 
                       c.numero_documento ILIKE '%' || @search || '%')
                ORDER BY c.razon_social ASC
                LIMIT @pageSize OFFSET @offset;";

            var parameters = new { search, pageSize, offset };
            var rows = await connection.QueryAsync<ClienteListDto>(sql, parameters);
            
            var total = rows.FirstOrDefault()?.TotalRegistros ?? 0;
            return (rows, total);
        }
    }
}
