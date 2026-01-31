import { forwardRef } from "react";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";

interface PropiedadesInputMoneda extends Omit<
  React.InputHTMLAttributes<HTMLInputElement>,
  "type"
> {
  alCambiarValor?: (valor: number) => void;
}

export const InputMoneda = forwardRef<HTMLInputElement, PropiedadesInputMoneda>(
  ({ className, alCambiarValor, onChange, value, ...props }, ref) => {
    const manejarCambio = (e: React.ChangeEvent<HTMLInputElement>) => {
      const valorTexto = e.target.value;

      // Permitir solo números y punto decimal
      const valorLimpio = valorTexto.replace(/[^\d.]/g, "");

      // Asegurar solo un punto decimal
      const partes = valorLimpio.split(".");
      const valorFinal =
        partes.length > 2
          ? `${partes[0]}.${partes.slice(1).join("")}`
          : valorLimpio;

      // Actualizar el input
      e.target.value = valorFinal;

      // Llamar al onChange original si existe
      onChange?.(e);

      // Llamar al callback con el valor numérico
      if (alCambiarValor) {
        const valorNumerico = parseFloat(valorFinal) || 0;
        alCambiarValor(valorNumerico);
      }
    };

    return (
      <div className="relative">
        <span className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground">
          S/
        </span>
        <Input
          ref={ref}
          type="text"
          inputMode="decimal"
          className={cn("pl-10", className)}
          onChange={manejarCambio}
          value={value}
          {...props}
        />
      </div>
    );
  },
);

InputMoneda.displayName = "InputMoneda";
