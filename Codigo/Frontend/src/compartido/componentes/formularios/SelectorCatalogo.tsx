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
import { useCatalogo } from "@/features/configuracion/hooks/useCatalogo";
import { Loader2 } from "lucide-react";

interface SelectorCatalogoProps {
  codigo: string;
  label?: string;
  placeholder?: string;

  value?: string | number;
  onChange: (value: string) => void;
  error?: string;
  disabled?: boolean;
  hideLabel?: boolean;
  soloCodigo?: boolean;
}

export const SelectorCatalogo: React.FC<SelectorCatalogoProps> = ({
  codigo,
  label,
  placeholder = "Seleccione una opción",
  value,
  onChange,
  disabled = false,
  hideLabel = false,
  soloCodigo = false,
}) => {
  const { data: valores, isLoading, isError } = useCatalogo(codigo);

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
            ) : soloCodigo ? (
              <div className="flex items-center justify-center w-full">
                <span>{value || ""}</span>
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
          {!isLoading && !isError && valores?.length === 0 && (
            <SelectItem value="none" disabled>
              No hay opciones disponibles
            </SelectItem>
          )}
          {(valores as any[])?.map((item: any) => (
            <SelectItem key={item.id} value={item.id.toString()}>
              {item.nombre}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
      <FormMessage />
    </FormItem>
  );
};
