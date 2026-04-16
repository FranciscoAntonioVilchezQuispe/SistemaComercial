SELECT n.id_nota, n.serie, n.numero, n.tipo_comprobante, n.id_compra_referencia, n.total, 
       (SELECT count(*) FROM compras.nota_credito_detalle d WHERE d.id_nota_credito = n.id_nota) as cantidad_detalles 
FROM compras.nota_credito n 
ORDER BY n.fecha_creacion DESC 
LIMIT 5;
