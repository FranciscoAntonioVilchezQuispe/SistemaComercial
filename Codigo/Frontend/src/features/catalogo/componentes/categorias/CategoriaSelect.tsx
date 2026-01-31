import { useCategorias } from "../../hooks/useCategorias";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/componentes/ui/select";
import { Categoria } from "../../tipos/catalogo.types";

interface CategoriaSelectProps {
  value?: number;
  onChange: (value: string) => void;
  placeholder?: string;
  disabled?: boolean;
}

export const CategoriaSelect = ({
  value,
  onChange,
  placeholder = "Seleccione una categoría",
  disabled,
}: CategoriaSelectProps) => {
  // Fetching a large number to ensure we get most categories
  // TODO: implement search or infinite scroll for large datasets
  const { data: respuesta, isLoading } = useCategorias({});

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
        {respuesta?.datos?.map((item: Categoria) => (
          <SelectItem key={item.id} value={item.id.toString()}>
            {item.nombre}
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
};
