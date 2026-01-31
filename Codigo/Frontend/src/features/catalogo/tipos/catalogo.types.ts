/**
 * Tipos para el módulo de Catálogo
 */

// ============================================
// PRODUCTO
// ============================================

export interface Producto {
  id: number;
  codigo: string;
  nombre: string;
  descripcion?: string;

  // Relaciones
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

  // Precios
  precioCompra: number;
  precioVentaPublico: number;
  precioVentaMayorista: number;
  precioVentaDistribuidor: number;

  // Stock
  stock: number;
  stockMinimo: number;
  stockMaximo?: number;

  // Configuración de inventario
  tieneVariantes: boolean;
  permiteInventarioNegativo: boolean;

  // Configuración fiscal
  gravadoImpuesto: boolean;
  porcentajeImpuesto: number;

  // Imagen
  imagenPrincipalUrl?: string;

  // Auditoría
  activo: boolean;
  fechaCreacion: string;
  fechaModificacion?: string;
}

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
