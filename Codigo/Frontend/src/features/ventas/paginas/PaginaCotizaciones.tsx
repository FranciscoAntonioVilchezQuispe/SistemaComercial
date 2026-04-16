import { useNavigate } from "react-router-dom";
import { useState } from "react";
import { toast } from "sonner";
import { useCotizaciones } from "../hooks/useVentas";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import { Plus, Eye, FileText, MoreHorizontal } from "lucide-react";

import { usePagination } from "@/hooks/usePagination";
import { DataTable } from "@/componentes/ui/DataTable";
import { formatearMoneda, formatearFechaHora } from "@compartido/utilidades";
import { Badge } from "@/components/ui/badge";
import { ModalDetalleCotizacion } from "../componentes/cotizaciones/ModalDetalleCotizacion";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

export function PaginaCotizaciones() {
  const navigate = useNavigate();
  const { paginacion, cambiarPagina, cambiarPageSize, cambiarBusqueda } = usePagination();

  // Estados para el detalle diferido (Two-Call Pattern)
  const [modalDetalleOpen, setModalDetalleOpen] = useState(false);
  const [selectedCotizacionId, setSelectedCotizacionId] = useState<number | null>(null);

  const { data, isLoading } = useCotizaciones(paginacion);
  const cotizaciones = data?.datos || [];

  const handleVerDetalle = (id: number) => {
    setSelectedCotizacionId(id);
    setModalDetalleOpen(true);
  };

  const tabsVentas = [
    { label: RUTAS_TITULOS["/ventas/pos"], to: "/ventas/pos" },
    { label: RUTAS_TITULOS["/ventas/lista"], to: "/ventas/lista" },
    { label: RUTAS_TITULOS["/ventas/notas"], to: "/ventas/notas" },
    { label: RUTAS_TITULOS["/ventas/cotizaciones"], to: "/ventas/cotizaciones" },
    { label: RUTAS_TITULOS["/clientes"], to: "/clientes" },
  ];

  const columns = [
    {
      header: "Comprobante",
      accessorKey: "numero" as any,
      cell: (cot: any) => (
        <div className="flex flex-col">
          <span className="font-medium">{cot.serie}-{cot.numero}</span>
          <span className="text-xs text-muted-foreground">
            Cotización
          </span>
        </div>
      ),
    },
    {
      header: "Fecha",
      cell: (cot: any) => formatearFechaHora(cot.fechaEmision),
    },
    {
      header: "Vencimiento",
      cell: (cot: any) => (cot.fechaVencimiento ? formatearFechaHora(cot.fechaVencimiento) : "-"),
    },
    {
      header: "Cliente",
      cell: (cot: any) => cot.clienteNombre || "Cliente General",
    },
    {
      header: "Total",
      cell: (cot: any) => (
        <span className="font-bold">{formatearMoneda(cot.totalCotizacion)}</span>
      ),
    },
    {
      header: "Estado",
      cell: (cot: any) => (
        <Badge
          variant={
            cot.idEstado === 1 // Aprobada
              ? "default"
              : cot.idEstado === 0 // Borrador/Pendiente
                ? "secondary"
                : "destructive" // Rechazada/Expirada
          }
        >
          {cot.estadoNombre}
        </Badge>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (cot: any) => (
        <div className="flex items-center justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => handleVerDetalle(cot.id)}
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
              <DropdownMenuLabel>Opciones</DropdownMenuLabel>
              <DropdownMenuItem onClick={() => toast.info("Próximamente: exportar PDF")}>
                <FileText className="mr-2 h-4 w-4" />
                Exportar PDF
              </DropdownMenuItem>
              <DropdownMenuItem onClick={() => toast.info("Próximamente: convertir a venta")}>
                <Plus className="mr-2 h-4 w-4" />
                Convertir a Venta
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem className="text-destructive">
                Eliminar
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
        <Button onClick={() => navigate("/ventas/pos")} size="sm">
          <Plus className="mr-2 h-4 w-4" />
          Nueva Cotización
        </Button>
      </div>

      <Card>
        <CardContent className="p-6">
          <DataTable 
            data={cotizaciones} 
            columns={columns} 
            pagination={data}
            onPageChange={cambiarPagina}
            onPageSizeChange={cambiarPageSize}
            onSearchChange={cambiarBusqueda}
            isLoading={isLoading}
            searchPlaceholder="Buscar por serie, número o cliente..."
          />
        </CardContent>
      </Card>

      <ModalDetalleCotizacion 
        id={selectedCotizacionId}
        isOpen={modalDetalleOpen}
        onClose={() => setModalDetalleOpen(false)}
        onConvertir={(id) => navigate(`/ventas/pos?cotizacion=${id}`)}
      />
    </div>
  );
}
