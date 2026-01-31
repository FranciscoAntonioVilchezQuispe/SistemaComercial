import { forwardRef } from "react";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";

interface PropiedadesInputNumero extends Omit<
  React.InputHTMLAttributes<HTMLInputElement>,
  "type"
> {
  alCambiarValor?: (valor: number) => void;
  permitirDecimales?: boolean;
  decimales?: number;
}

export const InputNumero = forwardRef<HTMLInputElement, PropiedadesInputNumero>(
  (
    {
      className,
      alCambiarValor,
      onChange,
      value,
      permitirDecimales = false,
      decimales = 2,
      ...props
    },
    ref,
  ) => {
    const manejarCambio = (e: React.ChangeEvent<HTMLInputElement>) => {
      let valorTexto = e.target.value;

      if (permitirDecimales) {
        // Permitir solo números y punto decimal
        valorTexto = valorTexto.replace(/[^\d.]/g, "");

        // Asegurar solo un punto decimal
        const partes = valorTexto.split(".");
        if (partes.length > 2) {
          valorTexto = `${partes[0]}.${partes.slice(1).join("")}`;
        }

        // Limitar decimales
        if (partes.length === 2 && partes[1].length > decimales) {
          valorTexto = `${partes[0]}.${partes[1].substring(0, decimales)}`;
        }
      } else {
        // Solo números enteros
        valorTexto = valorTexto.replace(/\D/g, "");
      }

      // Actualizar el input
      e.target.value = valorTexto;

      // Llamar al onChange original si existe
      onChange?.(e);

      // Llamar al callback con el valor numérico
      if (alCambiarValor) {
        const valorNumerico = permitirDecimales
          ? parseFloat(valorTexto) || 0
          : parseInt(valorTexto) || 0;
        alCambiarValor(valorNumerico);
      }
    };

    return (
      <Input
        ref={ref}
        type="text"
        inputMode={permitirDecimales ? "decimal" : "numeric"}
        className={cn("text-right", className)}
        onChange={manejarCambio}
        value={value}
        {...props}
      />
    );
  },
);

InputNumero.displayName = "InputNumero";
