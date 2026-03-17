import { useState, useEffect } from "react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { servicioTablaGeneral } from "@/features/configuracion/servicios/servicioTablaGeneral";
import { TablaGeneralDetalle } from "@/features/configuracion/tipos/tablaGeneral.types";
import { Loader2 } from "lucide-react";

interface SelectTipoDocumentoProps {
  value?: string;
  onValueChange: (value: string) => void;
  disabled?: boolean;
  placeholder?: string;
}

export function SelectTipoDocumento({
  value,
  onValueChange,
  disabled = false,
  placeholder = "Tipo Doc.",
}: SelectTipoDocumentoProps) {
  const [tipos, setTipos] = useState<TablaGeneralDetalle[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const cargarTipos = async () => {
      setLoading(true);
      try {
        // id_tabla = 1 es para Tipos de Documento de Identidad según el sistema
        const data = await servicioTablaGeneral.obtenerDetalles(1);
        setTipos(data.filter(t => t.estado)); // Solo activos
      } catch (e) {
        console.error("Error al cargar tipos de documento:", e);
      } finally {
        setLoading(false);
      }
    };

    cargarTipos();
  }, []);

  return (
    <Select
      value={value}
      onValueChange={onValueChange}
      disabled={disabled || loading}
    >
      <SelectTrigger className="w-full">
        {loading ? (
          <div className="flex items-center gap-2">
            <Loader2 className="h-4 w-4 animate-spin" />
            <span className="text-muted-foreground">Cargando...</span>
          </div>
        ) : (
          <SelectValue placeholder={placeholder} />
        )}
      </SelectTrigger>
      <SelectContent>
        {tipos.map((tipo) => (
          <SelectItem key={tipo.id} value={tipo.id.toString()}>
            {tipo.nombre}
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
}
