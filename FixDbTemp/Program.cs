using Npgsql;
using System;

var connectionString = "Server=localhost;Port=5432;Database=sistema_comercial;User Id=postgres;Password=aaAA11++;";
using var conn = new NpgsqlConnection(connectionString);
conn.Open();

Console.WriteLine("Renombrando columnas en __EFMigrationsHistory...");
try {
    using var cmd = new NpgsqlCommand("ALTER TABLE \"__EFMigrationsHistory\" RENAME COLUMN migration_id TO \"MigrationId\";", conn);
    cmd.ExecuteNonQuery();
    Console.WriteLine("Columna migration_id -> MigrationId OK");
} catch (Exception ex) { Console.WriteLine("Error o ya renombrada: " + ex.Message); }

try {
    using var cmd = new NpgsqlCommand("ALTER TABLE \"__EFMigrationsHistory\" RENAME COLUMN product_version TO \"ProductVersion\";", conn);
    cmd.ExecuteNonQuery();
    Console.WriteLine("Columna product_version -> ProductVersion OK");
} catch (Exception ex) { Console.WriteLine("Error o ya renombrada: " + ex.Message); }

Console.WriteLine("Proceso finalizado.");
