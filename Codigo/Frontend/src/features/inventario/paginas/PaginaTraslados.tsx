import { useState } from "react";
import { Plus, Package, Truck, CheckCircle, Clock } from "lucide-react";
import { useTraslados } from "../hooks/useTraslados";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { DataTable } from "@/components/ui/DataTable";
import { Badge } from "@/components/ui/badge";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import { format } from "date-fns";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { FormularioTraslado } from "../componentes/traslados/FormularioTraslado";
import { ModalRecepcionTraslado } from "../componentes/traslados/ModalRecepcionTraslado";

export function PaginaTraslados() {
  const { data: traslados, isLoading, error, refetch } = useTraslados();

  const [modalNuevoOpen, setModalNuevoOpen] = useState(false);
  const [modalRecibirOpen, setModalRecibirOpen] = useState(false);
  const [trasladoSeleccionado, setTrasladoSeleccionado] = useState<any>(null);

  const columnas: any[] = [
    {
      header: "Número",
      accessorKey: "numeroTraslado",
      className: "font-mono font-bold text-blue-600",
    },
    {
      header: "Origen",
      accessorKey: "almacenOrigenNombre",
    },
    {
      header: "Destino",
      accessorKey: "almacenDestinoNombre",
    },
    {
      header: "Fecha Despacho",
      accessorKey: "fechaDespacho",
      cell: (row: any) =>
        row.fechaDespacho
          ? format(new Date(row.fechaDespacho), "dd/MM/yyyy HH:mm")
          : "-",
    },
    {
      header: "Estado",
      accessorKey: "estado",
      cell: (row: any) => {
        const estado = row.estado || "PENDIENTE";
        const color =
          estado === "RECIBIDO"
            ? "bg-green-100 text-green-800"
            : estado === "EN_TRANSITO"
              ? "bg-blue-100 text-blue-800"
              : "bg-yellow-100 text-yellow-800";
        const Icono =
          estado === "RECIBIDO"
            ? CheckCircle
            : estado === "EN_TRANSITO"
              ? Truck
              : Clock;
        return (
          <Badge className={`${color} border-none flex items-center gap-1`}>
            <Icono className="h-3 w-3" />
            {estado}
          </Badge>
        );
      },
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: any) => (
        <div className="flex justify-end gap-2">
          {row.estado === "EN_TRANSITO" && (
            <Button
              size="sm"
              onClick={() => {
                setTrasladoSeleccionado(row);
                setModalRecibirOpen(true);
              }}
            >
              Recibir
            </Button>
          )}
          <Button variant="ghost" size="sm">
            Detalle
          </Button>
        </div>
      ),
    },
  ];

  if (isLoading) return <Loading mensaje="Cargando traslados..." />;
  if (error)
    return <MensajeError mensaje="Error al cargar la lista de traslados" />;

  return (
    <div className="p-6 space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">
            Traslados entre Almacenes
          </h1>
          <p className="text-muted-foreground">
            Gestión y seguimiento de movimientos de mercadería entre sucursales.
          </p>
        </div>
        <Button onClick={() => setModalNuevoOpen(true)}>
          <Plus className="mr-2 h-4 w-4" /> Nuevo Traslado
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="border-l-4 border-l-blue-500">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-blue-600">
              En Tránsito
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {
                (traslados || [])?.filter(
                  (t: any) => t.estado === "EN_TRANSITO",
                ).length
              }
            </div>
            <p className="text-xs text-muted-foreground">Vehículos en ruta</p>
          </CardContent>
        </Card>
        <Card className="border-l-4 border-l-green-500">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-green-600">
              Recibidos
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {
                (traslados || [])?.filter((t: any) => t.estado === "RECIBIDO")
                  .length
              }
            </div>
            <p className="text-xs text-muted-foreground">
              Operaciones cerradas
            </p>
          </CardContent>
        </Card>
        <Card className="border-l-4 border-l-yellow-500">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-yellow-600">
              En Preparación
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {
                (traslados || [])?.filter(
                  (t: any) => (t.estado || "PENDIENTE") === "PENDIENTE",
                ).length
              }
            </div>
            <p className="text-xs text-muted-foreground">Por despachar</p>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardContent className="pt-6">
          <DataTable data={traslados || []} columns={columnas} />
        </CardContent>
      </Card>

      {/* Diálogo Nuevo Traslado */}
      <Dialog open={modalNuevoOpen} onOpenChange={setModalNuevoOpen}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>Registrar Nuevo Traslado (Despacho)</DialogTitle>
          </DialogHeader>
          <FormularioTraslado
            onSuccess={() => {
              setModalNuevoOpen(false);
              refetch();
            }}
            onCancel={() => setModalNuevoOpen(false)}
          />
        </DialogContent>
      </Dialog>

      {/* Diálogo Recibir Traslado */}
      <Dialog open={modalRecibirOpen} onOpenChange={setModalRecibirOpen}>
        <DialogContent className="max-w-xl">
          <DialogHeader>
            <DialogTitle>Confirmar Recepción de Traslado</DialogTitle>
          </DialogHeader>
          {trasladoSeleccionado && (
            <ModalRecepcionTraslado
              traslado={trasladoSeleccionado}
              onSuccess={() => {
                setModalRecibirOpen(false);
                setTrasladoSeleccionado(null);
                refetch();
              }}
              onCancel={() => {
                setModalRecibirOpen(false);
                setTrasladoSeleccionado(null);
              }}
            />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
