// Exportar páginas
export { PaginaProductos } from "./paginas/PaginaProductos";
export { PaginaCategorias } from "./paginas/PaginaCategorias";
export { PaginaMarcas } from "./paginas/PaginaMarcas";

// Exportar componentes
export { TarjetaProducto } from "./componentes/productos/TarjetaProducto";
export { TablaProductos } from "./componentes/productos/TablaProductos";

// Exportar hooks
export {
  useProductos,
  useProducto,
  useCrearProducto,
  useActualizarProducto,
  useEliminarProducto,
} from "./hooks/useProductos";
export {
  useCategorias,
  useCategoria,
  useCrearCategoria,
  useActualizarCategoria,
  useEliminarCategoria,
} from "./hooks/useCategorias";
export {
  useMarcas,
  useMarca,
  useCrearMarca,
  useActualizarMarca,
  useEliminarMarca,
} from "./hooks/useMarcas";

// Exportar tipos
export type {
  Producto,
  ProductoFormData,
  ProductoFiltros,
} from "./tipos/catalogo.types";
export type { Categoria, CategoriaFormData } from "./tipos/catalogo.types";
export type { Marca, MarcaFormData } from "./tipos/catalogo.types";
