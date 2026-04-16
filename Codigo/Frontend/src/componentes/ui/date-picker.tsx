"use client";

import { format } from "date-fns";
import { es } from "date-fns/locale";
import { Calendar as CalendarIcon } from "lucide-react";

import { cn } from "@/lib/utils";
import { Button } from "@/componentes/ui/button";
import { Calendar } from "@/componentes/ui/calendar";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/componentes/ui/popover";
import { DATE_CONFIG } from "@/lib/datetime";

interface DatePickerProps {
  date?: Date;
  setDate: (date: Date | undefined) => void;
  placeholder?: string;
  className?: string;
  disabled?: boolean;
}

export function DatePicker({ date, setDate, placeholder = "Seleccionar fecha", className, disabled }: DatePickerProps) {
  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button
          variant={"outline"}
          disabled={disabled}
          className={cn(
            "w-full justify-start text-left font-normal",
            !date && "text-muted-foreground",
            className
          )}
        >
          <CalendarIcon className="mr-2 h-4 w-4" />
          {date ? format(date, DATE_CONFIG.displayFormat, { locale: es }) : <span>{placeholder}</span>}
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-auto p-0" align="start">
        <Calendar
          mode="single"
          selected={date}
          onSelect={setDate}
          autoFocus
          locale={es}
        />
      </PopoverContent>
    </Popover>
  );
}
