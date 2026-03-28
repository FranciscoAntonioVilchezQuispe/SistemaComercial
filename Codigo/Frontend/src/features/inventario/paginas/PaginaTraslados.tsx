import { useState } from "react";
import { Plus, Truck, CheckCircle, Clock } from "lucide-react";
import { useTraslados } from "../hooks/useTraslados";
import { usePagination } from "@/hooks/usePagination";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { DataTable } from "@/componentes/ui/DataTable";
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
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export function PaginaTraslados() {
  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
  } = usePagination();

  const { data: traslados, isLoading, error, refetch } = useTraslados(paginacion);

  const [modalNuevoOpen, setModalNuevoOpen] = useState(false);
  const [modalRecibirOpen, setModalRecibirOpen] = useState(false);
  const [trasladoSeleccionado, setTrasladoSeleccionado] = useState<any>(null);

  const tabsInventario = [
    { label: RUTAS_TITULOS["/inventario/stock"], to: "/inventario/stock" },
    { label: RUTAS_TITULOS["/inventario/movimientos"], to: "/inventario/movimientos" },
    { label: RUTAS_TITULOS["/inventario/traslados"], to: "/inventario/traslados" },
    { label: RUTAS_TITULOS["/inventario/kardex/reporte"], to: "/inventario/kardex/reporte" },
    { label: RUTAS_TITULOS["/inventario/kardex/periodos"], to: "/inventario/kardex/periodos" },
    { label: RUTAS_TITULOS["/inventario/almacenes"], to: "/inventario/almacenes" },
  ];

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
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsInventario} />

      <div className="flex justify-end mb-2">
        <Button onClick={() => setModalNuevoOpen(true)} size="sm">
          <Plus className="mr-2 h-4 w-4" /> Nuevo Traslado
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="border-l-4 border-l-blue-500 shadow-none">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-blue-600">
              En Tránsito
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {
                (traslados?.datos || [])?.filter(
                  (t: any) => t.estado === "EN_TRANSITO",
                ).length
              }
            </div>
            <p className="text-xs text-muted-foreground">Vehículos en ruta</p>
          </CardContent>
        </Card>
        <Card className="border-l-4 border-l-green-500 shadow-none">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-green-600">
              Recibidos
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {
                (traslados?.datos || [])?.filter((t: any) => t.estado === "RECIBIDO")
                  .length
              }
            </div>
            <p className="text-xs text-muted-foreground">
              Operaciones cerradas
            </p>
          </CardContent>
        </Card>
        <Card className="border-l-4 border-l-yellow-500 shadow-none">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-yellow-600">
              En Preparación
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {
                (traslados?.datos || [])?.filter(
                  (t: any) => (t.estado || "PENDIENTE") === "PENDIENTE",
                ).length
              }
            </div>
            <p className="text-xs text-muted-foreground">Por despachar</p>
          </CardContent>
        </Card>
      </div>

      <Card className="shadow-none border-muted/20">
        <CardContent className="pt-6">
          <DataTable
            data={traslados?.datos || []}
            columns={columnas}
            pagination={traslados}
            onPageChange={cambiarPagina}
            onPageSizeChange={cambiarPageSize}
            onSearchChange={cambiarBusqueda}
          />
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
