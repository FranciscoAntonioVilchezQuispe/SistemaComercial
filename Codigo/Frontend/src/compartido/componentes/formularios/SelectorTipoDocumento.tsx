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
import { useTipoDocumento } from "@/features/configuracion/hooks/useTipoDocumento";
import { TipoDocumento } from "@/features/configuracion/services/tipoDocumentoService";
import { Loader2 } from "lucide-react";

interface SelectorTipoDocumentoProps {
  label?: string;
  placeholder?: string;
  value?: string | number;
  onChange: (value: string) => void;
  disabled?: boolean;
  hideLabel?: boolean;
  soloCodigo?: boolean; // Para mostrar solo el código en lugar del nombre completo
}

export const SelectorTipoDocumento: React.FC<SelectorTipoDocumentoProps> = ({
  label = "Tipo Documento",
  placeholder = "Seleccione tipo",
  value,
  onChange,
  disabled = false,
  hideLabel = false,
  soloCodigo = false,
}) => {
  const { data: tipos, isLoading, isError } = useTipoDocumento();

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
          {tipos?.map((tipo: TipoDocumento) => (
            <SelectItem key={tipo.id} value={tipo.id.toString()}>
              {soloCodigo ? tipo.codigo : tipo.nombre}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
      <FormMessage />
    </FormItem>
  );
};
