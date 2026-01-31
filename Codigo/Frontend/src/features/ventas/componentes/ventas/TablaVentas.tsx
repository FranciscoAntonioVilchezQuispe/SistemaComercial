import { Eye, FileText, MoreHorizontal } from "lucide-react";
import { Venta } from "../../tipos/ventas.types";
import { TablaPaginada } from "@/compartido/componentes/tablas/TablaPaginada";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { formatearMoneda } from "@/compartido/utilidades/formateo/formatearMoneda";
import { formatearFechaHora } from "@/compartido/utilidades/formateo/formatearFecha";

interface Props {
  ventas: Venta[];
  isLoading: boolean;
  onVerDetalle: (venta: Venta) => void;
  onGenerarTicket: (venta: Venta) => void;
  onGenerarFactura: (venta: Venta) => void;
}

export function TablaVentas({
  ventas,
  isLoading,
  onVerDetalle,
  onGenerarTicket,
  onGenerarFactura,
}: Props) {
  const columnas = [
    {
      clave: "numeroComprobante",
      titulo: "Comprobante",
      renderizar: (venta: Venta) => (
        <div className="flex flex-col">
          <span className="font-medium">{venta.numeroComprobante}</span>
          <span className="text-xs text-muted-foreground">
            {venta.tipoComprobante}
          </span>
        </div>
      ),
    },
    {
      clave: "fecha",
      titulo: "Fecha",
      renderizar: (venta: Venta) => formatearFechaHora(venta.fecha),
    },
    {
      clave: "cliente",
      titulo: "Cliente",
      renderizar: (venta: Venta) => venta.cliente?.nombres || "Cliente General",
    },
    {
      clave: "total",
      titulo: "Total",
      renderizar: (venta: Venta) => (
        <span className="font-bold">{formatearMoneda(venta.total)}</span>
      ),
    },
    {
      clave: "estado",
      titulo: "Estado",
      renderizar: (venta: Venta) => (
        <Badge
          variant={
            venta.idEstado === 1 // Completada
              ? "default"
              : venta.idEstado === 2 // Pendiente
                ? "secondary"
                : "destructive" // Anulada
          }
        >
          {venta.estado || "Completada"}
        </Badge>
      ),
    },
    {
      clave: "estadoPago",
      titulo: "Pago",
      renderizar: (venta: Venta) => (
        <Badge
          variant={venta.idEstadoPago === 1 ? "outline" : "secondary"}
          className={
            venta.idEstadoPago === 1 ? "border-green-500 text-green-500" : ""
          }
        >
          {venta.estadoPago || "Pagado"}
        </Badge>
      ),
    },
    {
      clave: "acciones",
      titulo: "Acciones",
      renderizar: (venta: Venta) => (
        <div className="flex items-center gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => onVerDetalle(venta)}
            title="Ver Detalle"
          >
            <Eye className="h-4 w-4" />
          </Button>

          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon">
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuLabel>Comprobantes</DropdownMenuLabel>
              <DropdownMenuItem onClick={() => onGenerarTicket(venta)}>
                <FileText className="mr-2 h-4 w-4" />
                Ticket
              </DropdownMenuItem>
              <DropdownMenuItem onClick={() => onGenerarFactura(venta)}>
                <FileText className="mr-2 h-4 w-4" />
                Factura / Boleta
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem className="text-destructive">
                Anular Venta
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      ),
    },
  ];

  return (
    <TablaPaginada datos={ventas} columnas={columnas} cargando={isLoading} />
  );
}
