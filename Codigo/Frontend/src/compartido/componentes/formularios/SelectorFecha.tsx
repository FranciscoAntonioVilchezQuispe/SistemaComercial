import { format } from "date-fns";
import { es } from "date-fns/locale";
import { Calendar as CalendarIcon } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Calendar } from "@/components/ui/calendar";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { cn } from "@/lib/utils";

interface PropiedadesSelectorFecha {
  fecha?: Date;
  alCambiarFecha: (fecha: Date | undefined) => void;
  placeholder?: string;
  deshabilitado?: boolean;
  className?: string;
}

export function SelectorFecha({
  fecha,
  alCambiarFecha,
  placeholder = "Seleccionar fecha",
  deshabilitado = false,
  className,
}: PropiedadesSelectorFecha) {
  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button
          variant="outline"
          disabled={deshabilitado}
          className={cn(
            "w-full justify-start text-left font-normal",
            !fecha && "text-muted-foreground",
            className,
          )}
        >
          <CalendarIcon className="mr-2 h-4 w-4" />
          {fecha ? format(fecha, "PPP", { locale: es }) : placeholder}
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-auto p-0" align="start">
        <Calendar
          mode="single"
          selected={fecha}
          onSelect={alCambiarFecha}
          locale={es}
          initialFocus
        />
      </PopoverContent>
    </Popover>
  );
}
