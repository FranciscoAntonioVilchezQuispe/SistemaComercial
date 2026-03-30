/**
 * Tipos para el módulo de Catálogo
 */

// ============================================
// PRODUCTO
// ============================================

/** Interface ligera para el listado de productos (Grids) */
export interface ProductoResumen {
  id: number;
  codigo: string;
  nombre: string;
  categoriaNombre?: string;
  marcaNombre?: string;
  unidadMedidaNombre?: string;
  precioVentaPublico: number;
  stock: number;
  activo: boolean;
  imagenPrincipalUrl?: string;
}

/** Interface completa para la ficha técnica del producto */
export interface ProductoDetalle {
  id: number;
  codigo: string;
  nombre: string;
  descripcion?: string;

  // Relaciones completas
  idCategoria: number;
  categoria?: Categoria;
  idMarca: number;
  marca?: Marca;
  idUnidadMedida: number;
  unidadMedida?: UnidadMedida;
  idTipoProducto?: number;

  // Códigos adicionales
  codigoBarras?: string;
  sku?: string;

  // Precios y Costos
  precioCompra: number;
  precioVentaPublico: number;
  precioVentaMayorista: number;
  precioVentaDistribuidor: number;

  // Stock y Almacén
  stock: number;
  stockMinimo: number;
  stockMaximo?: number;

  // Configuración técnica
  tieneVariantes: boolean;
  permiteInventarioNegativo: boolean;
  metodoValuacion: string;

  // Configuración fiscal
  gravadoImpuesto: boolean;
  porcentajeImpuesto: number;

  // Media
  imagenPrincipalUrl?: string;

  // Auditoría
  activo: boolean;
  fechaCreacion: string;
  fechaModificacion?: string;
}

/** @deprecated Usar ProductoResumen o ProductoDetalle */
export type Producto = ProductoResumen | ProductoDetalle;

export interface ProductoFormData {
  codigo: string;
  nombre: string;
  descripcion?: string;

  // Relaciones
  idCategoria: number;
  idMarca: number;
  idUnidadMedida: number;
  idTipoProducto?: number;

  // Códigos adicionales
  codigoBarras?: string;
  sku?: string;

  // Precios
  precioCompra: number;
  precioVentaPublico: number;
  precioVentaMayorista: number;
  precioVentaDistribuidor: number;

  // Stock
  stockMinimo: number;
  stockMaximo?: number;

  // Configuración de inventario
  tieneVariantes: boolean;
  permiteInventarioNegativo: boolean;
  metodoValuacion: string;

  // Configuración fiscal
  gravadoImpuesto: boolean;
  porcentajeImpuesto: number;

  // Imagen
  imagenPrincipalUrl?: string;

  // Auditoría
  activo: boolean;
}

export interface ProductoFiltros {
  busqueda?: string;
  idCategoria?: number;
  idMarca?: number;
  idTipoProducto?: number;
  activo?: boolean;
  precioMin?: number;
  precioMax?: number;
  stockBajo?: boolean;
}

// ============================================
// CATEGORÍA
// ============================================

export interface Categoria {
  id: number;
  nombre: string;
  descripcion?: string;
  idCategoriaPadre?: number;
  categoriaPadre?: Categoria;
  subcategorias?: Categoria[];
  activo: boolean;
  fechaCreacion: string;
  fechaModificacion?: string;
}

export interface CategoriaFormData {
  nombre: string;
  descripcion?: string;
  idCategoriaPadre?: number;
  activo: boolean;
}

// ============================================
// MARCA
// ============================================

export interface Marca {
  id: number;
  nombre: string;
  descripcion?: string;
  logoUrl?: string;
  paisOrigen?: string;
  activo: boolean;
  fechaCreacion: string;
  fechaModificacion?: string;
}

export interface MarcaFormData {
  nombre: string;
  descripcion?: string;
  logoUrl?: string;
  paisOrigen?: string;
  activo: boolean;
}

// ============================================
// UNIDAD DE MEDIDA
// ============================================

export interface UnidadMedida {
  id: number;
  codigo: string;
  nombre: string;
  simbolo?: string;
  descripcion?: string;
  activo: boolean;
  fechaCreacion: string;
  fechaModificacion?: string;
}

export interface UnidadMedidaFormData {
  codigo: string;
  nombre: string;
  descripcion?: string;
  activo: boolean;
}

// ============================================
// RESPUESTAS API
// ============================================
import { PagedResponse } from "@/types/pagination.types";

export interface RespuestaProductos extends PagedResponse<Producto> {}

export interface RespuestaCategorias extends PagedResponse<Categoria> {}

export interface RespuestaMarcas {
  datos: Marca[];
  total: number;
}

export interface RespuestaUnidadesMedida {
  datos: UnidadMedida[];
  total: number;
}

// ============================================
// LISTAS DE PRECIOS
// ============================================

export interface ListaPrecio {
  id: number;
  nombre: string;
  descripcion?: string;
  activo: boolean;
  codigo: string; // e.g. 'MAYORISTA', 'PUBLICO'
  fechaCreacion: string;
}

export interface ListaPrecioFormData {
  nombre: string;
  descripcion?: string;
  codigo: string;
  activo: boolean; // default true
}

export interface RespuestaListasPrecios {
  datos: ListaPrecio[];
  total: number;
}
