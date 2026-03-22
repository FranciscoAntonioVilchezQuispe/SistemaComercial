import React from "react";
import { Check, Trash2 } from "lucide-react";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Popover,
  PopoverContent,
  PopoverAnchor,
} from "@/components/ui/popover";
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandItem,
  CommandList,
} from "@/components/ui/command";

interface SelectorProductoProps {
  value: number;
  onChange: (id: number) => void;
  productos: any[];
  placeholder?: string;
  onProductSelect?: (producto: any) => void;
  onSearch: (term: string) => void;
  disabled?: boolean;
}

export const SelectorProducto = ({
  value,
  onChange,
  productos,
  onProductSelect,
  placeholder = "Buscar producto...",
  onSearch,
  disabled = false,
}: SelectorProductoProps) => {
  const [open, setOpen] = React.useState(false);
  const [inputValue, setInputValue] = React.useState("");

  React.useEffect(() => {
    if (value) {
      const selected = productos.find((p) => p.id === value);
      if (selected) {
        setInputValue(selected.nombre);
      }
    } else {
      setInputValue("");
    }
  }, [value, productos]);

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Enter") {
      if (open) return;
      e.preventDefault();
      onSearch(inputValue);
      setOpen(true);
    }
  };

  const handleClear = () => {
    onChange(0);
    setInputValue("");
    setOpen(false);
  };

  return (
    <Command className="overflow-visible bg-transparent font-normal" shouldFilter={false}>
      <Popover open={open} onOpenChange={setOpen}>
        <PopoverAnchor asChild>
          <div className="relative w-full">
            <Input
              placeholder={placeholder}
              value={inputValue}
              onChange={(e) => {
                const newValue = e.target.value;
                setInputValue(newValue);
                if (newValue === "") {
                  onChange(0);
                  setOpen(false);
                }
              }}
              onKeyDown={handleKeyDown}
              className="pr-10"
              disabled={disabled}
            />
            {inputValue && !disabled && (
              <Button
                type="button"
                variant="ghost"
                size="icon"
                className="absolute right-0 top-0 h-9 w-9 text-muted-foreground hover:text-foreground"
                onClick={handleClear}
              >
                <Trash2 className="h-4 w-4" />
              </Button>
            )}
          </div>
        </PopoverAnchor>
        <PopoverContent
          className="w-[400px] p-0"
          align="start"
          onOpenAutoFocus={(e) => e.preventDefault()}
        >
          <CommandList className="max-h-[300px] overflow-y-auto">
            <CommandEmpty>Presiona Enter para buscar.</CommandEmpty>
            <CommandGroup heading="Resultados de búsqueda">
              {productos.map((producto) => (
                <CommandItem
                  key={producto.id}
                  value={producto.id.toString()}
                  onSelect={() => {
                    onChange(producto.id);
                    if (onProductSelect) onProductSelect(producto);
                    setInputValue(producto.nombre);
                    setOpen(false);
                  }}
                >
                  <Check
                    className={cn(
                      "mr-2 h-4 w-4",
                      value === producto.id ? "opacity-100" : "opacity-0",
                    )}
                  />
                  <div className="flex flex-col">
                    <span className="font-medium">{producto.nombre}</span>
                    <span className="text-xs text-muted-foreground">
                      SKU: {producto.codigoSku || 'N/A'} - {producto.marcaNombre}
                    </span>
                  </div>
                </CommandItem>
              ))}
            </CommandGroup>
          </CommandList>
        </PopoverContent>
      </Popover>
    </Command>
  );
};
