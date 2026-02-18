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
import { useComprobantesPorDocumento } from "@/configuracion/hooks/useComprobantesPorDocumento";
import { useTipoComprobante } from "@/features/configuracion/hooks/useTipoComprobante";
import { TipoComprobante } from "@/features/configuracion/tipos/tipoComprobante.types";
import { Loader2 } from "lucide-react";

interface SelectorTipoComprobanteProps {
  label?: string;
  placeholder?: string;
  value?: string | number;
  onChange: (value: string) => void;
  disabled?: boolean;
  hideLabel?: boolean;
  modulo?: string;
  codigoDocumento?: string;
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
  modulo,
  codigoDocumento,
}) => {
  // Siempre cargamos todos los tipos si no hay código de documento, o los filtrados si lo hay
  const {
    data: todosLosTipos,
    isLoading: loadingTodos,
    isError: errorTodos,
  } = useTipoComprobante(modulo);
  const {
    data: tiposFiltradosQuery,
    isLoading: loadingFiltrados,
    isError: errorFiltrados,
  } = useComprobantesPorDocumento(codigoDocumento);

  const isLoading = loadingTodos || (!!codigoDocumento && loadingFiltrados);
  const isError = errorTodos || (!!codigoDocumento && errorFiltrados);

  const tiposAMostrar = React.useMemo(() => {
    if (!codigoDocumento) return todosLosTipos || [];
    return tiposFiltradosQuery || [];
  }, [todosLosTipos, tiposFiltradosQuery, codigoDocumento]);

  return (
    <FormItem>
      {!hideLabel && <FormLabel>{label}</FormLabel>}
      <Select
        onValueChange={onChange}
        value={value ? value.toString() : ""}
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
          {!isLoading && tiposAMostrar?.length === 0 && (
            <SelectItem value="none" disabled>
              No hay opciones disponibles
            </SelectItem>
          )}
          {tiposAMostrar?.map((tipo: TipoComprobante) => (
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
