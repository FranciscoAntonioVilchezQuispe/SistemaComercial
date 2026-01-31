import { useState } from "react";
import { Plus, Edit2, Power } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { CatalogoHeader } from "../componentes/comunes/CatalogoHeader";
import { DataTable } from "@/components/ui/DataTable";
import { ProductoForm } from "../componentes/productos/ProductoForm";
import {
  useProductos,
  useCrearProducto,
  useActualizarProducto,
  useEliminarProducto,
} from "../hooks/useProductos";
import { usePagination } from "@/hooks/usePagination";
import { Producto } from "../tipos/catalogo.types";
import { toast } from "sonner";

export function PaginaProductos() {
  const [dialogoAbierto, setDialogoAbierto] = useState(false);
  const [productoAModificar, setProductoAModificar] = useState<Producto | null>(
    null,
  );

  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
    cambiarFiltroActivo,
  } = usePagination();

  const { data, isLoading, error } = useProductos(paginacion);
  const crearProducto = useCrearProducto();
  const actualizarProducto = useActualizarProducto();
  const eliminarProducto = useEliminarProducto();

  const productos = data?.datos || [];

  if (isLoading) return <div>Cargando...</div>; // O componente Loading si lo importo
  if (error) return <div>Error: {error.message}</div>;

  const manejarAbrirCrear = () => {
    setProductoAModificar(null);
    setDialogoAbierto(true);
  };

  const manejarAbrirEditar = (producto: Producto) => {
    setProductoAModificar(producto);
    setDialogoAbierto(true);
  };

  const manejarCerrar = () => {
    setDialogoAbierto(false);
    setProductoAModificar(null);
  };

  const manejarEnviar = async (datos: any) => {
    try {
      if (productoAModificar) {
        await actualizarProducto.mutateAsync({
          id: productoAModificar.id,
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
            onClick={() => manejarAbrirEditar(producto)}
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

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Productos</h1>
        <p className="text-muted-foreground">
          Gestiona el catálogo de productos, precios y stocks.
        </p>
      </div>

      <CatalogoHeader />

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
        <DialogContent className="sm:max-w-[700px] max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>
              {productoAModificar ? "Editar Producto" : "Nuevo Producto"}
            </DialogTitle>
          </DialogHeader>
          <ProductoForm
            datosIniciales={productoAModificar}
            alEnviar={manejarEnviar}
            alCancelar={manejarCerrar}
            cargando={crearProducto.isPending || actualizarProducto.isPending}
          />
        </DialogContent>
      </Dialog>
    </div>
  );
}

export default PaginaProductos;
