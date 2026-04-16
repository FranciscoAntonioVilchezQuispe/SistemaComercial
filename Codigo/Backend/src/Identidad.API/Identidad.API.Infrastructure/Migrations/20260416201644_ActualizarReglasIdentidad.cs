using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Identidad.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class ActualizarReglasIdentidad : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // 1. Limpiar relación inversa antigua en trabajadores (USANDO NOMBRES REALES DETECTADOS)
            migrationBuilder.Sql("ALTER TABLE identidad.trabajadores DROP CONSTRAINT IF EXISTS fk_trabajadores_usuario;");
            migrationBuilder.Sql("ALTER TABLE identidad.trabajadores DROP COLUMN IF EXISTS id_usuario;");

            // 2. Limpiar relación directa antigua de Rol en Usuarios (ahora es N:N via UsuariosRoles)
            migrationBuilder.Sql("ALTER TABLE identidad.usuarios DROP CONSTRAINT IF EXISTS fk_usuarios_rol;");
            migrationBuilder.Sql("ALTER TABLE identidad.usuarios DROP COLUMN IF EXISTS id_rol;");

            // 3. Agregar nueva relación obligatoria con Trabajador (con valor por defecto temporal para evitar error en datos existentes)
            migrationBuilder.AddColumn<long>(
                name: "id_trabajador",
                schema: "identidad",
                table: "usuarios",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            // 4. Intentar asignar el administrador al trabajador 1 (si existe)
            migrationBuilder.Sql(@"
                UPDATE identidad.usuarios 
                SET id_trabajador = (SELECT id_trabajador FROM identidad.trabajadores WHERE numero_documento = '00000000' LIMIT 1)
                WHERE username = 'admin' AND id_trabajador = 0;
            ");

            // 5. Estandarización de nombres de columnas de auditoría a snake_case
            // Usamos DO blocks para ser ultra-seguros
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='identidad' AND table_name='usuarios' AND column_name='Activado') THEN
                    ALTER TABLE identidad.usuarios RENAME COLUMN ""Activado"" TO activado;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='identidad' AND table_name='usuarios' AND column_name='FechaCreacion') THEN
                    ALTER TABLE identidad.usuarios RENAME COLUMN ""FechaCreacion"" TO fecha_creacion;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='identidad' AND table_name='usuarios' AND column_name='UsuarioCreacion') THEN
                    ALTER TABLE identidad.usuarios RENAME COLUMN ""UsuarioCreacion"" TO usuario_creacion;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='identidad' AND table_name='usuarios' AND column_name='FechaActualizacion') THEN
                    ALTER TABLE identidad.usuarios RENAME COLUMN ""FechaActualizacion"" TO fecha_modificacion;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='identidad' AND table_name='usuarios' AND column_name='UsuarioActualizacion') THEN
                    ALTER TABLE identidad.usuarios RENAME COLUMN ""UsuarioActualizacion"" TO usuario_modificacion;
                END IF;
            END $$;");

            // Mismo proceso para trabajadores
             migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='identidad' AND table_name='trabajadores' AND column_name='Activado') THEN
                    ALTER TABLE identidad.trabajadores RENAME COLUMN ""Activado"" TO activado;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='identidad' AND table_name='trabajadores' AND column_name='FechaCreacion') THEN
                    ALTER TABLE identidad.trabajadores RENAME COLUMN ""FechaCreacion"" TO fecha_creacion;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='identidad' AND table_name='trabajadores' AND column_name='UsuarioCreacion') THEN
                    ALTER TABLE identidad.trabajadores RENAME COLUMN ""UsuarioCreacion"" TO usuario_creacion;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='identidad' AND table_name='trabajadores' AND column_name='FechaActualizacion') THEN
                    ALTER TABLE identidad.trabajadores RENAME COLUMN ""FechaActualizacion"" TO fecha_modificacion;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='identidad' AND table_name='trabajadores' AND column_name='UsuarioActualizacion') THEN
                    ALTER TABLE identidad.trabajadores RENAME COLUMN ""UsuarioActualizacion"" TO usuario_modificacion;
                END IF;
            END $$;");

            // 6. Crear Índices y Constraints (EF los manejará mejor si están limpios)
            migrationBuilder.CreateIndex(
                name: "ix_usuarios_id_trabajador",
                schema: "identidad",
                table: "usuarios",
                column: "id_trabajador",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "fk_usuarios_trabajadores_id_trabajador",
                schema: "identidad",
                table: "usuarios",
                column: "id_trabajador",
                principalSchema: "identidad",
                principalTable: "trabajadores",
                principalColumn: "id_trabajador",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
        }
    }
}
