-- LIMPIEZA DE NOTA DE CRÉDITO ERRÓNEA Y RESTAURACIÓN DE COMPRA
DELETE FROM compras.nota_credito_detalle WHERE id_nota_credito = 1;
DELETE FROM compras.nota_credito WHERE id_nota = 1;

-- Restaurar el estado de la compra #1 para poder probar de nuevo
UPDATE compras.compras 
SET id_estado = 1, -- Registrado
    id_nota_credito = NULL,
    tipo_anulacion = NULL,
    fecha_anulacion = NULL,
    motivo_anulacion = NULL,
    observaciones = 'Restaurado por limpieza de datos post-error de NC'
WHERE id_compra = 1;

-- Verificar
SELECT id_compra, id_estado, id_nota_credito FROM compras.compras WHERE id_compra = 1;
