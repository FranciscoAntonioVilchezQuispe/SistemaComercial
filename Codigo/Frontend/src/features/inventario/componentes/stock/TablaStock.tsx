import { AlertTriangle, History, Pencil } from "lucide-react";
import { StockProducto } from "../../tipos/inventario.types";
import { DataTable } from "@/componentes/ui/DataTable";
import { PagedResponse } from "@/types/pagination.types";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { formatearFechaHora } from "@compartido/utilidades";

interface Props {
  stock: StockProducto[];
  isLoading: boolean;
  pagination?: PagedResponse<StockProducto>;
  onPageChange?: (page: number) => void;
  onPageSizeChange?: (pageSize: number) => void;
  onSearchChange?: (search: string) => void;
  onAjustar: (item: StockProducto) => void;
  onVerKardex: (item: StockProducto) => void;
}

export function TablaStock({
  stock,
  isLoading,
  pagination,
  onPageChange,
  onPageSizeChange,
  onSearchChange,
  onAjustar,
  onVerKardex,
}: Props) {
  const columnas = [
    {
      header: "Producto",
      cell: (item: StockProducto) => (
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
      header: "Almacén",
      cell: (item: StockProducto) => item.almacen || "Almacén Principal",
    },
    {
      header: "Stock",
      cell: (item: StockProducto) => {
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
      header: "Mín/Máx",
      cell: (item: StockProducto) => (
        <span className="text-sm text-muted-foreground">
          {item.cantidadMinima} / {item.cantidadMaxima}
        </span>
      ),
    },
    {
      header: "Ubicación",
      cell: (item: StockProducto) => item.ubicacion || "-",
    },
    {
      header: "Últ. Act.",
      cell: (item: StockProducto) =>
        formatearFechaHora(item.ultimaActualizacion),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (item: StockProducto) => (
        <div className="flex items-center justify-end gap-2">
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
    <DataTable
      data={stock}
      columns={columnas}
      isLoading={isLoading}
      pagination={pagination}
      onPageChange={onPageChange}
      onPageSizeChange={onPageSizeChange}
      onSearchChange={onSearchChange}
    />
  );
}
