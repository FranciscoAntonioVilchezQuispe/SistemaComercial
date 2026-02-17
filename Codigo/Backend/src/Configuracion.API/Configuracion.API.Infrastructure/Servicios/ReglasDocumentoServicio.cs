using Configuracion.API.Application.Interfaces;
using Configuracion.API.Domain.Entidades;
using Configuracion.API.Infrastructure.Datos;
using Configuracion.API.Application.DTOs;
using Microsoft.EntityFrameworkCore;

using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System;

namespace Configuracion.API.Infrastructure.Servicios
{

    public class ReglasDocumentoServicio : IReglasDocumentoServicio

    {
        private readonly ConfiguracionDbContext _context;

        public ReglasDocumentoServicio(ConfiguracionDbContext context)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
        }


        public async Task<ReglasYRelacionesResponse> ObtenerReglasYRelacionesAsync()
        {
            var reglas = await _context.DocumentoIdentidadReglas
                .AsNoTracking()
                .Where(r => r.Estado && r.Activado)
                .ToListAsync();

            var relaciones = await _context.DocumentoComprobanteRelaciones
                .AsNoTracking()
                .Where(r => r.Activado)
                .ToListAsync();

            return new ReglasYRelacionesResponse
            {
                Reglas = reglas,
                Relaciones = relaciones
            };
        }


        public async Task<IEnumerable<DocumentoIdentidadRegla>> ListarReglasAsync()
        {
            return await _context.DocumentoIdentidadReglas.AsNoTracking().ToListAsync();
        }

        public async Task<DocumentoIdentidadRegla?> ObtenerReglaPorIdAsync(long id)
        {
            return await _context.DocumentoIdentidadReglas.FindAsync(id);
        }

        public async Task<DocumentoIdentidadRegla> GuardarReglaAsync(DocumentoIdentidadRegla regla)
        {
            if (regla.Id > 0)
            {
                _context.DocumentoIdentidadReglas.Update(regla);
            }
            else
            {
                _context.DocumentoIdentidadReglas.Add(regla);
            }
            await _context.SaveChangesAsync();
            return regla;
        }

        public async Task<bool> EliminarReglaAsync(long id)
        {
            var regla = await _context.DocumentoIdentidadReglas.FindAsync(id);
            if (regla == null) return false;

            _context.DocumentoIdentidadReglas.Remove(regla);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<IEnumerable<DocumentoComprobanteRelacion>> ListarRelacionesPorDocumentoAsync(string codigoDocumento)
        {
            return await _context.DocumentoComprobanteRelaciones
                .AsNoTracking()
                .Where(r => r.CodigoDocumento == codigoDocumento)
                .ToListAsync();
        }

        public async Task<bool> ActualizarRelacionesAsync(string codigoDocumento, List<long> idsTiposComprobante)
        {
            if (string.IsNullOrEmpty(codigoDocumento)) return false;
            idsTiposComprobante ??= new List<long>();

            var relacionesActuales = await _context.DocumentoComprobanteRelaciones
                .AsNoTracking()
                .Where(r => r.CodigoDocumento == codigoDocumento)
                .ToListAsync();

            if (relacionesActuales.Any())
            {
                _context.DocumentoComprobanteRelaciones.RemoveRange(relacionesActuales);
            }

            var nuevasRelaciones = idsTiposComprobante.Select(id => new DocumentoComprobanteRelacion
            {
                CodigoDocumento = codigoDocumento,
                IdTipoComprobante = id,
                Activado = true,
                UsuarioCreacion = "SISTEMA",
                FechaCreacion = DateTime.UtcNow
            }).ToList();

            if (nuevasRelaciones.Any())
            {
                await _context.DocumentoComprobanteRelaciones.AddRangeAsync(nuevasRelaciones);
            }

            await _context.SaveChangesAsync();
            return true;
        }

    }
}
