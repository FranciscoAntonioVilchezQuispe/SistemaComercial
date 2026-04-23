import { useState } from "react";
import { Plus, Edit2, Power } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "@/components/ui/dialog";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import { CategoriaForm } from "../componentes/categorias/CategoriaForm";
import {
  useCategorias,
  useCategoria,
  useCrearCategoria,
  useActualizarCategoria,
  useEliminarCategoria,
} from "../hooks/useCategorias";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import { Categoria, CategoriaFormData } from "../tipos/catalogo.types";
import { DataTable } from "@/components/ui/DataTable";
import { usePagination } from "@/hooks/usePagination";

export function PaginaCategorias() {
  const [dialogoAbierto, setDialogoAbierto] = useState(false);
  const [idCategoriaAModificar, setIdCategoriaAModificar] = useState<number | null>(null);

  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
    cambiarFiltroActivo,
  } = usePagination();

  const { data, isLoading, error } = useCategorias(paginacion);
  const { data: categoriaDetalle, isLoading: cargandoDetalle } = useCategoria(idCategoriaAModificar || 0);
  const crearCategoria = useCrearCategoria();
  const actualizarCategoria = useActualizarCategoria();
  const eliminarCategoria = useEliminarCategoria();

  const categorias = data?.datos || [];

  const manejarAbrirCrear = () => {
    setIdCategoriaAModificar(null);
    setDialogoAbierto(true);
  };

  const manejarAbrirEditar = (id: number) => {
    setIdCategoriaAModificar(id);
    setDialogoAbierto(true);
  };

  const manejarCerrar = () => {
    setDialogoAbierto(false);
    setIdCategoriaAModificar(null);
  };

  const manejarEnviar = (datos: CategoriaFormData) => {
    if (idCategoriaAModificar) {
      actualizarCategoria.mutate(
        { id: idCategoriaAModificar, datos },
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
            onClick={() => manejarAbrirEditar(cat.id)}
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

  const tabsCatalogo = [
    { label: RUTAS_TITULOS["/catalogo/productos"], to: "/catalogo/productos" },
    { label: RUTAS_TITULOS["/catalogo/categorias"], to: "/catalogo/categorias" },
    { label: RUTAS_TITULOS["/catalogo/marcas"], to: "/catalogo/marcas" },
    { label: RUTAS_TITULOS["/catalogo/unidades-medida"], to: "/catalogo/unidades-medida" },
    { label: RUTAS_TITULOS["/catalogo/listas-precios"], to: "/catalogo/listas-precios" },
  ];

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsCatalogo} />

      <div className="flex justify-end mb-2">
        <Button onClick={manejarAbrirCrear} size="sm">
          <Plus className="mr-2 h-4 w-4" /> Nueva Categoría
        </Button>
      </div>

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
      />

      <Dialog open={dialogoAbierto} onOpenChange={setDialogoAbierto}>
        <DialogContent className="sm:max-w-[425px]">
          <DialogHeader>
            <DialogTitle>
              {idCategoriaAModificar ? "Editar Categoría" : "Nueva Categoría"}
            </DialogTitle>
            <DialogDescription>
              {idCategoriaAModificar 
                ? "Modifica los datos de la categoría seleccionada." 
                : "Agrega una nueva categoría para organizar tus productos."}
            </DialogDescription>
          </DialogHeader>

          {idCategoriaAModificar && cargandoDetalle ? (
            <div className="py-20 flex justify-center items-center">
              <Loading mensaje="Cargando detalle de la categoría..." />
            </div>
          ) : (
            <CategoriaForm
              key={idCategoriaAModificar || "nuevo"}
              datosIniciales={categoriaDetalle}
              alEnviar={manejarEnviar}
              alCancelar={manejarCerrar}
              cargando={crearCategoria.isPending || actualizarCategoria.isPending}
            />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
