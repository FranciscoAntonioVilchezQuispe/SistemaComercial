using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Entidades.Kardex;
using Inventario.API.Domain.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace Inventario.API.Infrastructure.Repositorios
{
    public class KardexPeriodoControlRepositorio : IKardexPeriodoControlRepositorio
    {
        private readonly IInventarioDbContext _context;

        public KardexPeriodoControlRepositorio(IInventarioDbContext context)
        {
            _context = context;
        }

        public async Task ActualizarAsync(KardexPeriodoControl periodoControl)
        {
            _context.KardexPeriodosControl.Update(periodoControl);
            await _context.SaveChangesAsync(default);
        }

        public async Task AgregarAsync(KardexPeriodoControl periodoControl)
        {
            await _context.KardexPeriodosControl.AddAsync(periodoControl);
            await _context.SaveChangesAsync(default);
        }

        public async Task<bool> EstaPeriodoCerradoAsync(string periodo)
        {
            var p = await _context.KardexPeriodosControl.FirstOrDefaultAsync(x => x.Periodo == periodo);
            return p != null && p.Estado == "C";
        }

        public async Task<KardexPeriodoControl?> ObtenerPorPeriodoAsync(string periodo)
        {
            return await _context.KardexPeriodosControl.FirstOrDefaultAsync(x => x.Periodo == periodo);
        }
    }
}
