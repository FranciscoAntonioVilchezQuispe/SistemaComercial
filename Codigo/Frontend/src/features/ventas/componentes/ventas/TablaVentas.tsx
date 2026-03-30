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
import { formatearMoneda, formatearFechaHora } from "@compartido/utilidades";
import { EstadoVenta, EstadoPago } from "@compartido/enums";
import { toast } from "sonner";

const ESTADO_VENTA_COLORES: Record<number, string> = {
  [EstadoVenta.Completada]: "bg-green-100 text-green-700 border-green-200 hover:bg-green-100",
  [EstadoVenta.PendientePago]: "bg-amber-100 text-amber-700 border-amber-200 hover:bg-amber-100",
  [EstadoVenta.Anulada]: "bg-red-100 text-red-700 border-red-200 hover:bg-red-100",
};

const ESTADO_PAGO_COLORES: Record<number, string> = {
  [EstadoPago.Pagado]: "bg-emerald-50 text-emerald-700 border-emerald-200 hover:bg-emerald-50",
  [EstadoPago.Pendiente]: "bg-orange-50 text-orange-700 border-orange-200 hover:bg-orange-50",
  [EstadoPago.Parcial]: "bg-blue-50 text-blue-700 border-blue-200 hover:bg-blue-50",
  [EstadoPago.Credito]: "bg-purple-50 text-purple-700 border-purple-200 hover:bg-purple-50",
  [EstadoPago.Anulado]: "bg-red-50 text-red-700 border-red-200 hover:bg-red-50",
};

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
          <span className="font-medium text-primary">
            {venta.serie}-{venta.numeroFormateado}
          </span>
          <span className="text-xs text-muted-foreground uppercase font-bold">
            {venta.tipoComprobante || "NOTA DE VENTA"}
          </span>
        </div>
      ),
    },
    {
      clave: "fecha",
      titulo: "Fecha",
      renderizar: (venta: Venta) => (
        <span className="text-sm">
          {formatearFechaHora(venta.fechaEmision)}
        </span>
      ),
    },
    {
      clave: "cliente",
      titulo: "Cliente",
      renderizar: (venta: Venta) => (
        <div className="max-w-[200px] truncate" title={venta.nombreCliente || "Cliente General"}>
          {venta.nombreCliente || "Cliente General"}
        </div>
      ),
    },
    {
      clave: "total",
      titulo: "Total",
      renderizar: (venta: Venta) => (
        <span className="font-bold text-base">
          {formatearMoneda(venta.totalVenta)}
        </span>
      ),
    },
    {
      clave: "estado",
      titulo: "Estado",
      renderizar: (venta: Venta) => (
        <Badge
          variant="outline"
          className={ESTADO_VENTA_COLORES[venta.idEstado] || "bg-gray-100 text-gray-700"}
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
          variant="outline"
          className={ESTADO_PAGO_COLORES[venta.idEstadoPago] || "bg-gray-100 text-gray-700"}
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
            className="text-blue-600 hover:text-blue-700 hover:bg-blue-50"
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
              <DropdownMenuItem className="text-destructive" onClick={() => toast.warning("Funcionalidad de anulación en desarrollo")}>
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
