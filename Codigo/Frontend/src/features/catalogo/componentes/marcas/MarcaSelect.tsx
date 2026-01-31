import { useMarcas } from "../../hooks/useMarcas";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/componentes/ui/select";
import { Marca } from "../../tipos/catalogo.types";

interface MarcaSelectProps {
  value?: number;
  onChange: (value: string) => void;
  placeholder?: string;
  disabled?: boolean;
}

export const MarcaSelect = ({
  value,
  onChange,
  placeholder = "Seleccione una marca",
  disabled,
}: MarcaSelectProps) => {
  const { data: respuesta, isLoading } = useMarcas();

  const stringValue = value ? value.toString() : undefined;

  return (
    <Select
      value={stringValue}
      onValueChange={onChange}
      disabled={disabled || isLoading}
    >
      <SelectTrigger>
        <SelectValue placeholder={isLoading ? "Cargando..." : placeholder} />
      </SelectTrigger>
      <SelectContent>
        {respuesta?.datos?.map((item: Marca) => (
          <SelectItem key={item.id} value={item.id.toString()}>
            {item.nombre}
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
};
