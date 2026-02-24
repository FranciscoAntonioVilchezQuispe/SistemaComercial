using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Entidades.Kardex;
using Inventario.API.Domain.Interfaces;
using System.Threading.Tasks;

namespace Inventario.API.Infrastructure.Repositorios
{
    public class KardexRecalculoLogRepositorio : IKardexRecalculoLogRepositorio
    {
        private readonly IInventarioDbContext _context;

        public KardexRecalculoLogRepositorio(IInventarioDbContext context)
        {
            _context = context;
        }

        public async Task AgregarAsync(KardexRecalculoLog log)
        {
            await _context.KardexRecalculoLogs.AddAsync(log);
            await _context.SaveChangesAsync(default);
        }
    }
}
