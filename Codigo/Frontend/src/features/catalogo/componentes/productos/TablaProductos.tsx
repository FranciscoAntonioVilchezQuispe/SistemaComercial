import { TablaPaginada } from "@compartido/componentes/tablas/TablaPaginada";
import { ColumnaAcciones } from "@compartido/componentes/tablas/ColumnaAcciones";
import { Badge } from "@/components/ui/badge";
import { Producto } from "../../tipos/catalogo.types";
import { formatearMoneda } from "@compartido/utilidades/moneda";

interface PropiedadesTablaProductos {
  productos: Producto[];
  cargando?: boolean;
  error?: string;
  alEditar: (producto: Producto) => void;
  alEliminar: (producto: Producto) => void;
  alVer: (producto: Producto) => void;
}

export function TablaProductos({
  productos,
  cargando,
  error,
  alEditar,
  alEliminar,
  alVer,
}: PropiedadesTablaProductos) {
  const columnas = [
    {
      clave: "codigo",
      titulo: "Código",
      ancho: "120px",
    },
    {
      clave: "nombre",
      titulo: "Nombre",
      renderizar: (producto: Producto) => (
        <div>
          <p className="font-medium">{producto.nombre}</p>
          {producto.descripcion && (
            <p className="text-sm text-muted-foreground line-clamp-1">
              {producto.descripcion}
            </p>
          )}
        </div>
      ),
    },
    {
      clave: "categoria",
      titulo: "Categoría",
      ancho: "150px",
      renderizar: (producto: Producto) => producto.categoria?.nombre || "-",
    },
    {
      clave: "marca",
      titulo: "Marca",
      ancho: "120px",
      renderizar: (producto: Producto) => producto.marca?.nombre || "-",
    },
    {
      clave: "precio",
      titulo: "Precio",
      ancho: "120px",
      renderizar: (producto: Producto) =>
        formatearMoneda(producto.precioVentaPublico),
    },
    {
      clave: "stock",
      titulo: "Stock",
      ancho: "100px",
      renderizar: (producto: Producto) => {
        const stockBajo = producto.stock <= producto.stockMinimo;
        return (
          <span className={stockBajo ? "text-destructive font-semibold" : ""}>
            {producto.stock} {producto.unidadMedida?.nombre}
          </span>
        );
      },
    },
    {
      clave: "activo",
      titulo: "Estado",
      ancho: "100px",
      renderizar: (producto: Producto) => (
        <Badge variant={producto.activo ? "default" : "secondary"}>
          {producto.activo ? "Activo" : "Inactivo"}
        </Badge>
      ),
    },
    {
      clave: "acciones",
      titulo: "Acciones",
      ancho: "120px",
      renderizar: (producto: Producto) => (
        <ColumnaAcciones
          compacto
          acciones={[
            {
              tipo: "ver",
              alClick: () => alVer(producto),
            },
            {
              tipo: "editar",
              alClick: () => alEditar(producto),
            },
            {
              tipo: "eliminar",
              alClick: () => alEliminar(producto),
              variante: "destructive",
            },
          ]}
        />
      ),
    },
  ];

  return (
    <TablaPaginada
      datos={productos}
      columnas={columnas}
      cargando={cargando}
      error={error}
      mensajeVacio="No hay productos registrados"
      descripcionVacio="Comienza agregando tu primer producto"
    />
  );
}
