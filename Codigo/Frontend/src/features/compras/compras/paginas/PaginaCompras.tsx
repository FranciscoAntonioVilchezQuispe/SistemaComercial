import { useState, useEffect } from "react";
import { Plus, Eye } from "lucide-react";
import { useLocation } from "react-router-dom";
import { formatFecha, quedenMenosDe24Horas } from "@compartido/utilidades";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { DataTable } from "@/components/ui/DataTable";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import { useCompras, useCompra, useEliminarCompra } from "../hooks/useCompras";
import { usePagination } from "@/hooks/usePagination";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { CompraResumen, CompraDetalle } from "../types/compra.types";
import { CompraForm } from "../componentes/CompraForm";
import { ModalAnularCompra } from "../componentes/ModalAnularCompra";
import { ModalCrearNotaSunatCompra } from "../componentes/ModalCrearNotaSunatCompra";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { MoreHorizontal, FileMinus, RefreshCcw } from "lucide-react";
import { EstadoDocumento } from "@compartido/enums";

const ESTADO_COMPRA_COLORES: Record<number, string> = {
  [EstadoDocumento.Registrado]: "bg-blue-50 text-blue-700 border-blue-200",
  [EstadoDocumento.AnuladoDirecto]: "bg-red-50 text-red-700 border-red-200",
  [EstadoDocumento.AnuladoNotaCredito]: "bg-orange-50 text-orange-700 border-orange-200",
  [EstadoDocumento.AnuladoNotaDebito]: "bg-purple-50 text-purple-700 border-purple-200",
  [EstadoDocumento.Completado]: "bg-green-50 text-green-700 border-green-200",
  [EstadoDocumento.Pendiente]: "bg-amber-50 text-amber-700 border-amber-200",
  [EstadoDocumento.Rechazado]: "bg-gray-50 text-gray-700 border-gray-200",
};

export function PaginaCompras() {
  const location = useLocation();
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [compraSeleccionada, setCompraSeleccionada] = useState<CompraDetalle | null>(
    null,
  ); // For viewing details
  const [modoCreacion, setModoCreacion] = useState(false);
  const [datosIniciales, setDatosIniciales] = useState<any>(null);
  const [idAVisualizar, setIdAVisualizar] = useState<number | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);
  
  // Estados para nuevas acciones
  const [compraAAnular, setCompraAAnular] = useState<CompraResumen | null>(null);
  const [mostrarAnular, setMostrarAnular] = useState(false);
  const [compraParaNotaId, setCompraParaNotaId] = useState<number | null>(null);
  const [mostrarCrearNota, setMostrarCrearNota] = useState(false);

  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
    cambiarFiltroActivo,
  } = usePagination();

  const { data, isLoading, error, refetch } = useCompras(paginacion);
  const { data: compraDetalle, isLoading: cargandoDetalle } = useCompra(
    idAVisualizar || 0,
  );
  
  const compras = data?.datos || [];
  const eliminarMutation = useEliminarCompra();

  const tabsCompras = [
    { label: RUTAS_TITULOS["/proveedores/ordenes"], to: "/proveedores/ordenes" },
    { label: RUTAS_TITULOS["/compras/lista"], to: "/compras/lista" },
    { label: RUTAS_TITULOS["/compras/notas"], to: "/compras/notas" },
    { label: RUTAS_TITULOS["/proveedores"], to: "/proveedores" },
  ];

  useEffect(() => {
    if (compraDetalle && !modoCreacion) {
      setCompraSeleccionada(compraDetalle);
    }
  }, [compraDetalle, modoCreacion]);

  useEffect(() => {
    if (!dialogoOpen) {
      setIdAVisualizar(null);
      if (!modoCreacion) {
        setCompraSeleccionada(null);
      }
    }
  }, [dialogoOpen, modoCreacion]);

  useEffect(() => {
    const state = location.state as { orden?: any };
    if (state?.orden) {
      const orden = state.orden;
      // Mapear OrdenCompra a CompraFormValues
      const iniciales = {
        idProveedor: orden.idProveedor,
        idAlmacen: orden.idAlmacenDestino,
        idOrdenCompraRef: orden.id,
        observaciones: `Carga desde Orden ${orden.codigoOrden}. ${orden.observaciones || ""}`,
        detalles: orden.detalles.map((d: any) => ({
          idProducto: d.idProducto,
          cantidad: d.cantidadSolicitada,
          precioUnitario: d.precioUnitarioPactado,
          afectacionIgv: "10",
        })),
      };
      setDatosIniciales(iniciales);
      setModoCreacion(true);
      setDialogoOpen(true);
      // Limpiar el estado para no re-abrir al refrescar o navegar
      window.history.replaceState({}, document.title);
    }
  }, [location]);


  const columnas = [
    {
      header: "Fecha",
      accessorKey: "fechaEmision" as keyof CompraResumen,
      cell: (row: CompraResumen) =>
        formatFecha(new Date(row.fechaEmision), "dd/MM/yyyy"),
    },
    {
      header: "Proveedor",
      accessorKey: "razonSocialProveedor" as keyof CompraResumen,
      cell: (row: CompraResumen) =>
        row.razonSocialProveedor || `Prov.`,
    },
    {
      header: "Comprobante",
      accessorKey: "numeroComprobante" as keyof CompraResumen,
      cell: (row: CompraResumen) => (
        <span className="font-mono text-xs">
          {row.serieComprobante}-{row.numeroComprobante}
        </span>
      ),
    },
    {
      header: "T. Comp",
      accessorKey: "tipoComprobanteNombre" as keyof CompraResumen,
    },
    {
      header: "Total",
      accessorKey: "total" as keyof CompraResumen,
      className: "text-right font-semibold",
      cell: (row: CompraResumen) => row.total.toFixed(2),
    },
    {
      header: "Estado",
      accessorKey: "estadoNombre" as keyof CompraResumen,
      cell: (row: CompraResumen) => (
        <Badge
          variant="outline"
          className={ESTADO_COMPRA_COLORES[row.idEstado] || "bg-gray-100 text-gray-700"}
        >
          {row.estadoNombre}
        </Badge>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: CompraResumen) => (
        <div className="flex justify-end gap-2 text-right">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon">
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuLabel>Acciones de Compra</DropdownMenuLabel>
              <DropdownMenuItem onClick={() => {
                setIdAVisualizar(row.id);
                setModoCreacion(false);
                setDialogoOpen(true);
              }}>
                <Eye className="mr-2 h-4 w-4" />
                Ver Detalle
              </DropdownMenuItem>
              {/* Solo mostrar opciones de anulación si el documento NO está ya anulado (v1.0) */}
              {![EstadoDocumento.AnuladoDirecto, EstadoDocumento.AnuladoNotaCredito, EstadoDocumento.AnuladoNotaDebito].includes(row.idEstado) && (
                <>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem 
                    onClick={() => {
                      setCompraParaNotaId(row.id);
                      setMostrarCrearNota(true);
                    }}
                  >
                    <FileMinus className="mr-2 h-4 w-4" />
                    Emitir Nota (NC/ND)
                  </DropdownMenuItem>

                  {/* La anulación directa solo es visible en las primeras 24 horas (v1.0) */}
                  {quedenMenosDe24Horas(row.fechaCreacion) && (
                    <DropdownMenuItem 
                      className="text-destructive font-medium" 
                      onClick={() => {
                        setCompraAAnular(row);
                        setMostrarAnular(true);
                      }}
                    >
                      <RefreshCcw className="mr-2 h-4 w-4 text-destructive" />
                      Anular Compra
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

  if (isLoading) return <Loading mensaje="Cargando historial de compras..." />;
  if (error) return <MensajeError mensaje="Error al cargar compras" />;

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsCompras} />

      <Card className="shadow-none border-muted/20">
        <CardContent className="pt-6">
          <DataTable
            data={compras}
            columns={columnas}
            pagination={data}
            onPageChange={cambiarPagina}
            onPageSizeChange={cambiarPageSize}
            onSearchChange={cambiarBusqueda}
            onActiveFilterChange={cambiarFiltroActivo}
            searchPlaceholder="Buscar por número o proveedor..."
            isLoading={isLoading}
            actionElement={
              <Button
                onClick={() => {
                  setCompraSeleccionada(null);
                  setDatosIniciales(null);
                  setModoCreacion(true);
                  setDialogoOpen(true);
                }}
                size="sm"
              >
                <Plus className="mr-2 h-4 w-4" /> Registrar Compra
              </Button>
            }
          />
        </CardContent>
      </Card>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>
              {modoCreacion
                ? "Nueva Compra (Ingreso)"
                : `Detalle de Compra - ${compraSeleccionada?.tipoComprobanteNombre} : ${compraSeleccionada?.serieComprobante}-${compraSeleccionada?.numeroComprobante}`}
            </DialogTitle>
          </DialogHeader>

          {cargandoDetalle ? (
            <Loading mensaje="Cargando detalle de compra..." />
          ) : modoCreacion ? (
            <CompraForm
              datosIniciales={datosIniciales}
              onSuccess={() => {
                toast.success("Compra registrada exitosamente");
                setDialogoOpen(false);
              }}
              onCancel={() => setDialogoOpen(false)}
            />
          ) : (
            compraSeleccionada && (
              <CompraForm
                readOnly
                datosIniciales={
                  {
                    idProveedor: compraSeleccionada.idProveedor,
                    razonSocialProveedor:
                      compraSeleccionada.razonSocialProveedor,
                    numeroDocumentoProveedor:
                      compraSeleccionada.numeroDocumentoProveedor,
                    idAlmacen: compraSeleccionada.idAlmacen,
                    idMoneda:
                      compraSeleccionada.idMoneda,
                    tipoComprobante:
                      compraSeleccionada.idTipoComprobante.toString(),
                    serieComprobante: compraSeleccionada.serieComprobante,
                    numeroComprobante: compraSeleccionada.numeroComprobante,
                    fechaEmision: new Date(compraSeleccionada.fechaEmision),
                    observaciones: compraSeleccionada.observaciones,
                    detalles: compraSeleccionada.detalles.map((d) => ({
                      idProducto: d.idProducto,
                      cantidad: d.cantidad,
                      precioUnitario: d.precioUnitarioCompra,
                      afectacionIgv: "10", // o d.afectacionIgv si viene de backend
                    })),
                  } as any
                }
                onSuccess={() => setDialogoOpen(false)}
                onCancel={() => setDialogoOpen(false)}
              />
            )
          )}
        </DialogContent>
      </Dialog>

      <AlertDialog
        open={eliminarId !== null}
        onOpenChange={(open) => !open && setEliminarId(null)}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Está absolutamente seguro?</AlertDialogTitle>
            <AlertDialogDescription>
              Esta acción desactivará la compra y revertirá los movimientos de
              inventario asociados. Las órdenes de compra vinculadas serán
              liberadas.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={async () => {
                if (eliminarId) {
                  try {
                    await eliminarMutation.mutateAsync(eliminarId);
                    toast.success("Compra eliminada correctamente");
                  } catch (err) {
                    console.error("Error al eliminar la compra:", err);
                  } finally {
                    setEliminarId(null);
                  }
                }
              }}
            >
              {eliminarMutation.isPending ? "Eliminando..." : "Sí, eliminar"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      {/* Modales de Anulación y Notas */}
      <ModalAnularCompra
        compra={compraAAnular}
        open={mostrarAnular}
        onOpenChange={setMostrarAnular}
        onSuccess={() => refetch()}
      />

      <ModalCrearNotaSunatCompra
        idCompra={compraParaNotaId}
        open={mostrarCrearNota}
        onOpenChange={setMostrarCrearNota}
        onSuccess={() => refetch()}
      />
    </div>
  );
}
