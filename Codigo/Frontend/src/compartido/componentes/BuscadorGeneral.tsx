import { Search, X } from "lucide-react";
import { Input } from "@/componentes/ui/input";
import { Button } from "@/componentes/ui/button";
import { useEffect, useState } from "react";

interface PropiedadesBuscadorGeneral {
  placeholder?: string;
  alBuscar: (valor: string) => void;
  valorInicial?: string;
  debounceMs?: number;
}

export function BuscadorGeneral({
  placeholder = "Buscar...",
  alBuscar,
  valorInicial = "",
  debounceMs = 500,
}: PropiedadesBuscadorGeneral) {
  const [valor, setValor] = useState(valorInicial);

  useEffect(() => {
    const manejador = setTimeout(() => {
      alBuscar(valor);
    }, debounceMs);

    return () => clearTimeout(manejador);
  }, [valor, alBuscar, debounceMs]);

  return (
    <div className="relative group w-full max-w-sm">
      <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground transition-colors group-focus-within:text-primary" />
      <Input
        value={valor}
        onChange={(e) => setValor(e.target.value)}
        placeholder={placeholder}
        className="pl-9 pr-9 bg-muted/50 border-none transition-all focus-visible:bg-background focus-visible:ring-1 focus-visible:ring-primary"
      />
      {valor && (
        <Button
          variant="ghost"
          size="icon"
          className="absolute right-1 top-1/2 -translate-y-1/2 h-7 w-7 text-muted-foreground hover:text-foreground"
          onClick={() => setValor("")}
        >
          <X className="h-3 w-3" />
        </Button>
      )}
    </div>
  );
}
