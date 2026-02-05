import { useState } from "react";
import { Plus, Eye, Search } from "lucide-react";
import { format } from "date-fns";

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
import { Input } from "@/components/ui/input";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import { Separator } from "@/components/ui/separator";

import { useOrdenesCompra } from "../hooks/useOrdenesCompra";
import { OrdenCompra } from "../types/ordenCompra.types";
import { OrdenCompraForm } from "../componentes/OrdenCompraForm";

export default function OrdenCompraPage() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [ordenSeleccionada, setOrdenSeleccionada] = useState<OrdenCompra | null>(null);
  const [modoCreacion, setModoCreacion] = useState(false);
  const [filtro, setFiltro] = useState("");

  const { data: ordenes, isLoading, error } = useOrdenesCompra();

  const ordenesFiltradas =
    ordenes?.filter(
      (o) =>
        o.codigoOrden.toLowerCase().includes(filtro.toLowerCase()) ||
        // Si el backend popula nombreProveedor en el DTO en el futuro, se puede filtrar por ahí
        o.id.toString().includes(filtro)
    ) || [];

  const columnas = [
    {
      header: "Código",
      accessorKey: "codigoOrden" as keyof OrdenCompra,
      cell: (row: OrdenCompra) => <span className="font-mono font-bold">{row.codigoOrden}</span>,
    },
    {
      header: "Fecha Emisión",
      accessorKey: "fechaEmision" as keyof OrdenCompra,
      cell: (row: OrdenCompra) => format(new Date(row.fechaEmision), "dd/MM/yyyy"),
    },
    {
        header: "Entrega Est.",
        accessorKey: "fechaEntregaEstimada" as keyof OrdenCompra,
        cell: (row: OrdenCompra) => row.fechaEntregaEstimada ? format(new Date(row.fechaEntregaEstimada), "dd/MM/yyyy") : "-",
    },
    {
      header: "Proveedor",
      accessorKey: "idProveedor" as keyof OrdenCompra,
      // Idealmente mostrar nombre si viene en el DTO
      cell: (row: OrdenCompra) => row.razonSocialProveedor || `Prov. #${row.idProveedor}`,
    },
    {
      header: "Almacén",
      accessorKey: "idAlmacenDestino" as keyof OrdenCompra,
      cell: (row: OrdenCompra) => row.nombreAlmacen || `Alm. #${row.idAlmacenDestino}`,
    },
    {
      header: "Total",
      accessorKey: "totalImporte" as keyof OrdenCompra,
      className: "text-right font-semibold",
      cell: (row: OrdenCompra) => row.totalImporte.toFixed(2),
    },
    {
      header: "Estado",
      accessorKey: "idEstado" as keyof OrdenCompra,
      cell: (row: OrdenCompra) => (
        <Badge variant="outline">
          {/* Mapping simple por ahora, ideal traer nombre de catalogo */}
          {row.idEstado === 1 ? "Pendiente" : row.idEstado === 2 ? "Aprobado" : "Otro"}
        </Badge>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: OrdenCompra) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => {
              setOrdenSeleccionada(row);
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

  if (isLoading) return <Loading mensaje="Cargando órdenes de compra..." />;
  if (error) return <MensajeError mensaje="Error al cargar órdenes" />;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Órdenes de Compra</h1>
        <p className="text-muted-foreground">
          Gestión de pedidos a proveedores.
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Listado de Órdenes</CardTitle>
          <CardDescription>
            Registro histórico de órdenes de compra.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex justify-between items-center mb-4 gap-4 flex-wrap">
            <div className="relative flex-1 max-w-sm">
              <Search className="absolute left-2 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Buscar por código..."
                className="pl-8"
                value={filtro}
                onChange={(e) => setFiltro(e.target.value)}
              />
            </div>
            <Button
              onClick={() => {
                setOrdenSeleccionada(null);
                setModoCreacion(true);
                setDialogoOpen(true);
              }}
            >
              <Plus className="mr-2 h-4 w-4" /> Nueva Orden
            </Button>
          </div>

          <DataTable data={ordenesFiltradas} columns={columnas} />
        </CardContent>
      </Card>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>
              {modoCreacion ? "Nueva Orden de Compra" : `Orden ${ordenSeleccionada?.codigoOrden}`}
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
            <div className="p-4 bg-muted/20 rounded text-sm space-y-4">
               {/* Readonly View - Simple JSON dump for now + Details list */}
               <div className="grid grid-cols-2 gap-4">
                  <div>
                      <strong>Proveedor:</strong> {ordenSeleccionada?.razonSocialProveedor || ordenSeleccionada?.idProveedor}
                  </div>
                  <div>
                      <strong>Almacén:</strong> {ordenSeleccionada?.nombreAlmacen || ordenSeleccionada?.idAlmacenDestino}
                  </div>
                  <div>
                      <strong>Fecha:</strong> {ordenSeleccionada?.fechaEmision && format(new Date(ordenSeleccionada.fechaEmision), "PPP")}
                  </div>
                  <div>
                      <strong>Total:</strong> {ordenSeleccionada?.totalImporte.toFixed(2)}
                  </div>
                  <div className="col-span-2">
                       <strong>Observaciones:</strong> {ordenSeleccionada?.observaciones || "-"}
                  </div>
               </div>
               
               <Separator />
               
               <h4 className="font-bold">Detalles</h4>
               <table className="w-full text-sm">
                   <thead>
                       <tr className="border-b text-left">
                           <th className="py-2">Producto</th>
                           <th className="py-2 text-right">Cant.</th>
                           <th className="py-2 text-right">Precio</th>
                           <th className="py-2 text-right">Subtotal</th>
                       </tr>
                   </thead>
                   <tbody>
                       {ordenSeleccionada?.detalles.map((d, i) => (
                           <tr key={i} className="border-b">
                               <td className="py-2">{d.nombreProducto || `ID: ${d.idProducto}`}</td>
                               <td className="py-2 text-right">{d.cantidadSolicitada}</td>
                               <td className="py-2 text-right">{d.precioUnitarioPactado.toFixed(2)}</td>
                               <td className="py-2 text-right">{(d.cantidadSolicitada * d.precioUnitarioPactado).toFixed(2)}</td>
                           </tr>
                       ))}
                   </tbody>
               </table>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
