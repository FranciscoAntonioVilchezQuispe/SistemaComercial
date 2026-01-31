import { AlertTriangle, History, Pencil } from "lucide-react";
import { StockProducto } from "../../tipos/inventario.types";
import { TablaPaginada } from "@/compartido/componentes/tablas/TablaPaginada";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { formatearFecha } from "@/compartido/utilidades/formateo/formatearFecha";

interface Props {
  stock: StockProducto[];
  isLoading: boolean;
  onAjustar: (item: StockProducto) => void;
  onVerKardex: (item: StockProducto) => void;
}

export function TablaStock({
  stock,
  isLoading,
  onAjustar,
  onVerKardex,
}: Props) {
  const columnas = [
    {
      clave: "producto",
      titulo: "Producto",
      renderizar: (item: StockProducto) => (
        <div className="flex flex-col">
          <span className="font-medium">
            {item.producto?.nombre || "Producto desconocido"}
          </span>
          <span className="text-xs text-muted-foreground">
            {item.producto?.codigo || `#${item.idProducto}`}
          </span>
        </div>
      ),
    },
    {
      clave: "almacen",
      titulo: "Almacén",
      renderizar: (item: StockProducto) => item.almacen || "Almacén Principal",
    },
    {
      clave: "cantidadActual",
      titulo: "Stock",
      renderizar: (item: StockProducto) => {
        const esBajo = item.cantidadActual <= item.cantidadMinima;
        return (
          <div className="flex items-center gap-2">
            <span
              className={cn(
                "font-bold text-lg",
                esBajo ? "text-destructive" : "text-primary",
              )}
            >
              {item.cantidadActual}
            </span>
            {esBajo && <AlertTriangle className="h-4 w-4 text-destructive" />}
          </div>
        );
      },
    },
    {
      clave: "cantidadMinima",
      titulo: "Mín/Máx",
      renderizar: (item: StockProducto) => (
        <span className="text-sm text-muted-foreground">
          {item.cantidadMinima} / {item.cantidadMaxima}
        </span>
      ),
    },
    {
      clave: "ubicacion",
      titulo: "Ubicación",
      renderizar: (item: StockProducto) => item.ubicacion || "-",
    },
    {
      clave: "ultimaActualizacion",
      titulo: "Últ. Act.",
      renderizar: (item: StockProducto) =>
        formatearFecha(item.ultimaActualizacion),
    },
    {
      clave: "acciones",
      titulo: "Acciones",
      renderizar: (item: StockProducto) => (
        <div className="flex items-center gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => onAjustar(item)}
            title="Ajustar Stock"
          >
            <Pencil className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            onClick={() => onVerKardex(item)}
            title="Ver Kardex"
          >
            <History className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  return (
    <TablaPaginada datos={stock} columnas={columnas} cargando={isLoading} />
  );
}
