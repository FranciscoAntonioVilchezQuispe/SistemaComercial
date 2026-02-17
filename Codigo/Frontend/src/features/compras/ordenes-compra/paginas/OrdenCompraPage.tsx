import { useState } from "react";
import {
  Plus,
  Eye,
  Trash2,
  XCircle,
  ShoppingBag,
  CheckCircle,
} from "lucide-react";
import { formatFecha } from "@/lib/i18n";
import { useNavigate } from "react-router-dom";

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

import {
  useOrdenesCompra,
  useCambiarEstadoOrdenCompra,
} from "../hooks/useOrdenesCompra";
import { OrdenCompra } from "../types/ordenCompra.types";
import { OrdenCompraForm } from "../componentes/OrdenCompraForm";
import {
  EstadoOrdenCompra,
  EstadoOrdenCompraEtiquetas,
} from "../../constantes";

export default function OrdenCompraPage() {
  const navigate = useNavigate();
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [ordenSeleccionada, setOrdenSeleccionada] =
    useState<OrdenCompra | null>(null);
  const [modoCreacion, setModoCreacion] = useState(false);
  const [filtro, setFiltro] = useState("");

  const { data: ordenes, isLoading, error } = useOrdenesCompra();
  const cambiarEstado = useCambiarEstadoOrdenCompra();

  const handleCambiarEstado = (
    id: number,
    nuevoEstado: EstadoOrdenCompra,
    mensaje: string,
  ) => {
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

  const ordenesFiltradas =
    ordenes?.filter(
      (o) =>
        o.codigoOrden.toLowerCase().includes(filtro.toLowerCase()) ||
        o.razonSocialProveedor?.toLowerCase().includes(filtro.toLowerCase()) ||
        o.id.toString().includes(filtro),
    ) || [];

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
      cell: (row: OrdenCompra) => (
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
          >
            <Eye className="h-4 w-4" />
          </Button>

          {row.idEstado === EstadoOrdenCompra.Pendiente && (
            <>
              <Button
                variant="ghost"
                size="icon"
                className="text-green-600"
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
                className="text-orange-600"
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
              className="text-blue-600 border-blue-200 hover:bg-blue-50"
              title="Generar Compra"
              onClick={() =>
                navigate("/compras/lista", { state: { orden: row } })
              }
            >
              <ShoppingBag className="h-3 w-3 mr-1" />
            </Button>
          )}

          <Button
            variant="ghost"
            size="icon"
            className="text-destructive"
            title="Eliminar (Rechazar)"
            onClick={() =>
              handleCambiarEstado(
                row.id,
                EstadoOrdenCompra.Rechazada,
                "Orden eliminada (rechazada)",
              )
            }
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  if (isLoading) return <Loading mensaje="Cargando órdenes de compra..." />;
  if (error) return <MensajeError mensaje="Error al cargar órdenes" />;

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-4">
          <div>
            <CardTitle className="text-2xl font-bold">
              Órdenes de Compra
            </CardTitle>
            <CardDescription>
              Gestión de pedidos a proveedores y registro histórico.
            </CardDescription>
          </div>
          <Button
            onClick={() => {
              setOrdenSeleccionada(null);
              setModoCreacion(true);
              setDialogoOpen(true);
            }}
            className="shadow-sm"
          >
            <Plus className="mr-2 h-4 w-4" /> Nueva Orden
          </Button>
        </CardHeader>
        <CardContent>
          <DataTable
            data={ordenesFiltradas}
            columns={columnas}
            onSearchChange={setFiltro}
            searchPlaceholder="Buscar por código o proveedor..."
          />
        </CardContent>
      </Card>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex justify-between items-center pr-8">
              <span>
                {modoCreacion
                  ? "Nueva Orden de Compra"
                  : `Orden ${ordenSeleccionada?.codigoOrden}`}
              </span>
              {!modoCreacion && ordenSeleccionada && (
                <Badge
                  variant={
                    ordenSeleccionada.idEstado === EstadoOrdenCompra.Aprobada
                      ? "default"
                      : "secondary"
                  }
                >
                  {
                    EstadoOrdenCompraEtiquetas[
                      ordenSeleccionada.idEstado as EstadoOrdenCompra
                    ]
                  }
                </Badge>
              )}
            </DialogTitle>
          </DialogHeader>

          {modoCreacion ? (
            <OrdenCompraForm
              onSuccess={() => {
                toast.success("Orden de compra registrada exitosamente");
                setDialogoOpen(false);
              }}
              onCancel={() => setDialogoOpen(false)}
            />
          ) : (
            <div className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6 p-4 bg-muted/20 rounded-lg">
                <div className="space-y-1">
                  <span className="text-xs text-muted-foreground uppercase font-bold tracking-wider">
                    Proveedor
                  </span>
                  <p className="font-medium text-sm">
                    {ordenSeleccionada?.razonSocialProveedor ||
                      `ID: ${ordenSeleccionada?.idProveedor}`}
                  </p>
                </div>
                <div className="space-y-1">
                  <span className="text-xs text-muted-foreground uppercase font-bold tracking-wider">
                    Almacén Destino
                  </span>
                  <p className="font-medium text-sm">
                    {ordenSeleccionada?.nombreAlmacen ||
                      `ID: ${ordenSeleccionada?.idAlmacenDestino}`}
                  </p>
                </div>
                <div className="space-y-1">
                  <span className="text-xs text-muted-foreground uppercase font-bold tracking-wider">
                    Fecha Emisión
                  </span>
                  <p className="font-medium text-sm">
                    {ordenSeleccionada?.fechaEmision &&
                      formatFecha(
                        new Date(ordenSeleccionada.fechaEmision),
                        "PPPP",
                      )}
                  </p>
                </div>
                <div className="space-y-1">
                  <span className="text-xs text-muted-foreground uppercase font-bold tracking-wider">
                    Entrega Estimada
                  </span>
                  <p className="font-medium text-sm">
                    {ordenSeleccionada?.fechaEntregaEstimada
                      ? formatFecha(
                          new Date(ordenSeleccionada.fechaEntregaEstimada),
                          "PPPP",
                        )
                      : "No especificada"}
                  </p>
                </div>
                <div className="space-y-1">
                  <span className="text-xs text-muted-foreground uppercase font-bold tracking-wider">
                    Total Importe
                  </span>
                  <p className="font-bold text-lg text-primary">
                    S/ {ordenSeleccionada?.totalImporte.toFixed(2)}
                  </p>
                </div>
              </div>

              {ordenSeleccionada?.observaciones && (
                <div className="p-3 bg-blue-50 border border-blue-100 rounded text-sm text-blue-800">
                  <strong className="block mb-1">Observaciones:</strong>
                  {ordenSeleccionada.observaciones}
                </div>
              )}

              <div className="space-y-3">
                <h4 className="font-bold text-lg border-b pb-2 flex items-center gap-2">
                  <Plus className="h-4 w-4" /> Detalles de la Orden
                </h4>
                <div className="border rounded-lg overflow-hidden">
                  <table className="w-full text-sm">
                    <thead className="bg-muted/50 text-muted-foreground">
                      <tr className="text-left">
                        <th className="p-3 font-semibold">Producto</th>
                        <th className="p-3 font-semibold text-right">
                          Cantidad
                        </th>
                        <th className="p-3 font-semibold text-right">
                          Precio Unit.
                        </th>
                        <th className="p-3 font-semibold text-right text-primary">
                          Subtotal
                        </th>
                      </tr>
                    </thead>
                    <tbody className="divide-y">
                      {ordenSeleccionada?.detalles.map((d, i) => (
                        <tr
                          key={i}
                          className="hover:bg-muted/30 transition-colors"
                        >
                          <td className="p-3">
                            <div className="font-medium">
                              {d.nombreProducto || `Prod. #${d.idProducto}`}
                            </div>
                          </td>
                          <td className="p-3 text-right tabular-nums">
                            {d.cantidadSolicitada.toFixed(3)}
                          </td>
                          <td className="p-3 text-right tabular-nums">
                            {d.precioUnitarioPactado.toFixed(2)}
                          </td>
                          <td className="p-3 text-right font-bold tabular-nums">
                            {(
                              d.cantidadSolicitada * d.precioUnitarioPactado
                            ).toFixed(2)}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                    <tfoot className="bg-muted/20 font-bold">
                      <tr>
                        <td
                          colSpan={3}
                          className="p-3 text-right uppercase tracking-wider text-xs text-muted-foreground"
                        >
                          Total Final
                        </td>
                        <td className="p-3 text-right text-base text-primary">
                          S/ {ordenSeleccionada?.totalImporte.toFixed(2)}
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>

              {!modoCreacion &&
                ordenSeleccionada?.idEstado === EstadoOrdenCompra.Pendiente && (
                  <div className="flex justify-end gap-3 pt-4">
                    <Button
                      variant="outline"
                      className="text-orange-600 border-orange-200 hover:bg-orange-50"
                      onClick={() =>
                        handleCambiarEstado(
                          ordenSeleccionada.id,
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
                          ordenSeleccionada.id,
                          EstadoOrdenCompra.Aprobada,
                          "Orden aprobada exitosamente",
                        )
                      }
                    >
                      <CheckCircle className="mr-2 h-4 w-4" /> Aprobar Orden
                    </Button>
                  </div>
                )}

              {ordenSeleccionada?.idEstado === EstadoOrdenCompra.Aprobada && (
                <div className="flex justify-end pt-4">
                  <Button
                    className="bg-blue-600 hover:bg-blue-700"
                    onClick={() =>
                      navigate("/compras/lista", {
                        state: { orden: ordenSeleccionada },
                      })
                    }
                  >
                    <ShoppingBag className="mr-2 h-4 w-4" /> Generar Registro de
                    Compra
                  </Button>
                </div>
              )}
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
