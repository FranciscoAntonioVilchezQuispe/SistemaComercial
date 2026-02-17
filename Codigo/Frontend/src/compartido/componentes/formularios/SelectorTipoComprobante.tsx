import React from "react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/componentes/ui/select";
import {
  FormControl,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/componentes/ui/form";
import { useTipoComprobante } from "@/features/configuracion/hooks/useTipoComprobante";
import { TipoComprobante } from "@/features/configuracion/services/tipoComprobanteService";
import { Loader2 } from "lucide-react";

interface SelectorTipoComprobanteProps {
  label?: string;
  placeholder?: string;
  value?: string | number;
  onChange: (value: string) => void;
  disabled?: boolean;
  hideLabel?: boolean;
}

export const SelectorTipoComprobante: React.FC<
  SelectorTipoComprobanteProps
> = ({
  label = "Tipo Comprobante",
  placeholder = "Seleccione tipo",
  value,
  onChange,
  disabled = false,
  hideLabel = false,
}) => {
  const { data: tipos, isLoading, isError } = useTipoComprobante();

  return (
    <FormItem>
      {!hideLabel && <FormLabel>{label}</FormLabel>}
      <Select
        onValueChange={onChange}
        value={value?.toString()}
        disabled={disabled || isLoading}
      >
        <FormControl>
          <SelectTrigger>
            {isLoading ? (
              <div className="flex items-center gap-2">
                <Loader2 className="h-4 w-4 animate-spin" />
                <span>...</span>
              </div>
            ) : (
              <SelectValue placeholder={placeholder} />
            )}
          </SelectTrigger>
        </FormControl>
        <SelectContent>
          {isError && (
            <SelectItem value="error" disabled>
              Error al cargar datos
            </SelectItem>
          )}
          {!isLoading && !isError && tipos?.length === 0 && (
            <SelectItem value="none" disabled>
              No hay opciones disponibles
            </SelectItem>
          )}
          {tipos?.map((tipo: TipoComprobante) => (
            <SelectItem key={tipo.id} value={tipo.id.toString()}>
              {tipo.nombre}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
      <FormMessage />
    </FormItem>
  );
};
