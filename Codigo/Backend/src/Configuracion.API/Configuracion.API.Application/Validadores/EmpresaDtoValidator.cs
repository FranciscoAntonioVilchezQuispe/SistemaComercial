using Configuracion.API.Application.DTOs;
using FluentValidation;

namespace Configuracion.API.Application.Validadores
{
    public class EmpresaDtoValidator : AbstractValidator<EmpresaDto>
    {
        public EmpresaDtoValidator()
        {
            RuleFor(x => x.Ruc)
                .NotEmpty().WithMessage("El RUC es obligatorio.")
                .Length(11).WithMessage("El RUC debe tener exactamente 11 dígitos.")
                .Matches("^[0-9]+$").WithMessage("El RUC solo debe contener dígitos.");

            RuleFor(x => x.RazonSocial)
                .NotEmpty().WithMessage("La razón social es obligatoria.")
                .MaximumLength(250).WithMessage("La razón social no debe superar los 250 caracteres.");

            RuleFor(x => x.DireccionFiscal)
                .NotEmpty().WithMessage("La dirección fiscal es obligatoria.")
                .MaximumLength(500).WithMessage("La dirección fiscal no debe superar los 500 caracteres.");

            RuleFor(x => x.CorreoContacto)
                .EmailAddress().WithMessage("El correo electrónico no es válido.")
                .When(x => !string.IsNullOrEmpty(x.CorreoContacto));
        }
    }
}
