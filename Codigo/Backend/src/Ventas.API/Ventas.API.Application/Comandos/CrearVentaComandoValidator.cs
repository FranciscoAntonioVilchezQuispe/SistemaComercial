using FluentValidation;

namespace Ventas.API.Application.Comandos
{
    public class CrearVentaComandoValidator : AbstractValidator<CrearVentaComando>
    {
        public CrearVentaComandoValidator()
        {
            RuleFor(x => x.Venta)
                .NotNull().WithMessage("Los datos de la venta son obligatorios.");

            When(x => x.Venta != null, () =>
            {
                RuleFor(x => x.Venta.IdAlmacen)
                    .NotEmpty().WithMessage("El almacén es obligatorio.");

                RuleFor(x => x.Venta.IdCliente)
                    .NotEmpty().WithMessage("El cliente es obligatorio.");

                RuleFor(x => x.Venta.IdTipoComprobante)
                    .NotEmpty().WithMessage("El tipo de comprobante es obligatorio.");

                RuleFor(x => x.Venta.Serie)
                    .NotEmpty().WithMessage("La serie del comprobante es obligatoria.")
                    .Matches(@"^[FBCET][A-Z0-9]{3}$").WithMessage("La serie no tiene el formato válido (ej: F001, B001, FC01).");

                RuleFor(x => x.Venta.TotalVenta)
                    .GreaterThan(0).WithMessage("El total de la venta debe ser mayor a 0.");

                RuleFor(x => x.Venta.Moneda)
                    .NotEmpty().WithMessage("La moneda es obligatoria.")
                    .Length(3).WithMessage("El código de moneda debe ser de 3 caracteres (ej: PEN).");

                RuleFor(x => x.Venta.Detalles)
                    .NotEmpty().WithMessage("La venta debe tener al menos un detalle.")
                    .Must(x => x != null && x.Count > 0).WithMessage("La venta debe tener al menos un item.");

                RuleForEach(x => x.Venta.Detalles).ChildRules(detalle =>
                {
                    detalle.RuleFor(d => d.IdProducto)
                        .NotEmpty().WithMessage("El producto es obligatorio.");

                    detalle.RuleFor(d => d.Cantidad)
                        .GreaterThan(0).WithMessage("La cantidad debe ser mayor a 0.");

                    detalle.RuleFor(d => d.PrecioUnitario)
                        .GreaterThan(0).WithMessage("El precio unitario debe ser mayor a 0.");

                    detalle.RuleFor(d => d.DescuentoItem)
                        .GreaterThanOrEqualTo(0).WithMessage("El descuento no puede ser negativo.")
                        .Must((d, desc) => desc < (d.PrecioUnitario * d.Cantidad))
                        .WithMessage("El descuento no puede ser igual o mayor al subtotal de la línea.");

                    detalle.RuleFor(d => d.CodigoAfectacionIgv)
                        .NotEmpty().WithMessage("El código de afectación IGV es obligatorio.")
                        .Must(code => new[] { "10", "20", "30", "40" }.Contains(code))
                        .WithMessage("El código de afectación IGV no es válido (Catálogo 07 SUNAT).");
                });
            });
        }
    }
}
