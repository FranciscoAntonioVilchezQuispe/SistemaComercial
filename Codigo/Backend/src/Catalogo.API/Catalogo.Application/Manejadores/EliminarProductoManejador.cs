using Catalogo.Application.Comandos;
using Catalogo.Domain.Interfaces;
using MediatR;
using System.Threading;
using System.Threading.Tasks;

namespace Catalogo.Application.Manejadores
{
    public class EliminarProductoManejador : IRequestHandler<EliminarProductoComando, bool>
    {
        private readonly IProductoRepositorio _repositorio;

        public EliminarProductoManejador(IProductoRepositorio repositorio)
        {
            _repositorio = repositorio;
        }

        public async Task<bool> Handle(EliminarProductoComando request, CancellationToken cancellationToken)
        {
            var producto = await _repositorio.ObtenerPorIdAsync(request.Id);
            if (producto == null) return false;

            // Borrado lógico: desactiva el producto sin eliminarlo físicamente
            producto.Activado = false;
            await _repositorio.ActualizarAsync(producto);
            return true;
        }
    }
}
