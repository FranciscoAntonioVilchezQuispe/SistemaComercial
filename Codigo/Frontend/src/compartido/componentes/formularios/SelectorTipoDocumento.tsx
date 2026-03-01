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
  soloCodigo?: boolean;
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

  const listaFiltrada = tipos ?? [];

  return (
    <FormItem>
      {!hideLabel && <FormLabel>{label}</FormLabel>}
      <Select
        onValueChange={onChange}
        value={value != null ? value.toString() : undefined}
        disabled={disabled || isLoading}
      >
        <FormControl>
          <SelectTrigger>
            {isLoading ? (
              <div className="flex items-center gap-2">
                <Loader2 className="h-4 w-4 animate-spin" />
                <span>Cargando...</span>
              </div>
            ) : (
              <SelectValue placeholder={placeholder} />
            )}
          </SelectTrigger>
        </FormControl>
        <SelectContent>
          {isError && (
            <SelectItem value="error" disabled>
              Error al cargar tipos de documento
            </SelectItem>
          )}
          {!isLoading && !isError && listaFiltrada.length === 0 && (
            <SelectItem value="none" disabled>
              No hay tipos disponibles
            </SelectItem>
          )}
          {listaFiltrada.map((tipo: TipoDocumento) => (
            <SelectItem key={tipo.id} value={tipo.id.toString()}>
              <span className="font-mono text-xs text-muted-foreground mr-2">
                {tipo.codigo}
              </span>
              {soloCodigo ? tipo.codigo : tipo.nombre}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
      <FormMessage />
    </FormItem>
  );
};
