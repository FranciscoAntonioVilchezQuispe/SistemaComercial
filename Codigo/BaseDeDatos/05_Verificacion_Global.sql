-- Verificacion Global
SELECT 'Tablas Schema Catalogo' as tabla, count(*)::bigint as total FROM information_schema.tables WHERE table_schema = 'catalogo'
UNION ALL
SELECT 'Tablas Schema Clientes', count(*)::bigint FROM information_schema.tables WHERE table_schema = 'clientes'
UNION ALL
SELECT 'Tablas Schema Compras', count(*)::bigint FROM information_schema.tables WHERE table_schema = 'compras'
UNION ALL
SELECT 'Tablas Schema Identidad', count(*)::bigint FROM information_schema.tables WHERE table_schema = 'identidad';
