import { useState } from "react";
import {
  Plus,
  Eye,
  XCircle,
  ShoppingBag,
  CheckCircle,
} from "lucide-react";
import { formatFecha } from "@compartido/utilidades";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
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
import { DataTable } from "@/components/ui/DataTable";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import {
  useOrdenesCompra,
  useCambiarEstadoOrdenCompra,
  useOrdenCompra,
} from "../hooks/useOrdenesCompra";
import { OrdenCompra } from "../types/ordenCompra.types";
import { OrdenCompraForm } from "../componentes/OrdenCompraForm";
import {
  EstadoOrdenCompra,
  EstadoOrdenCompraEtiquetas,
} from "../../constantes";
import { usePagination } from "@/hooks/usePagination";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export function PaginaOrdenCompra() {
  const navigate = useNavigate();
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [ordenSeleccionada, setOrdenSeleccionada] =
    useState<OrdenCompra | null>(null);
  const [modoCreacion, setModoCreacion] = useState(false);
  const [eliminarId, setEliminarId] = useState<number | null>(null);
  
  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
    cambiarFiltroActivo,
  } = usePagination();

  const { data, isLoading, error } = useOrdenesCompra(paginacion);
  const cambiarEstado = useCambiarEstadoOrdenCompra();

  const ordenes = data?.datos || [];

  const { data: qDetalle, isLoading: isLoadingDetalle } = useOrdenCompra(
    ordenSeleccionada?.id || 0,
  );

  const ordenCompleta = !modoCreacion && qDetalle ? qDetalle : ordenSeleccionada;

  const tabsCompras = [
    { label: RUTAS_TITULOS["/proveedores/ordenes"], to: "/proveedores/ordenes" },
    { label: RUTAS_TITULOS["/compras/lista"], to: "/compras/lista" },
    { label: RUTAS_TITULOS["/proveedores"], to: "/proveedores" },
  ];

  const handleCambiarEstado = (
    id: number,
    nuevoEstado: EstadoOrdenCompra,
    mensaje: string,
  ) => {
// ... resto de la lógica ...
    cambiarEstado.mutate(
      { id, idEstado: nuevoEstado },
      {
        onSuccess: () => {
          toast.success(mensaje);
          if (ordenSeleccionada?.id === id) {
            setDialogoOpen(false);
          }
        },
        onError: () => {
          toast.error("Error al cambiar el estado de la orden");
        },
      },
    );
  };


// ... columnas ...
  const columnas = [
    {
      header: "Código",
      accessorKey: "codigoOrden" as keyof OrdenCompra,
      cell: (row: OrdenCompra) => (
        <span className="font-mono font-bold">{row.codigoOrden}</span>
      ),
    },
    {
      header: "Fecha Emisión",
      accessorKey: "fechaEmision" as keyof OrdenCompra,
      cell: (row: OrdenCompra) =>
        formatFecha(new Date(row.fechaEmision), "dd/MM/yyyy"),
    },
    {
      header: "Proveedor",
      accessorKey: "razonSocialProveedor" as keyof OrdenCompra,
      cell: (row: OrdenCompra) =>
        row.razonSocialProveedor || `Prov. #${row.idProveedor}`,
    },
    {
      header: "Total",
      className: "text-right font-semibold",
      cell: (row: OrdenCompra) => row.totalImporte.toFixed(2),
    },
    {
      header: "Estado",
      accessorKey: "idEstado" as keyof OrdenCompra,
      cell: (row: OrdenCompra) => {
        const estado = row.idEstado as EstadoOrdenCompra;
        const etiqueta = EstadoOrdenCompraEtiquetas[estado] || "Otro";

        let variant: "outline" | "default" | "secondary" | "destructive" =
          "outline";
        if (estado === EstadoOrdenCompra.Aprobada) variant = "default";
        if (estado === EstadoOrdenCompra.Rechazada) variant = "destructive";
        if (estado === EstadoOrdenCompra.Pendiente) variant = "secondary";

        return <Badge variant={variant}>{etiqueta}</Badge>;
      },
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: OrdenCompra) => {
        return (
          <div className="flex justify-end gap-1">
            <Button
              variant="ghost"
              size="icon"
              title="Ver Detalle"
              onClick={() => {
                setOrdenSeleccionada(row);
                setModoCreacion(false);
                setDialogoOpen(true);
              }}
              className="h-8 w-8"
            >
              <Eye className="h-4 w-4" />
            </Button>

            {row.idEstado === EstadoOrdenCompra.Pendiente && (
              <>
                <Button
                  variant="ghost"
                  size="icon"
                  className="text-green-600 h-8 w-8"
                  title="Aprobar"
                  onClick={() =>
                    handleCambiarEstado(
                      row.id,
                      EstadoOrdenCompra.Aprobada,
                      "Orden aprobada",
                    )
                  }
                >
                  <CheckCircle className="h-4 w-4" />
                </Button>
                <Button
                  variant="ghost"
                  size="icon"
                  className="text-orange-600 h-8 w-8"
                  title="Rechazar"
                  onClick={() =>
                    handleCambiarEstado(
                      row.id,
                      EstadoOrdenCompra.Rechazada,
                      "Orden rechazada",
                    )
                  }
                >
                  <XCircle className="h-4 w-4" />
                </Button>
              </>
            )}

            {row.idEstado === EstadoOrdenCompra.Aprobada && (
              <Button
                variant="outline"
                size="sm"
                className="text-blue-600 border-blue-200 hover:bg-blue-50 h-8 px-2"
                title="Generar Compra"
                onClick={() =>
                  navigate("/compras/lista", { state: { orden: row } })
                }
              >
                <ShoppingBag className="h-3 w-3 mr-1" />
                Comprar
              </Button>
            )}
          </div>
        );
      },
    },
  ];

  if (isLoading) return <Loading mensaje="Cargando órdenes de compra..." />;
  if (error) return <MensajeError mensaje="Error al cargar órdenes" />;

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsCompras} />

      <div className="flex justify-end gap-2 mb-2">
        <Button
          onClick={() => {
            setOrdenSeleccionada(null);
            setModoCreacion(true);
            setDialogoOpen(true);
          }}
          size="sm"
        >
          <Plus className="mr-2 h-4 w-4" /> Nueva Orden
        </Button>
      </div>

      <Card className="shadow-none border-muted/20">
        <CardContent className="pt-6">
          <DataTable
            data={ordenes}
            columns={columnas}
            pagination={data}
            onPageChange={cambiarPagina}
            onPageSizeChange={cambiarPageSize}
            onSearchChange={cambiarBusqueda}
            onActiveFilterChange={cambiarFiltroActivo}
            searchPlaceholder="Buscar por código o proveedor..."
            isLoading={isLoading}
          />
        </CardContent>
      </Card>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>
              {modoCreacion ? "Nueva Orden de Compra" : "Detalle de Orden de Compra"}
            </DialogTitle>
          </DialogHeader>

        {modoCreacion ? (
          <OrdenCompraForm
            onSuccess={() => {
              setDialogoOpen(false);
            }}
            onCancel={() => setDialogoOpen(false)}
          />
        ) : (
          <div className="space-y-6">
            {isLoadingDetalle ? (
              <div className="py-20">
                <Loading mensaje="Cargando detalles de la orden..." />
              </div>
            ) : (
              <>
                <OrdenCompraForm
                  data={ordenCompleta!}
                  readOnly
                  onSuccess={() => {}}
                  onCancel={() => setDialogoOpen(false)}
                />

                {ordenCompleta?.idEstado === EstadoOrdenCompra.Pendiente && (
                  <div className="flex justify-end gap-3 pt-4 border-t">
                    <Button
                      variant="outline"
                      className="text-orange-600 border-orange-200 hover:bg-orange-50"
                      onClick={() =>
                        handleCambiarEstado(
                          ordenCompleta.id,
                          EstadoOrdenCompra.Rechazada,
                          "Orden rechazada",
                        )
                      }
                    >
                      <XCircle className="mr-2 h-4 w-4" /> Rechazar Orden
                    </Button>
                    <Button
                      className="bg-green-600 hover:bg-green-700"
                      onClick={() =>
                        handleCambiarEstado(
                          ordenCompleta.id,
                          EstadoOrdenCompra.Aprobada,
                          "Orden aprobada exitosamente",
                        )
                      }
                    >
                      <CheckCircle className="mr-2 h-4 w-4" /> Aprobar Orden
                    </Button>
                  </div>
                )}

                {ordenCompleta?.idEstado === EstadoOrdenCompra.Aprobada && (
                  <div className="flex justify-end pt-4 border-t">
                    <Button
                      className="bg-blue-600 hover:bg-blue-700"
                      onClick={() =>
                        navigate("/compras/lista", {
                          state: { orden: ordenCompleta },
                        })
                      }
                    >
                      <ShoppingBag className="mr-2 h-4 w-4" /> Comprar
                    </Button>
                  </div>
                )}
              </>
            )}
          </div>
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
              Esta acción no se puede deshacer. La orden será marcada como
              rechazada.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                if (eliminarId) {
                  handleCambiarEstado(
                    eliminarId,
                    EstadoOrdenCompra.Rechazada,
                    "Orden eliminada (rechazada)",
                  );
                }
                setEliminarId(null);
              }}
            >
              Sí, rechazar
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
