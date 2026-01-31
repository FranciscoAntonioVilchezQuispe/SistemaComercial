using Npgsql;
using System;
using System.IO;

class Program
{
    static void Main(string[] args)
    {
        var connectionString = "Server=localhost;Port=5432;Database=sistema_comercial;User Id=postgres;Password=aaAA11++;";
        var scriptPath = args.Length > 0 ? args[0] : "scripts/01_sistema_permisos_granulares.sql";

        try
        {
            Console.WriteLine($"Leyendo script: {scriptPath}");
            var sql = File.ReadAllText(scriptPath);

            Console.WriteLine("Conectando a la base de datos...");
            using var connection = new NpgsqlConnection(connectionString);
            connection.Open();

            Console.WriteLine("Ejecutando script SQL...");
            using var command = new NpgsqlCommand(sql, connection);
            command.CommandTimeout = 120; // 2 minutos

            var reader = command.ExecuteReader();
            
            // Leer resultados de la verificación
            Console.WriteLine("\n=== RESULTADOS ===");
            while (reader.Read())
            {
                Console.WriteLine($"{reader.GetString(0)}: {reader.GetInt64(1)} registros");
            }

            Console.WriteLine("\n✅ Script ejecutado exitosamente!");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"\n❌ Error: {ex.Message}");
            Console.WriteLine(ex.StackTrace);
            Environment.Exit(1);
        }
    }
}
