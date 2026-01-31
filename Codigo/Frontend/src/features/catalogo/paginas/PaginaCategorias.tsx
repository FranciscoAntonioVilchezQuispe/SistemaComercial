import { useState } from "react";
import { Plus, Edit2, Power } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { CategoriaForm } from "../componentes/categorias/CategoriaForm";
import {
  useCategorias,
  useCrearCategoria,
  useActualizarCategoria,
  useEliminarCategoria,
} from "../hooks/useCategorias";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import { Categoria, CategoriaFormData } from "../tipos/catalogo.types";
import { DataTable } from "@/components/ui/DataTable";
import { usePagination } from "@/hooks/usePagination";
import { CatalogoHeader } from "../componentes/comunes/CatalogoHeader";

export function PaginaCategorias() {
  const [dialogoAbierto, setDialogoAbierto] = useState(false);
  const [categoriaAModificar, setCategoriaAModificar] = useState<
    Categoria | undefined
  >();

  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
    cambiarFiltroActivo,
  } = usePagination();

  const { data, isLoading, error } = useCategorias(paginacion);
  const crearCategoria = useCrearCategoria();
  const actualizarCategoria = useActualizarCategoria();
  const eliminarCategoria = useEliminarCategoria();

  const categorias = data?.datos || [];

  const manejarAbrirCrear = () => {
    setCategoriaAModificar(undefined);
    setDialogoAbierto(true);
  };

  const manejarAbrirEditar = (categoria: Categoria) => {
    setCategoriaAModificar(categoria);
    setDialogoAbierto(true);
  };

  const manejarCerrar = () => {
    setDialogoAbierto(false);
    setCategoriaAModificar(undefined);
  };

  const manejarEnviar = (datos: CategoriaFormData) => {
    if (categoriaAModificar) {
      actualizarCategoria.mutate(
        { id: categoriaAModificar.id, datos },
        { onSuccess: manejarCerrar },
      );
    } else {
      crearCategoria.mutate(datos, { onSuccess: manejarCerrar });
    }
  };

  const manejarCambiarEstado = (id: number, activo: boolean) => {
    const accion = activo ? "desactivar" : "activar";
    if (window.confirm(`¿Está seguro de ${accion} esta categoría?`)) {
      eliminarCategoria.mutate(id);
    }
  };

  if (isLoading) return <Loading mensaje="Cargando categorías..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const columns = [
    {
      header: "Nombre",
      accessorKey: "nombre" as keyof Categoria,
      className: "font-medium",
    },
    {
      header: "Descripción",
      accessorKey: "descripcion" as keyof Categoria,
      cell: (cat: Categoria) => cat.descripcion || "-",
    },
    {
      header: "Estado",
      accessorKey: "activo" as keyof Categoria,
      cell: (cat: Categoria) => (
        <span
          className={`px-2 py-1 rounded text-xs font-medium ${
            cat.activo
              ? "bg-green-100 text-green-800"
              : "bg-red-100 text-red-800"
          }`}
        >
          {cat.activo ? "Activo" : "Inactivo"}
        </span>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (cat: Categoria) => (
        <div className="flex justify-end space-x-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => manejarAbrirEditar(cat)}
            title="Editar"
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className={cat.activo ? "text-destructive" : "text-green-600"}
            onClick={() => manejarCambiarEstado(cat.id, cat.activo)}
            title={cat.activo ? "Desactivar" : "Activar"}
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
        <h1 className="text-3xl font-bold">Categorías</h1>
        <p className="text-muted-foreground">
          Gestión de categorías de productos.
        </p>
      </div>

      <CatalogoHeader />

      <DataTable
        data={categorias}
        columns={columns}
        pagination={data}
        onPageChange={cambiarPagina}
        onPageSizeChange={cambiarPageSize}
        onSearchChange={cambiarBusqueda}
        onActiveFilterChange={cambiarFiltroActivo}
        searchPlaceholder="Buscar por nombre o descripción..."
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
              {categoriaAModificar ? "Editar Categoría" : "Nueva Categoría"}
            </DialogTitle>
          </DialogHeader>
          <CategoriaForm
            datosIniciales={categoriaAModificar}
            alEnviar={manejarEnviar}
            alCancelar={manejarCerrar}
            cargando={crearCategoria.isPending || actualizarCategoria.isPending}
          />
        </DialogContent>
      </Dialog>
    </div>
  );
}
