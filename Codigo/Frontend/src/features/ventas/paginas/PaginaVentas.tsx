import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { toast } from "sonner";
import { useVentas } from "../hooks/useVentas";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { VentaResumen } from "../tipos/ventas.types";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import { Plus, Eye, FileText, MoreHorizontal, ReceiptText, RefreshCcw } from "lucide-react";

import { usePagination } from "@/hooks/usePagination";
import { DataTable, DataTableColumn } from "@/componentes/ui/DataTable";
import { formatearMoneda, formatearFechaHora, quedenMenosDe24Horas } from "@compartido/utilidades";
import { Badge } from "@/components/ui/badge";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { ModalVistaPreviaVenta } from "../componentes/ModalVistaPreviaVenta";
import { ModalAnularVenta } from "../componentes/ModalAnularVenta";
import { ModalCrearNotaSunat } from "../componentes/ModalCrearNotaSunat";
import { EstadoDocumento, EstadoPago } from "@compartido/enums";

const ESTADO_VENTA_COLORES: Record<number, string> = {
  [EstadoDocumento.Completado]: "bg-green-100 text-green-700 border-green-200 hover:bg-green-100",
  [EstadoDocumento.Pendiente]: "bg-amber-100 text-amber-700 border-amber-200 hover:bg-amber-100",
  [EstadoDocumento.AnuladoDirecto]: "bg-red-100 text-red-700 border-red-200 hover:bg-red-100",
  [EstadoDocumento.AnuladoNotaCredito]: "bg-orange-100 text-orange-700 border-orange-200 hover:bg-orange-100",
  [EstadoDocumento.AnuladoNotaDebito]: "bg-purple-100 text-purple-700 border-purple-200 hover:bg-purple-100",
};

const ESTADO_PAGO_COLORES: Record<number, string> = {
  [EstadoPago.Pagado]: "bg-emerald-50 text-emerald-700 border-emerald-200 hover:bg-emerald-50",
  [EstadoPago.Pendiente]: "bg-orange-50 text-orange-700 border-orange-200 hover:bg-orange-50",
  [EstadoPago.Parcial]: "bg-blue-50 text-blue-700 border-blue-200 hover:bg-blue-50",
  [EstadoPago.Credito]: "bg-purple-50 text-purple-700 border-purple-200 hover:bg-purple-50",
  [EstadoPago.Anulado]: "bg-red-50 text-red-700 border-red-200 hover:bg-red-50",
};

export function PaginaVentas() {
  const navigate = useNavigate();
  const { paginacion, cambiarPagina, cambiarPageSize, cambiarBusqueda } = usePagination();
  
  // Estado para el modal de vista previa
  const [ventaSeleccionadaId, setVentaSeleccionadaId] = useState<number | null>(null);
  const [mostrarVistaPrevia, setMostrarVistaPrevia] = useState(false);

  const { data, isLoading, refetch } = useVentas(paginacion);
  const ventas = data?.datos || [];

  // Estados para anulación y notas
  const [ventaAAnular, setVentaAAnular] = useState<VentaResumen | null>(null);
  const [mostrarAnular, setMostrarAnular] = useState(false);
  const [ventaParaNota, setVentaParaNota] = useState<VentaResumen | null>(null);
  const [mostrarCrearNota, setMostrarCrearNota] = useState(false);

  const handleVerDetalle = (venta: VentaResumen) => {
    setVentaSeleccionadaId(venta.id);
    setMostrarVistaPrevia(true);
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

  const columns: DataTableColumn<VentaResumen>[] = [
    {
      header: "Comprobante",
      cell: (venta: VentaResumen) => (
        <div className="flex flex-col">
          <span className="font-medium text-primary">
            {venta.serie}-{venta.numero.toString().padStart(8, '0')}
          </span>
          <span className="text-[10px] uppercase font-bold text-muted-foreground">
            {venta.tipoComprobanteNombre}
          </span>
        </div>
      ),
    },
    {
      header: "Fecha",
      cell: (venta: VentaResumen) => (
        <span className="text-sm">
          {formatearFechaHora(venta.fechaEmision)}
        </span>
      ),
    },
    {
      header: "Cliente",
      cell: (venta: VentaResumen) => (
        <div className="max-w-[200px] truncate" title={venta.clienteRazonSocial || "Consumidor Final"}>
          {venta.clienteRazonSocial || "Consumidor Final"}
        </div>
      ),
    },
    {
      header: "Total",
      cell: (venta: VentaResumen) => (
        <span className="font-bold text-base">
          {formatearMoneda(venta.totalVenta)}
        </span>
      ),
    },
    {
      header: "Estado",
      cell: (venta: VentaResumen) => (
        <Badge
          variant="outline"
          className={ESTADO_VENTA_COLORES[venta.idEstado] || "bg-gray-100 text-gray-700"}
        >
          {venta.estadoNombre}
        </Badge>
      ),
    },
    {
      header: "Pago",
      cell: (venta: VentaResumen) => (
        <Badge
          variant="outline"
          className={ESTADO_PAGO_COLORES[venta.idEstadoPago] || "bg-gray-100 text-gray-700"}
        >
          {venta.estadoPagoNombre}
        </Badge>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (venta: VentaResumen) => (
        <div className="flex items-center justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => handleVerDetalle(venta)}
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
              <DropdownMenuLabel>Acciones de Venta</DropdownMenuLabel>
              <DropdownMenuItem onClick={() => handleVerDetalle(venta)}>
                <ReceiptText className="mr-2 h-4 w-4" />
                Vista Previa
              </DropdownMenuItem>
              <DropdownMenuItem onClick={() => toast.info("Generando Ticket...")}>
                <FileText className="mr-2 h-4 w-4" />
                Imprimir Ticket
              </DropdownMenuItem>
              {/* Solo mostrar opciones de anulación si el documento NO está ya anulado (v1.0) */}
              {![EstadoDocumento.AnuladoDirecto, EstadoDocumento.AnuladoNotaCredito, EstadoDocumento.AnuladoNotaDebito].includes(venta.idEstado) && (
                <>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem 
                    onClick={() => {
                      setVentaParaNota(venta);
                      setMostrarCrearNota(true);
                    }}
                  >
                    <Plus className="mr-2 h-4 w-4" />
                    Emitir Nota (NC/ND)
                  </DropdownMenuItem>
                  
                  {/* La anulación directa solo es visible en las primeras 24 horas (v1.0) */}
                  {quedenMenosDe24Horas(venta.fechaCreacion) && (
                    <DropdownMenuItem 
                      className="text-destructive font-medium" 
                      onClick={() => {
                        setVentaAAnular(venta);
                        setMostrarAnular(true);
                      }}
                    >
                      <RefreshCcw className="mr-2 h-4 w-4 text-destructive" />
                      Anular Venta
                    </DropdownMenuItem>
                  )}
                </>
              )}
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
            searchValue={paginacion.search}
            isLoading={isLoading}
            searchPlaceholder="Buscar por número o cliente..."
          />
        </CardContent>
      </Card>

      {/* Modal de Vista Previa */}
      <ModalVistaPreviaVenta 
        idVenta={ventaSeleccionadaId}
        open={mostrarVistaPrevia}
        onOpenChange={setMostrarVistaPrevia}
      />

      {/* Modal de Anulación */}
      <ModalAnularVenta 
        venta={ventaAAnular}
        open={mostrarAnular}
        onOpenChange={setMostrarAnular}
        onSuccess={() => refetch()}
      />

      {/* Modal de Notas SUNAT */}
      <ModalCrearNotaSunat
        idVenta={ventaParaNota?.id || null}
        open={mostrarCrearNota}
        onOpenChange={setMostrarCrearNota}
        onSuccess={() => refetch()}
      />
    </div>
  );
}
