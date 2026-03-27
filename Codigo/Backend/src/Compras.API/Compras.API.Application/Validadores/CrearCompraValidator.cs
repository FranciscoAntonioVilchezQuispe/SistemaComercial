using Compras.API.Application.Comandos;
using Compras.API.Application.Interfaces;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace Compras.API.Application.Validadores
{
    public class CrearCompraValidator : AbstractValidator<CrearCompraComando>
    {
        private readonly IComprasDbContext _context;

        public CrearCompraValidator(IComprasDbContext context)
        {
            _context = context;

            RuleFor(x => x.Compra.IdProveedor)
                .NotEmpty().WithMessage("El proveedor es obligatorio.");

            RuleFor(x => x.Compra.IdTipoComprobante)
                .NotEmpty().WithMessage("El tipo de comprobante es obligatorio.");

            RuleFor(x => x.Compra.SerieComprobante)
                .NotEmpty().WithMessage("La serie del comprobante es obligatoria.");

            RuleFor(x => x.Compra.NumeroComprobante)
                .NotEmpty().WithMessage("El número del comprobante es obligatorio.");

            RuleFor(x => x.Compra)
                .MustAsync(BeUniquePurchase)
                .WithMessage("Ya existe una compra registrada con el mismo RUC, Tipo, Serie y Número de Comprobante.");
        }

        private async Task<bool> BeUniquePurchase(DTOs.CompraDto compraDto, CancellationToken cancellationToken)
        {
            // Obtener el RUC del proveedor seleccionado para la validación
            var proveedor = await _context.Proveedores
                .AsNoTracking()
                .FirstOrDefaultAsync(p => p.Id == compraDto.IdProveedor, cancellationToken);

            if (proveedor == null) return true; // El error de proveedor inexistente lo capturará otra regla

            var existe = await _context.Compras
                .Include(c => c.Proveedor)
                .AnyAsync(c => c.Proveedor.NumeroDocumento == proveedor.NumeroDocumento
                            && c.IdTipoComprobante == compraDto.IdTipoComprobante
                            && c.SerieComprobante == compraDto.SerieComprobante
                            && c.NumeroComprobante == compraDto.NumeroComprobante
                            && c.Activado, cancellationToken);

            return !existe;
        }
    }
}
