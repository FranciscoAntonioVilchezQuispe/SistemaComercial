import { useNavigate } from "react-router-dom";
import { toast } from "sonner";
import { useVentas } from "../hooks/useVentas";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Venta } from "../tipos/ventas.types";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import { Plus, Eye, FileText, MoreHorizontal } from "lucide-react";

import { usePagination } from "@/hooks/usePagination";
import { DataTable } from "@/componentes/ui/DataTable";
import { formatearMoneda, formatearFechaHora } from "@compartido/utilidades";
import { Badge } from "@/components/ui/badge";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

export function PaginaVentas() {
  const navigate = useNavigate();
  const { paginacion, cambiarPagina, cambiarPageSize, cambiarBusqueda } = usePagination();

  const { data, isLoading } = useVentas(paginacion);
  const ventas = data?.datos || [];

  const handleVerDetalle = (_venta: Venta) => {
    toast.info("Próximamente: ver detalle de venta");
  };

  const handleNuevoPOS = () => {
    navigate("/ventas/pos");
  };

  const tabsVentas = [
    { label: RUTAS_TITULOS["/ventas/pos"], to: "/ventas/pos" },
    { label: RUTAS_TITULOS["/ventas/lista"], to: "/ventas/lista" },
    { label: RUTAS_TITULOS["/ventas/cotizaciones"], to: "/ventas/cotizaciones" },
    { label: RUTAS_TITULOS["/clientes"], to: "/clientes" },
  ];

  const columns = [
    {
      header: "Comprobante",
      accessorKey: "numeroComprobante" as keyof Venta,
      cell: (venta: Venta) => (
        <div className="flex flex-col">
          <span className="font-medium">{venta.numeroComprobante}</span>
          <span className="text-xs text-muted-foreground">
            {venta.tipoComprobante || 'Venta'}
          </span>
        </div>
      ),
    },
    {
      header: "Fecha",
      cell: (venta: Venta) => formatearFechaHora(venta.fecha),
    },
    {
      header: "Cliente",
      cell: (venta: Venta) =>
        venta.cliente?.razonSocial || "Cliente General",
    },
    {
      header: "Total",
      cell: (venta: Venta) => (
        <span className="font-bold">{formatearMoneda(venta.total)}</span>
      ),
    },
    {
      header: "Estado",
      cell: (venta: Venta) => (
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
      header: "Pago",
      cell: (venta: Venta) => (
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
      header: "Acciones",
      className: "text-right",
      cell: (venta: Venta) => (
        <div className="flex items-center justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => handleVerDetalle(venta)}
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
              <DropdownMenuItem onClick={() => toast.info("Próximamente: generar ticket")}>
                <FileText className="mr-2 h-4 w-4" />
                Ticket
              </DropdownMenuItem>
              <DropdownMenuItem onClick={() => toast.info("Próximamente: generar factura")}>
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
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsVentas} />

      <div className="flex justify-end gap-2">
        <Button onClick={handleNuevoPOS} size="sm">
          <Plus className="mr-2 h-4 w-4" />
          Nueva Venta (POS)
        </Button>
      </div>

      <Card>
        <CardContent className="p-6">
          <DataTable 
            data={ventas} 
            columns={columns} 
            pagination={data}
            onPageChange={cambiarPagina}
            onPageSizeChange={cambiarPageSize}
            onSearchChange={cambiarBusqueda}
            isLoading={isLoading}
            searchPlaceholder="Buscar por número o cliente..."
          />
        </CardContent>
      </Card>
    </div>
  );
}
