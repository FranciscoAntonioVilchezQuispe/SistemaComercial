import { MoveDown, MoveUp, RefreshCw, ArrowLeftRight, Eye } from "lucide-react";
import { MovimientoResumen } from "../../tipos/inventario.types";
import { DataTable } from "@/componentes/ui/DataTable";
import { PagedResponse } from "@/types/pagination.types";
import { formatearFechaHora, formatearMoneda } from "@compartido/utilidades";
import { Button } from "@/components/ui/button";

interface Props {
  movimientos: MovimientoResumen[];
  isLoading: boolean;
  pagination?: PagedResponse<MovimientoResumen>;
  onPageChange?: (page: number) => void;
  onPageSizeChange?: (pageSize: number) => void;
  onSearchChange?: (search: string) => void;
  onVerDetalle?: (id: number) => void;
}

export function TablaMovimientos({
  movimientos,
  isLoading,
  pagination,
  onPageChange,
  onPageSizeChange,
  onSearchChange,
  onVerDetalle,
}: Props) {
  const getIconoTipo = (nombreTipo: string) => {
    const tipo = nombreTipo.toLowerCase();
    if (tipo.includes("entrada")) return <MoveUp className="h-4 w-4 text-green-500" />;
    if (tipo.includes("salida")) return <MoveDown className="h-4 w-4 text-destructive" />;
    if (tipo.includes("ajuste")) return <RefreshCw className="h-4 w-4 text-blue-500" />;
    if (tipo.includes("traslado")) return <ArrowLeftRight className="h-4 w-4 text-orange-500" />;
    return <RefreshCw className="h-4 w-4 text-muted-foreground" />;
  };

  const columnas = [
    {
      clave: "fechaCreacion",
      titulo: "Fecha y Hora",
      renderizar: (m: MovimientoResumen) => formatearFechaHora(m.fechaCreacion),
    },
    {
      clave: "productoNombre",
      titulo: "Producto",
      renderizar: (m: MovimientoResumen) => (
        <span className="font-medium">
          {m.productoNombre}
        </span>
      ),
    },
    {
      clave: "tipoMovimientoNombre",
      titulo: "Tipo",
      renderizar: (m: MovimientoResumen) => (
        <div className="flex items-center gap-2">
          {getIconoTipo(m.tipoMovimientoNombre)}
          <span>{m.tipoMovimientoNombre}</span>
        </div>
      ),
    },
    {
      clave: "entrada",
      titulo: "Monto Unit.",
      renderizar: (m: MovimientoResumen) => (
        <div className="text-right font-medium">
          {formatearMoneda(m.costoUnitarioMovimiento)}
        </div>
      ),
    },
    {
      clave: "cantidad",
      titulo: "Cantidad",
      renderizar: (m: MovimientoResumen) => {
        const esEntrada = m.tipoMovimientoNombre.toLowerCase().includes("entrada");
        return (
          <div className="text-right">
            <span className={`font-bold ${esEntrada ? 'text-green-600' : 'text-destructive'}`}>
              {esEntrada ? "+" : ""}{m.cantidad.toFixed(2)}
            </span>
          </div>
        );
      },
    },
    {
      clave: "almacenNombre",
      titulo: "Almacén",
      renderizar: (m: MovimientoResumen) => m.almacenNombre,
    },
    {
      clave: "referencia",
      titulo: "Referencia",
      renderizar: (m: MovimientoResumen) => (
        <span className="text-sm font-mono">{m.referenciaModulo || "Manual"}</span>
      ),
    },
    {
      clave: "acciones",
      titulo: "Acciones",
      className: "text-right",
      renderizar: (m: MovimientoResumen) => (
        <div className="flex justify-end">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => onVerDetalle?.(m.id)}
            title="Ver Trazabilidad"
          >
            <Eye className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  return (
    <DataTable
      data={movimientos}
      columns={columnas.map((c) => ({
        header: c.titulo,
        accessorKey: c.clave as any,
        cell: c.renderizar,
      }))}
      isLoading={isLoading}
      pagination={pagination}
      onPageChange={onPageChange}
      onPageSizeChange={onPageSizeChange}
      onSearchChange={onSearchChange}
    />
  );
}
