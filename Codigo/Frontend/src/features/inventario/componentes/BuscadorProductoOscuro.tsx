import React, { useState, useEffect, useRef } from "react";
import { Search, X, Loader2 } from "lucide-react";
import { Producto } from "@/features/catalogo/tipos/catalogo.types";
import { servicioProductos } from "@/features/catalogo/servicios/servicioProductos";

interface BuscadorProductoOscuroProps {
  onSelectProducto: (productoId: number, descripcion: string) => void;
  productoInicialId?: number;
  nombreInicial?: string;
}

export function BuscadorProductoOscuro({
  onSelectProducto,
  productoInicialId = 0,
  nombreInicial = "",
}: BuscadorProductoOscuroProps) {
  const [query, setQuery] = useState("");
  const [resultados, setResultados] = useState<Producto[]>([]);
  const [cargando, setCargando] = useState(false);
  const [isOpen, setIsOpen] = useState(false);
  const [selectedIndex, setSelectedIndex] = useState(-1);

  const [productoSeleccionado, setProductoSeleccionado] = useState<{
    id: number;
    nombre: string;
  } | null>(
    productoInicialId > 0
      ? { id: productoInicialId, nombre: nombreInicial }
      : null,
  );

  const listRef = useRef<HTMLUListElement>(null);

  useEffect(() => {
    if (productoInicialId > 0 && !productoSeleccionado) {
      setProductoSeleccionado({
        id: productoInicialId,
        nombre: nombreInicial || "Producto Seleccionado",
      });
    }
  }, [productoInicialId, nombreInicial]);

  const buscarProductos = async (termino: string) => {
    if (!termino.trim()) return;
    setCargando(true);
    try {
      const res = await servicioProductos.obtenerProductos({
        search: termino,
        pageSize: 15,
        pageNumber: 1,
      });
      setResultados(res.datos || []);
      setIsOpen(true);
      setSelectedIndex(-1);
    } catch (error) {
      console.error("Error buscando productos", error);
    } finally {
      setCargando(false);
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Enter") {
      e.preventDefault();
      if (isOpen && selectedIndex >= 0 && selectedIndex < resultados.length) {
        seleccionarProducto(resultados[selectedIndex]);
      } else {
        buscarProductos(query);
      }
    } else if (e.key === "ArrowDown") {
      e.preventDefault();
      if (isOpen) {
        setSelectedIndex((prev) =>
          prev < resultados.length - 1 ? prev + 1 : prev,
        );
      }
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      if (isOpen) {
        setSelectedIndex((prev) => (prev > 0 ? prev - 1 : 0));
      }
    } else if (e.key === "Escape") {
      setIsOpen(false);
    }
  };

  useEffect(() => {
    if (isOpen && listRef.current && selectedIndex >= 0) {
      const item = listRef.current.children[selectedIndex] as HTMLElement;
      if (item) {
        item.scrollIntoView({ block: "nearest", behavior: "smooth" });
      }
    }
  }, [selectedIndex, isOpen]);

  const seleccionarProducto = (p: Producto) => {
    setProductoSeleccionado({ id: p.id, nombre: p.nombre });
    setIsOpen(false);
    setQuery("");
    onSelectProducto(p.id, p.nombre);
  };

  const limpiarSeleccion = () => {
    setProductoSeleccionado(null);
    setResultados([]);
    setQuery("");
    onSelectProducto(0, "");
    setTimeout(() => {
      document.getElementById("searchInputProducto")?.focus();
    }, 10);
  };

  const clearInput = () => {
    setQuery("");
    if (isOpen) {
      setResultados([]);
      setIsOpen(false);
    }
  };

  // Resaltador de texto buscado adaptado para el tema general
  const HighlightText = ({
    text,
    highlight,
  }: {
    text: string;
    highlight: string;
  }) => {
    if (!highlight.trim()) return <span>{text}</span>;
    const parts = text.split(new RegExp(`(${highlight})`, "gi"));
    return (
      <span>
        {parts.map((p, i) =>
          p.toLowerCase() === highlight.toLowerCase() ? (
            <span
              key={i}
              className="font-bold text-amber-600 bg-amber-50 px-[2px] rounded"
            >
              {p}
            </span>
          ) : (
            <span key={i}>{p}</span>
          ),
        )}
      </span>
    );
  };

  return (
    <div className="relative w-full">
      {/* Vista cuando NO hay producto seleccionado */}
      {!productoSeleccionado && (
        <div className="relative">
          <div className="flex items-center w-full rounded-md border border-input bg-background px-3 h-10 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-within:outline-none focus-within:ring-2 focus-within:ring-ring focus-within:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 transition-all shadow-sm">
            {cargando ? (
              <Loader2
                size={16}
                className="text-muted-foreground animate-spin mr-2 shrink-0"
              />
            ) : (
              <Search
                size={16}
                className="text-muted-foreground mr-2 shrink-0"
              />
            )}

            <input
              id="searchInputProducto"
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              onKeyDown={handleKeyDown}
              placeholder="Presiona Enter para buscar..."
              className="flex-1 bg-transparent outline-none h-full"
              autoComplete="off"
            />

            {query && (
              <button
                type="button"
                onClick={clearInput}
                className="text-muted-foreground hover:text-foreground focus:outline-none p-1"
                title="Limpiar búsqueda"
              >
                <X size={16} />
              </button>
            )}
          </div>

          {/* Lista Desplegable (Dropdown) */}
          {isOpen && (
            <div className="absolute top-[110%] left-0 right-0 max-h-[300px] overflow-y-auto bg-popover text-popover-foreground border border-border rounded-md shadow-md z-50 py-1 anim-fade-in-down">
              {resultados.length > 0 ? (
                <ul ref={listRef}>
                  {resultados.map((p, idx) => {
                    const isActive = idx === selectedIndex;
                    return (
                      <li
                        key={p.id}
                        className={`px-3 py-2 cursor-pointer flex flex-col transition-colors border-l-2 ${
                          isActive
                            ? "bg-accent border-primary text-accent-foreground"
                            : "bg-transparent border-transparent hover:bg-muted"
                        }`}
                        onClick={() => seleccionarProducto(p)}
                        onMouseEnter={() => setSelectedIndex(idx)}
                      >
                        <div className="text-sm font-medium">
                          <HighlightText text={p.nombre} highlight={query} />
                        </div>
                        <div className="text-[10px] text-muted-foreground uppercase tracking-wider font-mono mt-0.5">
                          CÓD:{" "}
                          <HighlightText text={p.codigo} highlight={query} />
                        </div>
                      </li>
                    );
                  })}
                </ul>
              ) : (
                !cargando && (
                  <div className="px-3 py-6 text-center text-sm text-muted-foreground italic">
                    No se encontraron resultados para "{query}"
                  </div>
                )
              )}
            </div>
          )}
        </div>
      )}

      {/* Vista cuando SÍ hay producto seleccionado */}
      {productoSeleccionado && (
        <div className="flex h-10 w-full items-center justify-between rounded-md border border-input bg-slate-50/50 px-3 py-2 text-sm shadow-sm ring-offset-background">
          <div className="flex items-center truncate pr-2">
            <span
              className="text-sm font-semibold text-foreground truncate"
              title={productoSeleccionado.nombre}
            >
              {productoSeleccionado.nombre}
            </span>
          </div>
          <button
            type="button"
            onClick={limpiarSeleccion}
            className="text-muted-foreground hover:text-red-500 hover:bg-red-50 focus:outline-none p-1 shrink-0 transition-colors rounded-full"
            title="Eliminar selección"
          >
            <X size={16} />
          </button>
        </div>
      )}
    </div>
  );
}
