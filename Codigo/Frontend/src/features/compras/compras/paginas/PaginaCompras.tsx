import { useState, useEffect } from "react";
import { Plus, Eye, Trash2 } from "lucide-react";
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
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";

// Correction: imports for specific hooks
import { useCompras, useCompra, useEliminarCompra } from "../hooks/useCompras";
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
import { Compra } from "../types/compra.types";
import { CompraForm } from "../componentes/CompraForm"; // Form component for creating

export default function PaginaCompras() {
  const location = useLocation();
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [compraSeleccionada, setCompraSeleccionada] = useState<Compra | null>(
    null,
  ); // For viewing details
  const [modoCreacion, setModoCreacion] = useState(false);
  const [datosIniciales, setDatosIniciales] = useState<any>(null);
  const [filtro, setFiltro] = useState("");
  const [idAVisualizar, setIdAVisualizar] = useState<number | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data: compras, isLoading, error } = useCompras();
  const { data: compraDetalle, isLoading: cargandoDetalle } = useCompra(
    idAVisualizar || 0,
  );
  const eliminarMutation = useEliminarCompra();

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
        observaciones: `Carga desde Orden ${orden.codigoOrden}. ${orden.observaciones || ""}`,
        detalles: orden.detalles.map((d: any) => ({
          idProducto: d.idProducto,
          cantidad: d.cantidadSolicitada,
          precioUnitario: d.precioUnitarioPactado,
        })),
      };
      setDatosIniciales(iniciales);
      setModoCreacion(true);
      setDialogoOpen(true);
      // Limpiar el estado para no re-abrir al refrescar o navegar
      window.history.replaceState({}, document.title);
    }
  }, [location]);

  const comprasFiltradas =
    compras?.filter(
      (c) =>
        c.serieComprobante.includes(filtro) ||
        c.numeroComprobante.includes(filtro) ||
        c.id.toString().includes(filtro),
    ) || [];

  const columnas = [
    {
      header: "Fecha",
      accessorKey: "fechaEmision" as keyof Compra,
      cell: (row: Compra) =>
        formatFecha(new Date(row.fechaEmision), "dd/MM/yyyy"),
    },
    {
      header: "Proveedor",
      accessorKey: "razonSocialProveedor" as keyof Compra,
      cell: (row: Compra) =>
        row.razonSocialProveedor || `Prov. #${row.idProveedor}`,
    },
    {
      header: "Comprobante",
      accessorKey: "numeroComprobante" as keyof Compra,
      cell: (row: Compra) => (
        <span className="font-mono text-xs">
          {row.serieComprobante}-{row.numeroComprobante}
        </span>
      ),
    },
    {
      header: "Almacén",
      accessorKey: "nombreAlmacen" as keyof Compra,
      cell: (row: Compra) => row.nombreAlmacen || `Alm. #${row.idAlmacen}`,
    },
    {
      header: "Total",
      accessorKey: "total" as keyof Compra,
      className: "text-right font-semibold",
      cell: (row: Compra) => row.total.toFixed(2),
    },
    {
      header: "Estado",
      accessorKey: "estado" as keyof Compra,
      cell: (row: Compra) => (
        <Badge variant={row.estado === "CONFIRMADO" ? "default" : "secondary"}>
          {row.estado}
        </Badge>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: Compra) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => {
              setIdAVisualizar(row.id);
              setModoCreacion(false);
              setDialogoOpen(true);
            }}
          >
            <Eye className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="text-destructive hover:text-destructive hover:bg-destructive/10"
            onClick={(e) => {
              e.stopPropagation();
              setEliminarId(row.id);
            }}
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  if (isLoading) return <Loading mensaje="Cargando historial de compras..." />;
  if (error) return <MensajeError mensaje="Error al cargar compras" />;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Gestión de Compras</h1>
        <p className="text-muted-foreground">
          Registro de ingresos de mercadería y gestión de costos.
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Historial de Compras</CardTitle>
          <CardDescription>
            Documentos registrados en el sistema.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <DataTable
            data={comprasFiltradas}
            columns={columnas}
            onSearchChange={setFiltro}
            searchPlaceholder="Buscar por número o proveedor..."
            actionElement={
              <Button
                onClick={() => {
                  setCompraSeleccionada(null);
                  setDatosIniciales(null);
                  setModoCreacion(true);
                  setDialogoOpen(true);
                }}
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
              {modoCreacion ? "Nueva Compra (Ingreso)" : "Detalle de Compra"}
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
                    idAlmacen: compraSeleccionada.idAlmacen,
                    idMoneda: compraSeleccionada.idMoneda,
                    tipoComprobante:
                      compraSeleccionada.idTipoComprobante.toString(),
                    serieComprobante: compraSeleccionada.serieComprobante,
                    numeroComprobante: compraSeleccionada.numeroComprobante,
                    fechaEmision: new Date(compraSeleccionada.fechaEmision),
                    observaciones: compraSeleccionada.observaciones,
                    detalles: compraDetalle?.detalles.map((d) => ({
                      idProducto: d.idProducto,
                      cantidad: d.cantidad,
                      precioUnitario: d.precioUnitarioCompra,
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
    </div>
  );
}
