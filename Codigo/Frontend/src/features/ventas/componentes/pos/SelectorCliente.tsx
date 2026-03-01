import React, { useState, useEffect, useRef } from "react";
import { Search, X, Loader2, UserPlus, User } from "lucide-react";
import { Button } from "@/componentes/ui/button";
import { Cliente } from "@/features/clientes/types/cliente.types";
import { obtenerClientes } from "@/features/clientes/servicios/servicioClientes";
import { Tabs, TabsList, TabsTrigger } from "@/componentes/ui/tabs";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/componentes/ui/dialog";
import { ClienteForm } from "@/features/clientes/componentes/ClienteForm";

interface SelectorClienteProps {
  onSeleccionar: (cliente: Cliente | null) => void;
  clienteSeleccionado?: Cliente | null;
  tipoComprobante: string;
  onTipoComprobanteChange: (tipo: string) => void;
}

export function SelectorCliente({
  onSeleccionar,
  clienteSeleccionado,
  tipoComprobante,
  onTipoComprobanteChange,
}: SelectorClienteProps) {
  const [query, setQuery] = useState("");
  const [resultados, setResultados] = useState<Cliente[]>([]);
  const [cargando, setCargando] = useState(false);
  const [isOpen, setIsOpen] = useState(false);
  const [selectedIndex, setSelectedIndex] = useState(-1);
  const [showNuevoCliente, setShowNuevoCliente] = useState(false);

  const listRef = useRef<HTMLUListElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const clientePorDefecto: Cliente = {
    id: 0,
    razonSocial: "Público General",
    numeroDocumento: "00000000",
    idTipoDocumento: 1,
    idTipoCliente: 1,
    email: "",
    telefono: "",
    direccion: "",
    activado: true,
  };

  const buscarClientes = async (termino: string) => {
    if (!termino.trim()) {
      setResultados([clientePorDefecto]);
      setIsOpen(true);
      return;
    }

    setCargando(true);
    try {
      const res = await obtenerClientes(termino);
      // Siempre incluimos Público General si el término es vacío o si no hay resultados específicos
      // Pero si hay búsqueda, mostramos lo que devuelva el API y opcionalmente el por defecto arriba
      setResultados(res || []);
      setIsOpen(true);
      setSelectedIndex(-1);
    } catch (error) {
      console.error("Error buscando clientes", error);
    } finally {
      setCargando(false);
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Enter") {
      e.preventDefault();
      if (isOpen && selectedIndex >= 0 && selectedIndex < resultados.length) {
        seleccionarCliente(resultados[selectedIndex]);
      } else {
        buscarClientes(query);
      }
    } else if (e.key === "ArrowDown") {
      e.preventDefault();
      if (isOpen) {
        setSelectedIndex((prev) =>
          prev < resultados.length - 1 ? prev + 1 : prev,
        );
      } else {
        buscarClientes(query);
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

  const seleccionarCliente = (c: Cliente) => {
    onSeleccionar(c);
    setIsOpen(false);
    setQuery("");
    setSelectedIndex(-1);
  };

  const limpiarSeleccion = () => {
    onSeleccionar(null);
    setResultados([]);
    setQuery("");
    setTimeout(() => {
      inputRef.current?.focus();
    }, 10);
  };

  const clearInput = () => {
    setQuery("");
    if (isOpen) {
      setResultados([]);
      setIsOpen(false);
    }
  };

  // Resaltador de texto (reutilizando lógica visual de BuscadorProductoOscuro)
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
              className="font-bold text-blue-600 bg-blue-50 px-[2px] rounded"
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
    <>
      <div className="flex items-center justify-between gap-4">
        <label className="text-xs font-bold uppercase tracking-wider text-muted-foreground flex items-center gap-1.5">
          <User size={14} className="text-primary" />
          Comprobante y Cliente
        </label>

        <Tabs
          value={tipoComprobante}
          onValueChange={onTipoComprobanteChange}
          className="w-auto"
        >
          <TabsList className="grid grid-cols-2 h-8 p-1 bg-muted/50">
            <TabsTrigger
              value="1"
              className="text-[10px] uppercase font-bold py-1 px-3"
            >
              Factura
            </TabsTrigger>
            <TabsTrigger
              value="2"
              className="text-[10px] uppercase font-bold py-1 px-3"
            >
              Boleta
            </TabsTrigger>
          </TabsList>
        </Tabs>
      </div>

      <div className="relative">
        {clienteSeleccionado && clienteSeleccionado.id !== 0 ? (
          <div className="flex h-12 w-full items-center justify-between rounded-lg border border-primary/20 bg-primary/5 px-3 py-2 text-sm shadow-sm transition-all hover:border-primary/40">
            <div className="flex flex-col truncate pr-2">
              <span className="text-sm font-bold text-foreground truncate uppercase">
                {clienteSeleccionado.razonSocial}
              </span>
              <span className="text-[10px] text-muted-foreground font-mono">
                {clienteSeleccionado.idTipoDocumento === 6 ? "RUC" : "DOC"}:{" "}
                {clienteSeleccionado.numeroDocumento}
              </span>
            </div>
            <button
              type="button"
              onClick={limpiarSeleccion}
              className="text-muted-foreground hover:text-destructive hover:bg-destructive/10 focus:outline-none p-1.5 shrink-0 transition-colors rounded-full"
              title="Cambiar cliente"
            >
              <X size={18} />
            </button>
          </div>
        ) : (
          <div className="relative">
            <div className="flex items-center w-full rounded-lg border border-input bg-background px-3 h-11 py-2 text-sm ring-offset-background focus-within:ring-2 focus-within:ring-primary focus-within:ring-offset-1 transition-all shadow-sm">
              {cargando ? (
                <Loader2
                  size={18}
                  className="text-primary animate-spin mr-2 shrink-0"
                />
              ) : (
                <Search
                  size={18}
                  className="text-muted-foreground mr-2 shrink-0"
                />
              )}

              <input
                ref={inputRef}
                type="text"
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                onKeyDown={handleKeyDown}
                placeholder={
                  tipoComprobante === "1"
                    ? "Buscar por RUC o Razón Social..."
                    : "Buscar cliente (Enter)..."
                }
                className="flex-1 bg-transparent outline-none h-full placeholder:text-muted-foreground/60"
                autoComplete="off"
              />

              {query && (
                <button
                  type="button"
                  onClick={clearInput}
                  className="text-muted-foreground hover:text-foreground p-1"
                >
                  <X size={16} />
                </button>
              )}

              <div className="h-4 w-[1px] bg-border mx-2" />

              <Button
                variant="ghost"
                size="icon"
                className="h-8 w-8 text-primary hover:bg-primary/10"
                title="Registrar nuevo cliente"
                onClick={() => setShowNuevoCliente(true)}
              >
                <UserPlus size={18} />
              </Button>
            </div>

            {/* Menú de resultados */}
            {isOpen && (
              <div className="absolute top-[115%] left-0 right-0 max-h-[250px] overflow-y-auto bg-popover text-popover-foreground border border-border rounded-lg shadow-xl z-50 py-1.5 animate-in fade-in slide-in-from-top-2 duration-200">
                <ul ref={listRef}>
                  {/* Opción Público General fija al inicio si no hay búsqueda */}
                  {(!query.trim() || resultados.length === 0) &&
                    tipoComprobante !== "1" && (
                      <li
                        className={`px-4 py-2.5 cursor-pointer flex flex-col border-l-4 transition-colors ${
                          selectedIndex === -1
                            ? "bg-accent/50 border-primary text-accent-foreground"
                            : "bg-transparent border-transparent hover:bg-muted"
                        }`}
                        onClick={() => seleccionarCliente(clientePorDefecto)}
                      >
                        <span className="text-sm font-bold uppercase tracking-tight">
                          Público General
                        </span>
                        <span className="text-[10px] text-muted-foreground font-medium uppercase">
                          Sin comprobante con nombre
                        </span>
                      </li>
                    )}

                  {resultados.map((c, idx) => {
                    const isActive = idx === selectedIndex;
                    return (
                      <li
                        key={c.id}
                        className={`px-4 py-2.5 cursor-pointer flex flex-col border-l-4 transition-colors ${
                          isActive
                            ? "bg-accent border-primary text-accent-foreground"
                            : "bg-transparent border-transparent hover:bg-muted"
                        }`}
                        onClick={() => seleccionarCliente(c)}
                        onMouseEnter={() => setSelectedIndex(idx)}
                      >
                        <div className="text-sm font-bold uppercase truncate">
                          <HighlightText
                            text={c.razonSocial}
                            highlight={query}
                          />
                        </div>
                        <div className="text-[10px] text-muted-foreground font-mono mt-0.5 uppercase">
                          {c.idTipoDocumento === 6 ? "RUC" : "DOC"}:{" "}
                          <HighlightText
                            text={c.numeroDocumento}
                            highlight={query}
                          />
                        </div>
                      </li>
                    );
                  })}
                </ul>

                {!cargando && query && resultados.length === 0 && (
                  <div className="px-4 py-6 text-center">
                    <p className="text-sm text-muted-foreground italic">
                      No se hallaron clientes
                    </p>
                    <Button
                      variant="link"
                      size="sm"
                      className="mt-1 h-auto p-0 text-primary font-bold"
                      onClick={() => setShowNuevoCliente(true)}
                    >
                      ¿Deseas crear uno nuevo?
                    </Button>
                  </div>
                )}
              </div>
            )}
          </div>
        )}
      </div>

      {/* Diálogo de Nuevo Cliente */}
      <Dialog open={showNuevoCliente} onOpenChange={setShowNuevoCliente}>
        <DialogContent className="sm:max-w-[600px] p-6">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <UserPlus className="h-5 w-5 text-primary" />
              Registrar Nuevo Cliente
            </DialogTitle>
          </DialogHeader>
          <div className="py-4">
            <ClienteForm
              onSuccess={() => {
                setShowNuevoCliente(false);
                // Aquí idealmente seleccionaríamos el cliente creado,
                // pero como la API suele invalidar queries, el usuario puede buscarlo
                // o podríamos pasar el resultado si ClienteForm lo retornara.
              }}
              onCancel={() => setShowNuevoCliente(false)}
            />
          </div>
        </DialogContent>
      </Dialog>

      {/* Si es Público General, mostramos un aviso sutil */}
      {clienteSeleccionado?.id === 0 ? (
        <p className="text-[10px] text-muted-foreground/80 italic pl-1">
          Operando como Público General (Boleta/Ticket)
        </p>
      ) : null}
    </>
  );
}
