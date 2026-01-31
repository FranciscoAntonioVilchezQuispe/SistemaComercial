import { useState } from "react";
import { Plus, Edit2, Power } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { MarcaForm } from "../componentes/marcas/MarcaForm";
import {
  useMarcas,
  useCrearMarca,
  useActualizarMarca,
  useEliminarMarca,
} from "../hooks/useMarcas";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import { Marca, MarcaFormData } from "../tipos/catalogo.types";
import { DataTable } from "@/components/ui/DataTable";
import { usePagination } from "@/hooks/usePagination";
import { CatalogoHeader } from "../componentes/comunes/CatalogoHeader";

export function PaginaMarcas() {
  const [dialogoAbierto, setDialogoAbierto] = useState(false);
  const [marcaAModificar, setMarcaAModificar] = useState<Marca | undefined>();

  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
    cambiarFiltroActivo,
  } = usePagination();

  const { data, isLoading, error } = useMarcas(paginacion);
  const crearMarca = useCrearMarca();
  const actualizarMarca = useActualizarMarca();
  const eliminarMarca = useEliminarMarca();

  const marcas = data?.datos || [];

  const manejarAbrirCrear = () => {
    setMarcaAModificar(undefined);
    setDialogoAbierto(true);
  };

  const manejarAbrirEditar = (marca: Marca) => {
    setMarcaAModificar(marca);
    setDialogoAbierto(true);
  };

  const manejarCerrar = () => {
    setDialogoAbierto(false);
    setMarcaAModificar(undefined);
  };

  const manejarEnviar = (datos: MarcaFormData) => {
    if (marcaAModificar) {
      actualizarMarca.mutate(
        { id: marcaAModificar.id, datos },
        { onSuccess: manejarCerrar },
      );
    } else {
      crearMarca.mutate(datos, { onSuccess: manejarCerrar });
    }
  };

  const manejarCambiarEstado = (id: number, activo: boolean) => {
    const accion = activo ? "desactivar" : "activar";
    if (window.confirm(`¿Está seguro de ${accion} esta marca?`)) {
      eliminarMarca.mutate(id);
    }
  };

  if (isLoading) return <Loading mensaje="Cargando marcas..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const columns = [
    {
      header: "Nombre",
      accessorKey: "nombre" as keyof Marca,
      className: "font-medium",
    },
    {
      header: "País de Origen",
      accessorKey: "paisOrigen" as keyof Marca,
      cell: (marca: Marca) => marca.paisOrigen || "-",
    },
    {
      header: "Estado",
      accessorKey: "activo" as keyof Marca,
      cell: (marca: Marca) => (
        <span
          className={`px-2 py-1 rounded text-xs font-medium ${
            marca.activo
              ? "bg-green-100 text-green-800"
              : "bg-red-100 text-red-800"
          }`}
        >
          {marca.activo ? "Activo" : "Inactivo"}
        </span>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (marca: Marca) => (
        <div className="flex justify-end space-x-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => manejarAbrirEditar(marca)}
            title="Editar"
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className={marca.activo ? "text-destructive" : "text-green-600"}
            onClick={() => manejarCambiarEstado(marca.id, marca.activo)}
            title={marca.activo ? "Desactivar" : "Activar"}
          >
            <Power className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Marcas</h1>
        <p className="text-muted-foreground">
          Gestiona las marcas de tus productos para una clasificación precisa.
        </p>
      </div>

      <CatalogoHeader />

      <DataTable
        data={marcas}
        columns={columns}
        pagination={data}
        onPageChange={cambiarPagina}
        onPageSizeChange={cambiarPageSize}
        onSearchChange={cambiarBusqueda}
        onActiveFilterChange={cambiarFiltroActivo}
        searchPlaceholder="Buscar por nombre o país..."
        isLoading={isLoading}
        actionElement={
          <Button
            onClick={manejarAbrirCrear}
            className="bg-blue-600 hover:bg-blue-700 text-white rounded-full px-6"
          >
            <Plus className="mr-2 h-4 w-4" />
            Nuevo
          </Button>
        }
      />

      <Dialog open={dialogoAbierto} onOpenChange={setDialogoAbierto}>
        <DialogContent className="sm:max-w-[425px]">
          <DialogHeader>
            <DialogTitle>
              {marcaAModificar ? "Editar Marca" : "Nueva Marca"}
            </DialogTitle>
          </DialogHeader>
          <MarcaForm
            datosIniciales={marcaAModificar}
            alEnviar={manejarEnviar}
            alCancelar={manejarCerrar}
            cargando={crearMarca.isPending || actualizarMarca.isPending}
          />
        </DialogContent>
      </Dialog>
    </div>
  );
}
