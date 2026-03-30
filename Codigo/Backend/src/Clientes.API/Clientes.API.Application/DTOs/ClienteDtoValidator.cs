using FluentValidation;

namespace Clientes.API.Application.DTOs
{
    public class CrearClienteDtoValidator : AbstractValidator<CrearClienteDto>
    {
        public CrearClienteDtoValidator()
        {
            RuleFor(x => x.IdTipoDocumento)
                .NotEmpty().WithMessage("El tipo de documento es obligatorio.");

            RuleFor(x => x.NumeroDocumento)
                .NotEmpty().WithMessage("El número de documento es obligatorio.")
                .Must((dto, numero) => ValidarLongitudDocumento(dto.IdTipoDocumento, numero))
                .WithMessage("La longitud del documento no es válida para el tipo seleccionado.")
                .Must((dto, numero) => ValidarFormatoDocumento(dto.IdTipoDocumento, numero))
                .WithMessage("El formato del documento no es válido.");

            RuleFor(x => x.RazonSocial)
                .NotEmpty().WithMessage("La razón social o nombre es obligatorio.")
                .MaximumLength(250).WithMessage("La razón social no debe superar los 250 caracteres.");

            RuleFor(x => x.Email)
                .EmailAddress().WithMessage("El formato de correo electrónico no es válido.")
                .When(x => !string.IsNullOrEmpty(x.Email));

            // Validaciones SUNAT (DNI/RUC)
            RuleFor(x => x.NumeroDocumento)
                .Must(ValidarRuc).WithMessage("El RUC no es válido (dígito verificador incorrecto).")
                .When(x => x.IdTipoDocumento == 6); // RUC

            RuleFor(x => x.NumeroDocumento)
                .Matches("^[0-9]{8}$").WithMessage("El DNI debe tener exactamente 8 dígitos.")
                .When(x => x.IdTipoDocumento == 1); // DNI
        }

        private bool ValidarLongitudDocumento(long idTipoDoc, string numero)
        {
            if (string.IsNullOrEmpty(numero)) return false;
            return idTipoDoc switch
            {
                1 => numero.Length == 8,  // DNI
                6 => numero.Length == 11, // RUC
                _ => numero.Length >= 1 && numero.Length <= 20
            };
        }

        private bool ValidarFormatoDocumento(long idTipoDoc, string numero)
        {
            if (string.IsNullOrEmpty(numero)) return false;
            return idTipoDoc switch
            {
                1 => System.Text.RegularExpressions.Regex.IsMatch(numero, "^[0-9]+$"),
                6 => System.Text.RegularExpressions.Regex.IsMatch(numero, "^[0-9]+$"),
                _ => true
            };
        }

        private bool ValidarRuc(string ruc)
        {
            if (string.IsNullOrEmpty(ruc) || ruc.Length != 11 || !long.TryParse(ruc, out _))
                return false;

            int[] factores = { 5, 4, 3, 2, 7, 6, 5, 4, 3, 2 };
            int suma = 0;

            for (int i = 0; i < 10; i++)
            {
                suma += (ruc[i] - '0') * factores[i];
            }

            int residuo = suma % 11;
            int verificadorObtenido = 11 - residuo;

            if (verificadorObtenido == 10) verificadorObtenido = 0;
            if (verificadorObtenido == 11) verificadorObtenido = 1;

            return verificadorObtenido == (ruc[10] - '0');
        }
    }

    public class ClienteDtoValidator : AbstractValidator<ClienteDto>
    {
        public ClienteDtoValidator()
        {
            Include(new CrearClienteDtoValidator());
            RuleFor(x => x.Id).NotEmpty().WithMessage("El ID es obligatorio para actualizaciones.");
        }
    }
}
