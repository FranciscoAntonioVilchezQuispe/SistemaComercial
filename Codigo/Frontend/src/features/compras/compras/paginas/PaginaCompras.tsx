import { useState, useEffect } from "react";
import { Plus, Eye } from "lucide-react";
import { useLocation } from "react-router-dom";
import { formatFecha } from "@compartido/utilidades";
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
  const [compraParaNota, setCompraParaNota] = useState<CompraResumen | null>(null);
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
        <Badge variant={row.estadoNombre === "CONFIRMADO" ? "default" : "secondary"}>
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
              <DropdownMenuSeparator />
              <DropdownMenuItem 
                onClick={() => {
                  setCompraParaNota(row);
                  setMostrarCrearNota(true);
                }}
                disabled={row.estadoNombre === "ANULADO"}
              >
                <FileMinus className="mr-2 h-4 w-4" />
                Emitir Nota (NC/ND)
              </DropdownMenuItem>
              <DropdownMenuItem 
                className="text-destructive" 
                onClick={() => {
                  setCompraAAnular(row);
                  setMostrarAnular(true);
                }}
                disabled={row.estadoNombre === "ANULADO"}
              >
                <RefreshCcw className="mr-2 h-4 w-4" />
                Anular Compra
              </DropdownMenuItem>
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
                    toast.error("Error al eliminar la compra");
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
        compra={compraParaNota}
        open={mostrarCrearNota}
        onOpenChange={setMostrarCrearNota}
        onSuccess={() => refetch()}
      />
    </div>
  );
}
