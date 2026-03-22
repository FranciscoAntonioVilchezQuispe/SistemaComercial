import { useState } from "react";
import { Plus, Edit2, Power } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import { DataTable } from "@/components/ui/DataTable";
import { ProductoForm } from "../componentes/productos/ProductoForm";
import {
  useProductos,
  useProducto,
  useCrearProducto,
  useActualizarProducto,
  useEliminarProducto,
} from "../hooks/useProductos";
import { usePagination } from "@/hooks/usePagination";
import { Producto } from "../tipos/catalogo.types";
import { toast } from "sonner";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";

export function PaginaProductos() {
  const [dialogoAbierto, setDialogoAbierto] = useState(false);
  const [idProductoAEditar, setIdProductoAEditar] = useState<number | null>(null);

  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
    cambiarFiltroActivo,
  } = usePagination();

  const { data, isLoading, error } = useProductos(paginacion);
  const { data: respDetalle, isLoading: cargandoDetalle } = useProducto(idProductoAEditar || 0);
  const crearProducto = useCrearProducto();
  const actualizarProducto = useActualizarProducto();
  const eliminarProducto = useEliminarProducto();
  const productoDetalle = respDetalle as any; // Usamos el objeto directamente ya que el servicio hace response.data

  const productos = data?.datos || [];

  if (isLoading) return <Loading mensaje="Cargando productos..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const manejarAbrirCrear = () => {
    setIdProductoAEditar(null);
    setDialogoAbierto(true);
  };

  const manejarAbrirEditar = (id: number) => {
    setIdProductoAEditar(id);
    setDialogoAbierto(true);
  };

  const manejarCerrar = () => {
    setDialogoAbierto(false);
    setIdProductoAEditar(null);
  };

  const manejarEnviar = async (datos: any) => {
    try {
      if (idProductoAEditar) {
        await actualizarProducto.mutateAsync({
          id: idProductoAEditar,
          datos,
        });
        toast.success("Producto actualizado correctamente");
      } else {
        await crearProducto.mutateAsync(datos);
        toast.success("Producto creado correctamente");
      }
      manejarCerrar();
    } catch (error) {
      // El error ya es manejado por el hook
    }
  };

  const manejarCambiarEstado = async (id: number, estadoActual: boolean) => {
    try {
      // Usamos el hook de eliminar que ahora hace borrado lógico (toggle activo)
      await eliminarProducto.mutateAsync(id);
      toast.success(
        `Producto ${estadoActual ? "desactivado" : "activado"} correctamente`,
      );
    } catch (error) {
      // El error ya es manejado por el hook
    }
  };

  const columns = [
    {
      header: "Código",
      accessorKey: "codigo" as keyof Producto,
      className: "w-[100px]",
    },
    {
      header: "Nombre",
      accessorKey: "nombre" as keyof Producto,
      className: "font-medium",
    },
    {
      header: "Categoría",
      accessorKey: "categoria.nombre" as any,
      cell: (producto: Producto) => producto.categoria?.nombre || "-",
    },
    {
      header: "Marca",
      accessorKey: "marca.nombre" as any,
      cell: (producto: Producto) => producto.marca?.nombre || "-",
    },
    {
      header: "Precio",
      accessorKey: "precio" as keyof Producto,
      cell: (producto: Producto) =>
        producto.precioVentaPublico != null
          ? `S/ ${producto.precioVentaPublico.toFixed(2)}`
          : "-",
    },
    {
      header: "Stock",
      accessorKey: "stock" as keyof Producto,
      cell: (producto: Producto) => (
        <span
          className={
            producto.stock <= producto.stockMinimo
              ? "text-red-500 font-bold"
              : ""
          }
        >
          {producto.stock}
        </span>
      ),
    },
    {
      header: "Estado",
      accessorKey: "activo" as keyof Producto,
      cell: (producto: Producto) => (
        <span
          className={`px-2 py-1 rounded text-xs font-medium ${
            producto.activo
              ? "bg-green-100 text-green-800"
              : "bg-red-100 text-red-800"
          }`}
        >
          {producto.activo ? "Activo" : "Inactivo"}
        </span>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (producto: Producto) => (
        <div className="flex justify-end space-x-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => manejarAbrirEditar(producto.id)}
            title="Editar"
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className={producto.activo ? "text-destructive" : "text-green-600"}
            onClick={() => manejarCambiarEstado(producto.id, producto.activo)}
            title={producto.activo ? "Desactivar" : "Activar"}
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
          <Plus className="mr-2 h-4 w-4" /> Nuevo Producto
        </Button>
      </div>

      <DataTable
        data={productos}
        columns={columns}
        pagination={data}
        onPageChange={cambiarPagina}
        onPageSizeChange={cambiarPageSize}
        onSearchChange={cambiarBusqueda}
        onActiveFilterChange={cambiarFiltroActivo}
        searchPlaceholder="Buscar por nombre o código..."
        isLoading={isLoading}
      />

      <Dialog open={dialogoAbierto} onOpenChange={setDialogoAbierto}>
        <DialogContent className="sm:max-w-[700px] max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>
              {idProductoAEditar ? "Editar Producto" : "Nuevo Producto"}
            </DialogTitle>
          </DialogHeader>
          
          {idProductoAEditar && cargandoDetalle ? (
            <div className="py-20 flex justify-center items-center">
              <Loading mensaje="Cargando detalle del producto..." />
            </div>
          ) : (
            <ProductoForm
              key={idProductoAEditar || "nuevo"}
              datosIniciales={idProductoAEditar ? productoDetalle : null}
              alEnviar={manejarEnviar}
              alCancelar={manejarCerrar}
              cargando={crearProducto.isPending || actualizarProducto.isPending}
            />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}

export default PaginaProductos;
