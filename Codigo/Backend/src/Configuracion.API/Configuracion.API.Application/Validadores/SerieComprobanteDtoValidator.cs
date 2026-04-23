using Configuracion.API.Application.DTOs;
using FluentValidation;

namespace Configuracion.API.Application.Validadores
{
    public class SerieComprobanteDtoValidator : AbstractValidator<SerieComprobanteDto>
    {
        public SerieComprobanteDtoValidator()
        {
            RuleFor(x => x.Serie)
                .NotEmpty().WithMessage("La serie es obligatoria.")
                .Length(4).WithMessage("La serie debe tener exactamente 4 caracteres.")
                .Matches(@"^[FBCET][A-Z0-9]{3}$").WithMessage("La serie no tiene el formato válido (ej: F001, B001, FC01).");

            RuleFor(x => x.IdTipoComprobante)
                .GreaterThan(0).WithMessage("El tipo de comprobante es obligatorio.");

            RuleFor(x => x.CorrelativoActual)
                .GreaterThanOrEqualTo(0).WithMessage("El correlativo actual no puede ser negativo.");
        }
    }
}
