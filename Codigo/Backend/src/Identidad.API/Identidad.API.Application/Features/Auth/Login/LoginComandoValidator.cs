using FluentValidation;

namespace Identidad.API.Application.Features.Auth.Login
{
    public class LoginComandoValidator : AbstractValidator<LoginComando>
    {
        public LoginComandoValidator()
        {
            RuleFor(x => x.Username)
                .NotEmpty().WithMessage("El nombre de usuario es obligatorio.");
                
            RuleFor(x => x.Password)
                .NotEmpty().WithMessage("La contraseña es obligatoria.");
        }
    }
}
