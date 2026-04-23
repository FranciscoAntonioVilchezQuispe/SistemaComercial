using FluentValidation;
using Inventario.API.Application.Comandos;

namespace Inventario.API.Application.Validators
{
    public class CrearMovimientoInventarioComandoValidator : AbstractValidator<CrearMovimientoInventarioComando>
    {
        public CrearMovimientoInventarioComandoValidator()
        {
            RuleFor(x => x.IdProducto)
                .NotEmpty().WithMessage("El producto es obligatorio.");

            RuleFor(x => x.IdAlmacen)
                .NotEmpty().WithMessage("El almacén es obligatorio.");

            RuleFor(x => x.IdTipoMovimiento)
                .NotEmpty().WithMessage("El tipo de movimiento es obligatorio.");

            RuleFor(x => x.Cantidad)
                .GreaterThan(0).WithMessage("La cantidad debe ser mayor a cero.");

            RuleFor(x => x.CostoUnitario)
                .GreaterThanOrEqualTo(0).WithMessage("El costo unitario no puede ser negativo.")
                .When(x => x.CostoUnitario.HasValue);
                
            RuleFor(x => x.SerieDocumento)
                .Matches(@"^[FBCET][A-Z0-9]{3}$").WithMessage("La serie no tiene el formato válido (ej: F001, B001).")
                .When(x => !string.IsNullOrEmpty(x.SerieDocumento));
        }
    }
}
