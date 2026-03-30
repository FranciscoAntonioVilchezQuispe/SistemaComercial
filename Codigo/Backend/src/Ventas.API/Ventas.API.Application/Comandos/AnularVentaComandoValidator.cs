using FluentValidation;

namespace Ventas.API.Application.Comandos
{
    public class AnularVentaComandoValidator : AbstractValidator<AnularVentaComando>
    {
        public AnularVentaComandoValidator()
        {
            RuleFor(x => x.IdVenta)
                .NotEmpty().WithMessage("El ID de la venta es obligatorio.")
                .GreaterThan(0).WithMessage("El ID de la venta debe ser mayor a 0.");

            RuleFor(x => x.Motivo)
                .NotEmpty().WithMessage("El motivo de anulación es obligatorio.")
                .MinimumLength(5).WithMessage("El motivo debe tener al menos 5 caracteres.")
                .MaximumLength(200).WithMessage("El motivo no debe superar 200 caracteres.");
        }
    }
}
