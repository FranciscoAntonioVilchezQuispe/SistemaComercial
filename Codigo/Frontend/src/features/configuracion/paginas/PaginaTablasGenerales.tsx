import { useState } from "react";
import { Plus, Edit2, Trash2, List } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { DataTable } from "@/components/ui/DataTable";
import { usePagination } from "@/hooks/usePagination";
import { TablaGeneralForm } from "../componentes/TablaGeneralForm";
import { TablaGeneralDetallesManager } from "../componentes/TablaGeneralDetallesManager";
import {
  useTablasGenerales,
  useCrearTabla,
  useActualizarTabla,
  useEliminarTabla,
} from "../hooks/useTablaGeneral";
import {
  TablaGeneral,
  TablaGeneralFormData,
} from "../tipos/tablaGeneral.types";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";

export function PaginaTablasGenerales() {
  const [tablaDialogoOpen, setTablaDialogoOpen] = useState(false);
  const [detalleDialogoOpen, setDetalleDialogoOpen] = useState(false);

  const [tablaSeleccionada, setTablaSeleccionada] =
    useState<TablaGeneral | null>(null); // For Edit Table or View Details

  const { paginacion, cambiarPagina, cambiarPageSize, cambiarBusqueda } =
    usePagination();
  const { data, isLoading, error } = useTablasGenerales(paginacion);

  const crearTabla = useCrearTabla();
  const actualizarTabla = useActualizarTabla();
  const eliminarTabla = useEliminarTabla();

  const handleCrear = () => {
    setTablaSeleccionada(null);
    setTablaDialogoOpen(true);
  };

  const handleEditar = (tabla: TablaGeneral) => {
    setTablaSeleccionada(tabla);
    setTablaDialogoOpen(true);
  };

  const handleVerDetalles = (tabla: TablaGeneral) => {
    setTablaSeleccionada(tabla);
    setDetalleDialogoOpen(true);
  };

  const handleEliminar = (tabla: TablaGeneral) => {
    if (
      confirm(
        `¿Eliminar tabla ${tabla.nombre}? Se eliminarán también sus detalles.`,
      )
    ) {
      eliminarTabla.mutate(tabla.id);
    }
  };

  const handleGuardarTabla = (datos: TablaGeneralFormData) => {
    if (tablaSeleccionada) {
      actualizarTabla.mutate(
        { id: tablaSeleccionada.id, datos },
        { onSuccess: () => setTablaDialogoOpen(false) },
      );
    } else {
      crearTabla.mutate(datos, { onSuccess: () => setTablaDialogoOpen(false) });
    }
  };

  if (isLoading) return <Loading mensaje="Cargando Tablas Generales..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const tablas = data?.datos || [];

  const columns = [
    {
      header: "Código",
      accessorKey: "codigo" as keyof TablaGeneral,
      className: "font-mono font-medium",
    },
    {
      header: "Nombre",
      accessorKey: "nombre" as keyof TablaGeneral,
      className: "font-bold",
    },
    { header: "Descripción", accessorKey: "descripcion" as keyof TablaGeneral },
    {
      header: "Valores",
      accessorKey: "cantidadValores" as keyof TablaGeneral,
      cell: (row: TablaGeneral) => (
        <span className="badge badge-ghost">{row.cantidadValores}</span>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: TablaGeneral) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => handleVerDetalles(row)}
            title="Gestionar Valores"
          >
            <List className="h-4 w-4 mr-1" /> Valores
          </Button>
          <Button
            variant="ghost"
            size="icon"
            onClick={() => handleEditar(row)}
            title="Editar Tabla"
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          {!row.esSistema && (
            <Button
              variant="ghost"
              size="icon"
              className="text-destructive"
              onClick={() => handleEliminar(row)}
              title="Eliminar Tabla"
            >
              <Trash2 className="h-4 w-4" />
            </Button>
          )}
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Tablas Generales</h1>
        <p className="text-muted-foreground">
          Gestión de catálogos y tablas maestras del sistema.
        </p>
      </div>

      <DataTable
        data={tablas}
        columns={columns}
        pagination={data}
        onPageChange={cambiarPagina}
        onPageSizeChange={cambiarPageSize}
        onSearchChange={cambiarBusqueda}
        searchPlaceholder="Buscar tablas..."
        actionElement={
          <Button onClick={handleCrear}>
            <Plus className="mr-2 h-4 w-4" /> Nueva Tabla
          </Button>
        }
      />

      {/* Dialogo CREAR/EDITAR TABLA */}
      <Dialog open={tablaDialogoOpen} onOpenChange={setTablaDialogoOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {tablaSeleccionada ? "Editar Tabla" : "Nueva Tabla General"}
            </DialogTitle>
          </DialogHeader>
          <TablaGeneralForm
            datosIniciales={tablaSeleccionada || undefined}
            alEnviar={handleGuardarTabla}
            alCancelar={() => setTablaDialogoOpen(false)}
            cargando={crearTabla.isPending || actualizarTabla.isPending}
          />
        </DialogContent>
      </Dialog>

      {/* Dialogo GESTIONAR DETALLES */}
      <Dialog open={detalleDialogoOpen} onOpenChange={setDetalleDialogoOpen}>
        <DialogContent className="max-w-3xl">
          <DialogHeader>
            <DialogTitle>
              Valores: {tablaSeleccionada?.nombre} ({tablaSeleccionada?.codigo})
            </DialogTitle>
          </DialogHeader>
          {tablaSeleccionada && (
            <TablaGeneralDetallesManager tabla={tablaSeleccionada} />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
