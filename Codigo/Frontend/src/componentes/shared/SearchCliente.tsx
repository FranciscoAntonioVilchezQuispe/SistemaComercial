import { useState, useEffect, useRef } from "react";
import { Search, Loader2 } from "lucide-react";
import { Input } from "@/components/ui/input";
import { useClickOutside } from "@/hooks/useClickOutside";
import { apiClientes } from "@/lib/axios";
import { Cliente } from "@/features/clientes/types/cliente.types";

interface SearchClienteProps {
  onSelect: (cliente: Cliente) => void;
  placeholder?: string;
  disabled?: boolean;
  defaultValue?: Cliente;
}

export function SearchCliente({
  onSelect,
  placeholder = "Buscar cliente (Nombre o DNI/RUC)...",
  disabled = false,
}: SearchClienteProps) {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<Cliente[]>([]);
  const [loading, setLoading] = useState(false);
  const [open, setOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);
  const abortRef = useRef<AbortController | null>(null);

  useClickOutside(containerRef, () => setOpen(false));

  useEffect(() => {
    if (query.length < 3) {
      setResults([]);
      setOpen(false);
      return;
    }

    const timer = setTimeout(async () => {
      abortRef.current?.abort();
      abortRef.current = new AbortController();
      setLoading(true);
      setOpen(true);

      try {
        const response: any = await apiClientes.get(
          `/clientes?search=${query}&pageSize=10`,
          { signal: abortRef.current.signal }
        );
        setResults(response.datos || response.data || []);
      } catch (e) {
        if ((e as Error).name !== "AbortError") {
          console.error(e);
        }
      } finally {
        setLoading(false);
      }
    }, 350);

    return () => clearTimeout(timer);
  }, [query]);

  const seleccionar = (cliente: Cliente) => {
    onSelect(cliente);
    setQuery("");
    setResults([]);
    setOpen(false);
  };

  return (
    <div ref={containerRef} className="relative w-full">
      <div className="relative">
        <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
        <Input
          type="search"
          placeholder={placeholder}
          className="pl-9 pr-9"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          disabled={disabled}
          onFocus={() => query.length >= 3 && setOpen(true)}
        />
        {loading && (
          <div className="absolute right-2.5 top-2.5">
            <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
          </div>
        )}
      </div>

      {open && (
        <div className="absolute mt-1 w-full z-50 bg-background border rounded-lg shadow-lg overflow-hidden animate-in fade-in zoom-in-95 duration-200">
          <div className="max-h-[300px] overflow-y-auto py-1">
            {results.length > 0 ? (
              results.map((c) => (
                <button
                  key={c.id}
                  onClick={() => seleccionar(c)}
                  className="w-full flex flex-col items-start px-3 py-2 text-sm hover:bg-secondary transition-colors text-left"
                >
                  <span className="font-medium">{c.razonSocial}</span>
                  <div className="flex gap-2 text-xs text-muted-foreground">
                    <span>{c.numeroDocumento}</span>
                    {c.nombreComercial && (
                      <>
                        <span>•</span>
                        <span>{c.nombreComercial}</span>
                      </>
                    )}
                  </div>
                </button>
              ))
            ) : !loading ? (
              <div className="px-3 py-4 text-sm text-center text-muted-foreground">
                Sin resultados para "<span className="font-medium">{query}</span>"
              </div>
            ) : null}
          </div>
        </div>
      )}
    </div>
  );
}
