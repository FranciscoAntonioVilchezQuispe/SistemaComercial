import { useState, useEffect, useRef } from "react";
import { Search, Loader2 } from "lucide-react";
import { Input } from "@/components/ui/input";
import { useClickOutside } from "@/hooks/useClickOutside";
import { apiVentas } from "@/lib/axios";
import { Venta } from "@/features/ventas/tipos/ventas.types";
import { formatearMoneda, formatearFechaHora } from "@compartido/utilidades";

interface SearchComprobanteProps {
  onSelect: (venta: Venta) => void;
  placeholder?: string;
  disabled?: boolean;
}

export function SearchComprobante({
  onSelect,
  placeholder = "Buscar comprobante (Nro. Serie-Correlativo)...",
  disabled = false,
}: SearchComprobanteProps) {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<Venta[]>([]);
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
        const response: any = await apiVentas.get(
          `/ventas?numeroComprobante=${query}&pagina=1&elementosPorPagina=10`,
          { signal: abortRef.current.signal }
        );
        // La respuesta puede venir en response.datos o directamente en response
        const data = response.datos || response.data || [];
        setResults(data);
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

  const seleccionar = (venta: Venta) => {
    onSelect(venta);
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
              results.map((v) => (
                <button
                  key={v.id}
                  onClick={() => seleccionar(v)}
                  className="w-full flex flex-col items-start px-3 py-2 text-sm hover:bg-secondary transition-colors text-left"
                >
                  <div className="flex justify-between w-full">
                    <span className="font-medium">{v.serie}-{v.numeroFormateado}</span>
                    <span className="text-xs font-semibold text-primary">
                      {formatearMoneda(v.totalVenta)}
                    </span>
                  </div>
                  <div className="flex gap-2 text-xs text-muted-foreground">
                    <span className="truncate max-w-[150px]">{v.nombreCliente || "Cliente General"}</span>
                    <span>•</span>
                    <span>{formatearFechaHora(v.fechaEmision)}</span>
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
