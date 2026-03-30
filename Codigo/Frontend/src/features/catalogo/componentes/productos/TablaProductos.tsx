import { TablaPaginada } from "@compartido/componentes/tablas/TablaPaginada";
import { ColumnaAcciones } from "@compartido/componentes/tablas/ColumnaAcciones";
import { Badge } from "@/components/ui/badge";
import { ProductoResumen } from "../../tipos/catalogo.types";
import { formatearMoneda } from "@compartido/utilidades/moneda";

interface PropiedadesTablaProductos {
  productos: ProductoResumen[];
  cargando?: boolean;
  error?: string;
  alEditar: (producto: ProductoResumen) => void;
  alEliminar: (producto: ProductoResumen) => void;
  alVer: (producto: ProductoResumen) => void;
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
      renderizar: (producto: ProductoResumen) => (
        <div>
          <p className="font-medium">{producto.nombre}</p>
        </div>
      ),
    },
    {
      clave: "categoria",
      titulo: "Categoría",
      ancho: "150px",
      renderizar: (producto: ProductoResumen) => producto.categoriaNombre || "-",
    },
    {
      clave: "marca",
      titulo: "Marca",
      ancho: "120px",
      renderizar: (producto: ProductoResumen) => producto.marcaNombre || "-",
    },
    {
      clave: "precio",
      titulo: "Precio",
      ancho: "120px",
      renderizar: (producto: ProductoResumen) =>
        formatearMoneda(producto.precioVentaPublico),
    },
    {
      clave: "stock",
      titulo: "Stock",
      ancho: "100px",
      renderizar: (producto: ProductoResumen) => (
        <span>
          {producto.stock} {producto.unidadMedidaNombre}
        </span>
      ),
    },
    {
      clave: "activo",
      titulo: "Estado",
      ancho: "100px",
      renderizar: (producto: ProductoResumen) => (
        <Badge variant={producto.activo ? "default" : "secondary"}>
          {producto.activo ? "Activo" : "Inactivo"}
        </Badge>
      ),
    },
    {
      clave: "acciones",
      titulo: "Acciones",
      ancho: "120px",
      renderizar: (producto: ProductoResumen) => (
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
