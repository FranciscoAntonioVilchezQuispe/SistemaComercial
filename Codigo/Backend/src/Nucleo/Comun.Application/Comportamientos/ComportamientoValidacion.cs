using FluentValidation;
using MediatR;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Nucleo.Comun.Application.Comportamientos
{
    public class ComportamientoValidacion<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
        where TRequest : IRequest<TResponse>
    {
        private readonly IEnumerable<IValidator<TRequest>> _validadores;

        public ComportamientoValidacion(IEnumerable<IValidator<TRequest>> validadores)
        {
            _validadores = validadores;
        }

        public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
        {
            if (_validadores.Any())
            {
                var contexto = new ValidationContext<TRequest>(request);
                var resultadosValidacion = await Task.WhenAll(_validadores.Select(v => v.ValidateAsync(contexto, cancellationToken)));
                var errores = resultadosValidacion.Where(r => r.Errors.Any()).SelectMany(r => r.Errors).ToList();

                if (errores.Any())
                {
                    throw new ValidationException(errores);
                }
            }

            return await next();
        }
    }
}
