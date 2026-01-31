import { useState } from "react";
import { Plus, Eye, ShoppingBag } from "lucide-react";
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

// Correction: imports for specific hooks
import { useCompras } from "../hooks/useCompras";
import { Compra } from "../types/compra.types";
import { CompraForm } from "../componentes/CompraForm"; // Form component for creating

export default function PaginaCompras() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [compraSeleccionada, setCompraSeleccionada] = useState<Compra | null>(
    null,
  ); // For viewing details
  const [modoCreacion, setModoCreacion] = useState(false);
  const [filtro, setFiltro] = useState("");

  const { data: compras, isLoading, error } = useCompras();

  const comprasFiltradas =
    compras?.filter(
      (c) =>
        c.serieComprobante.includes(filtro) ||
        c.numeroComprobante.includes(filtro) ||
        // Assuming we might have expanded data or filtering by ID
        c.id.toString().includes(filtro),
    ) || [];

  const columnas = [
    {
      header: "Fecha",
      accessorKey: "fechaEmision" as keyof Compra,
      cell: (row: Compra) => format(new Date(row.fechaEmision), "dd/MM/yyyy"),
    },
    {
      header: "Proveedor",
      // accessorKey: "idProveedor", // We ideally want the name.
      // If the backend returns expanded DTOs (razonSocialProveedor), use that.
      // If not, we need to fetch providers or just show ID for now.
      // The type definition had `razonSocialProveedor?: string`. Let's assume it's populated for the list.
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
              // TODO: Implement View Detail Mode
              // For now, maybe just show JSON or a readonly form
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
          <div className="flex justify-between items-center mb-4 gap-4">
            <div className="relative flex-1 max-w-sm">
              <ShoppingBag className="absolute left-2 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Buscar por número..."
                className="pl-8"
                value={filtro}
                onChange={(e) => setFiltro(e.target.value)}
              />
            </div>
            <Button
              onClick={() => {
                setCompraSeleccionada(null);
                setModoCreacion(true);
                setDialogoOpen(true);
              }}
            >
              <Plus className="mr-2 h-4 w-4" /> Registrar Compra
            </Button>
          </div>

          <DataTable data={comprasFiltradas} columns={columnas} />
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
              onSuccess={() => {
                toast.success("Compra registrada exitosamente");
                setDialogoOpen(false);
              }}
              onCancel={() => setDialogoOpen(false)}
            />
          ) : (
            <div className="p-4 bg-muted/20 rounded text-sm">
              <h4 className="font-bold">Resumen Documento</h4>
              <pre>{JSON.stringify(compraSeleccionada, null, 2)}</pre>
              {/* TODO: Create CompraDetail component */}
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
