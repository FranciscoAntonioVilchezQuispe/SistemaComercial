-- Limpiar datos de prueba antes de restaurar del dump
TRUNCATE TABLE catalogo.productos, catalogo.variantes_producto, catalogo.categorias, catalogo.marcas, catalogo.unidades_medida CASCADE;
TRUNCATE TABLE clientes.clientes, clientes.contactos_cliente CASCADE;
TRUNCATE TABLE compras.compras, compras.detalle_compra, compras.ordenes_compra, compras.detalle_orden_compra, compras.proveedores CASCADE;
TRUNCATE TABLE configuracion.tablas_generales, configuracion.tablas_generales_detalle CASCADE;
TRUNCATE TABLE configuracion.configuraciones CASCADE;
DELETE FROM configuracion.empresa; 
