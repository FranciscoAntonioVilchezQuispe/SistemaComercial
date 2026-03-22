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
  useMarca,
  useCrearMarca,
  useActualizarMarca,
  useEliminarMarca,
} from "../hooks/useMarcas";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import { Marca, MarcaFormData } from "../tipos/catalogo.types";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import { DataTable } from "@/components/ui/DataTable";
import { usePagination } from "@/hooks/usePagination";

export function PaginaMarcas() {
  const [dialogoAbierto, setDialogoAbierto] = useState(false);
  const [idMarcaAModificar, setIdMarcaAModificar] = useState<number | null>(null);

  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
    cambiarFiltroActivo,
  } = usePagination();

  const { data, isLoading, error } = useMarcas(paginacion);
  const { data: marcaDetalle, isLoading: cargandoDetalle } = useMarca(idMarcaAModificar || 0);
  const crearMarca = useCrearMarca();
  const actualizarMarca = useActualizarMarca();
  const eliminarMarca = useEliminarMarca();

  const marcas = data?.datos || [];

  const manejarAbrirCrear = () => {
    setIdMarcaAModificar(null);
    setDialogoAbierto(true);
  };

  const manejarAbrirEditar = (id: number) => {
    setIdMarcaAModificar(id);
    setDialogoAbierto(true);
  };

  const manejarCerrar = () => {
    setDialogoAbierto(false);
    setIdMarcaAModificar(null);
  };

  const manejarEnviar = (datos: MarcaFormData) => {
    if (idMarcaAModificar) {
      actualizarMarca.mutate(
        { id: idMarcaAModificar, datos },
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
            onClick={() => manejarAbrirEditar(marca.id)}
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
          <Plus className="mr-2 h-4 w-4" /> Nueva Marca
        </Button>
      </div>

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
      />

      <Dialog open={dialogoAbierto} onOpenChange={setDialogoAbierto}>
        <DialogContent className="sm:max-w-[425px]">
          <DialogHeader>
            <DialogTitle>
              {idMarcaAModificar ? "Editar Marca" : "Nueva Marca"}
            </DialogTitle>
          </DialogHeader>

          {idMarcaAModificar && cargandoDetalle ? (
            <div className="py-20 flex justify-center items-center">
              <Loading mensaje="Cargando detalle de la marca..." />
            </div>
          ) : (
            <MarcaForm
              key={idMarcaAModificar || "nuevo"}
              datosIniciales={marcaDetalle}
              alEnviar={manejarEnviar}
              alCancelar={manejarCerrar}
              cargando={crearMarca.isPending || actualizarMarca.isPending}
            />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
