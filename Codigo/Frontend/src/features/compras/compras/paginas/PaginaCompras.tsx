import { useState, useEffect } from "react";
import { Plus, Eye, ShoppingCart } from "lucide-react";
import { useLocation } from "react-router-dom";
import { formatFecha } from "@/lib/i18n";

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
import { useCompras } from "../hooks/useCompras";
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

  const { data: compras, isLoading, error } = useCompras();

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
              setCompraSeleccionada(row);
              setModoCreacion(false);
              setDialogoOpen(true);
            }}
          >
            <Eye className="h-4 w-4" />
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

          {modoCreacion ? (
            <CompraForm
              datosIniciales={datosIniciales}
              onSuccess={() => {
                toast.success("Compra registrada exitosamente");
                setDialogoOpen(false);
              }}
              onCancel={() => setDialogoOpen(false)}
            />
          ) : (
            <div className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 p-4 bg-muted/20 rounded-lg">
                <div className="space-y-1">
                  <span className="text-xs text-muted-foreground uppercase font-bold tracking-wider">
                    Proveedor
                  </span>
                  <p className="font-medium text-sm">
                    {compraSeleccionada?.razonSocialProveedor ||
                      `ID: ${compraSeleccionada?.idProveedor}`}
                  </p>
                </div>
                <div className="space-y-1">
                  <span className="text-xs text-muted-foreground uppercase font-bold tracking-wider">
                    Almacén
                  </span>
                  <p className="font-medium text-sm">
                    {compraSeleccionada?.nombreAlmacen ||
                      `ID: ${compraSeleccionada?.idAlmacen}`}
                  </p>
                </div>
                <div className="space-y-1">
                  <span className="text-xs text-muted-foreground uppercase font-bold tracking-wider">
                    Fecha Emisión
                  </span>
                  <p className="font-medium text-sm">
                    {compraSeleccionada?.fechaEmision &&
                      formatFecha(
                        new Date(compraSeleccionada.fechaEmision),
                        "PPPP",
                      )}
                  </p>
                </div>
                <div className="space-y-1">
                  <span className="text-xs text-muted-foreground uppercase font-bold tracking-wider">
                    Total
                  </span>
                  <p className="font-bold text-lg text-primary">
                    S/ {compraSeleccionada?.total.toFixed(2)}
                  </p>
                </div>
              </div>

              {compraSeleccionada?.observaciones && (
                <div className="p-3 bg-blue-50 border border-blue-100 rounded text-sm text-blue-800">
                  <strong className="block mb-1">Observaciones:</strong>
                  {compraSeleccionada.observaciones}
                </div>
              )}

              <div className="space-y-3">
                <h4 className="font-bold text-lg border-b pb-2 flex items-center gap-2">
                  <ShoppingCart className="h-4 w-4" /> Detalles de la Compra
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
                      {compraSeleccionada?.detalles?.map((d, i) => (
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
                            {d.cantidad.toFixed(3)}
                          </td>
                          <td className="p-3 text-right tabular-nums">
                            {d.precioUnitario.toFixed(2)}
                          </td>
                          <td className="p-3 text-right font-bold tabular-nums">
                            {d.subtotal.toFixed(2)}
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
                          S/ {compraSeleccionada?.total.toFixed(2)}
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
