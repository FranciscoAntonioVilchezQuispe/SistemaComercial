-- Crear la tabla de historia si no existe
CREATE TABLE IF NOT EXISTS identidad."__ef_migrations_history" (
    "migration_id" varchar(150) NOT NULL,
    "product_version" varchar(32) NOT NULL,
    CONSTRAINT "pk___ef_migrations_history" PRIMARY KEY ("migration_id")
);

-- Insertar la migración inicial si no existe (asumiendo que las tablas ya existen)
INSERT INTO identidad."__ef_migrations_history" ("migration_id", "product_version")
SELECT '20260128013527_InicialIdentidad', '8.0.0'
WHERE NOT EXISTS (
    SELECT 1 FROM identidad."__ef_migrations_history" WHERE "migration_id" = '20260128013527_InicialIdentidad'
);
