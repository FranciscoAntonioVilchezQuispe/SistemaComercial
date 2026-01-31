import { format } from "date-fns";
import { es } from "date-fns/locale";
import { Calendar as CalendarIcon } from "lucide-react";
import { DateRange } from "react-day-picker";
import { Button } from "@/components/ui/button";
import { Calendar } from "@/components/ui/calendar";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { cn } from "@/lib/utils";

interface PropiedadesSelectorRangoFecha {
  rango?: DateRange;
  alCambiarRango: (rango: DateRange | undefined) => void;
  placeholder?: string;
  deshabilitado?: boolean;
  className?: string;
}

export function SelectorRangoFecha({
  rango,
  alCambiarRango,
  placeholder = "Seleccionar rango de fechas",
  deshabilitado = false,
  className,
}: PropiedadesSelectorRangoFecha) {
  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button
          variant="outline"
          disabled={deshabilitado}
          className={cn(
            "w-full justify-start text-left font-normal",
            !rango && "text-muted-foreground",
            className,
          )}
        >
          <CalendarIcon className="mr-2 h-4 w-4" />
          {rango?.from ? (
            rango.to ? (
              <>
                {format(rango.from, "dd/MM/yyyy", { locale: es })} -{" "}
                {format(rango.to, "dd/MM/yyyy", { locale: es })}
              </>
            ) : (
              format(rango.from, "dd/MM/yyyy", { locale: es })
            )
          ) : (
            placeholder
          )}
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-auto p-0" align="start">
        <Calendar
          mode="range"
          selected={rango}
          onSelect={alCambiarRango}
          locale={es}
          numberOfMonths={2}
          initialFocus
        />
      </PopoverContent>
    </Popover>
  );
}
