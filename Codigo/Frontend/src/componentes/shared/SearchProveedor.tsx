import { useState, useEffect, useRef } from "react";
import { Search, Loader2 } from "lucide-react";
import { Input } from "@/components/ui/input";
import { useClickOutside } from "@/hooks/useClickOutside";
import { apiCompras } from "@/lib/axios";
import { Proveedor } from "@/features/compras/proveedores/types/proveedor.types";

interface SearchProveedorProps {
  onSelect: (proveedor: Proveedor) => void;
  placeholder?: string;
  disabled?: boolean;
}

export function SearchProveedor({
  onSelect,
  placeholder = "Buscar proveedor (Razón Social o RUC)...",
  disabled = false,
}: SearchProveedorProps) {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<Proveedor[]>([]);
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
        const response: any = await apiCompras.get(
          `/proveedores?search=${query}&pageSize=10`,
          { signal: abortRef.current.signal }
        );
        setResults(response.data || []);
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

  const seleccionar = (proveedor: Proveedor) => {
    onSelect(proveedor);
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
              results.map((p) => (
                <button
                  key={p.id}
                  onClick={() => seleccionar(p)}
                  className="w-full flex flex-col items-start px-3 py-2 text-sm hover:bg-secondary transition-colors text-left"
                >
                  <span className="font-medium">{p.razonSocial}</span>
                  <div className="flex gap-2 text-xs text-muted-foreground">
                    <span>{p.numeroDocumento}</span>
                    {p.direccion && (
                      <>
                        <span>•</span>
                        <span className="truncate max-w-[200px]">{p.direccion}</span>
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
