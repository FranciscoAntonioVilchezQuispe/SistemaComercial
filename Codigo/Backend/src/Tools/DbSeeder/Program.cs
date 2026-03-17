using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Threading.Tasks;
using Npgsql;

class Program
{
    static string ConnectionString = "Server=localhost;Port=5432;Database=sistema_comercial;User Id=postgres;Password=aaAA11++;";

    static Dictionary<string, string> TableSchemaMap = new()
    {
        { "empresa", "configuracion" },
        { "configuraciones", "configuracion" },
        { "series_comprobantes", "configuracion" },
        { "roles", "identidad" },
        { "usuarios", "identidad" },
        { "permisos", "identidad" },
        { "roles_permisos", "identidad" },
        { "auditoria_accesos", "identidad" },
        { "areas", "identidad" },
        { "cargos", "identidad" },
        { "trabajadores", "identidad" },
        { "categorias", "catalogo" },
        { "marcas", "catalogo" },
        { "unidades_medida", "catalogo" },
        { "productos", "catalogo" },
        { "variantes_producto", "catalogo" },
        { "imagenes_producto", "catalogo" },
        { "listas_precios", "catalogo" },
        { "almacenes", "inventario" },
        { "stock", "inventario" },
        { "movimientos_inventario", "inventario" },
        { "clientes", "clientes" },
        { "contactos_cliente", "clientes" },
        { "proveedores", "compras" },
        { "ordenes_compra", "compras" },
        { "detalle_orden_compra", "compras" },
        { "compras", "compras" },
        { "detalle_compra", "compras" },
        { "cajas", "ventas" },
        { "cotizaciones", "ventas" },
        { "detalle_cotizacion", "ventas" },
        { "ventas", "ventas" },
        { "detalle_venta", "ventas" },
        { "metodos_pago", "ventas" },
        { "pagos", "ventas" },
        { "movimientos_caja", "ventas" },
        { "plan_cuentas", "contabilidad" },
        { "centros_costo", "contabilidad" },
        { "asientos_contables", "contabilidad" },
        { "detalle_asiento", "contabilidad" }
    };

    static async Task Main(string[] args)
    {
        Console.WriteLine("Iniciando DbSeeder V12 (Robust Recovery)...");

        try
        {
            if (args.Length > 0 && args[0].Equals("RESET", StringComparison.OrdinalIgnoreCase))
            {
                Console.WriteLine("!!! MODO RESET INICIADO !!!");
                var schemas = TableSchemaMap.Values.Distinct().ToList();
                Console.WriteLine("Borrando esquemas (CASCADE)...");
                foreach (var s in schemas)
                {
                    await ExecuteSqlAsync($"DROP SCHEMA IF EXISTS {s} CASCADE;");
                }
                
                Console.WriteLine("Limpiando funciones en public...");
                await ExecuteSqlAsync("DROP FUNCTION IF EXISTS public.update_fecha_modificacion_column() CASCADE;");
                
                string baseDir = AppContext.BaseDirectory;
                string projectRoot = Path.GetFullPath(Path.Combine(baseDir, "..", "..", "..", "..", "..", ".."));
                
                string[] baseScripts = { 
                    "00_init_schemas.sql", 
                    "01_base_schema.sql", 
                };
                foreach (var script in baseScripts)
                {
                    string path = Path.Combine(projectRoot, "scripts", script);
                    if (File.Exists(path))
                    {
                        Console.WriteLine($"\n>>> EJECUTANDO: {script}...");
                        await ExecuteSqlAsync(File.ReadAllText(path));
                    }
                }

                Console.WriteLine("\n>>> EJECUTANDO BOOTSTRAP DE TABLAS FALTANTES...");
                string bootstrapPath = Path.Combine(projectRoot, "scripts", "02_bootstrap_sunat.sql");
                if (File.Exists(bootstrapPath)) 
                    await ExecuteSqlAsync(File.ReadAllText(bootstrapPath));

                Console.WriteLine("\n>>> LIMPANDO HISTORIAL DE MIGRACIONES PARA RECONSTRUCCIÓN...");
                await ExecuteSqlAsync("TRUNCATE TABLE public.\"__EFMigrationsHistory\" RESTART IDENTITY CASCADE;");

                string[] nextScripts = { 
                    "03_base_data.sql", 
                    "04_delta_schema.sql",
                    "05_sunat_master_data.sql",
                    "06_sunat_improvements_views.sql",
                    "07_sync_ef_history.sql"
                };
                foreach (var script in nextScripts)
                {
                    string path = Path.Combine(projectRoot, "scripts", script);
                    if (File.Exists(path))
                    {
                        Console.WriteLine($"\n>>> EJECUTANDO: {script}...");
                        await ExecuteSqlAsync(File.ReadAllText(path));
                    }
                }
                Console.WriteLine("\n=== RESET COMPLETADO ===");
                return;
            }

            if (args.Length > 0 && File.Exists(args[0]))
            {
                string filePath = args[0];
                Console.WriteLine($"Ejecutando script: {filePath}...");
                await ExecuteSqlAsync(File.ReadAllText(filePath));
                Console.WriteLine("Script ejecutado exitosamente.");
                return;
            }

            Console.WriteLine("Uso: DbSeeder [RESET | <path_to_sql>]");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"\n!!! ERROR CRÍTICO !!! {ex.Message}");
        }
    }

    static async Task ExecuteSqlAsync(string sql)
    {
        if (sql.Contains("-- TOC entry"))
        {
            var blocks = sql.Split(new[] { "-- TOC entry" }, StringSplitOptions.None);
            Console.WriteLine($"Procesando {blocks.Length} bloques...");
            int success = 0; int fail = 0;

            foreach (var block in blocks)
            {
                if (string.IsNullOrWhiteSpace(block)) continue;
                string blockSql = "-- TOC entry" + block;
                if (await ExecuteInternalAsync(blockSql, false)) success++; else fail++;
            }
            Console.WriteLine($"Resultado: {success} exitosos, {fail} fallidos.");
        }
        else
        {
            await ExecuteInternalAsync(sql, true);
        }
    }

    static async Task<bool> ExecuteInternalAsync(string sql, bool showResults)
    {
        var lines = sql.Split('\n')
            .Where(l => !l.TrimStart().StartsWith("SET transaction_timeout", StringComparison.OrdinalIgnoreCase))
            .Where(l => !l.TrimStart().StartsWith("SET idle_in_transaction_session_timeout", StringComparison.OrdinalIgnoreCase))
            .Where(l => !l.TrimStart().StartsWith("SET lock_timeout", StringComparison.OrdinalIgnoreCase))
            .Where(l => !l.TrimStart().StartsWith("SET statement_timeout", StringComparison.OrdinalIgnoreCase))
            .Where(l => !l.TrimStart().StartsWith("SET client_min_messages", StringComparison.OrdinalIgnoreCase))
            .Where(l => !l.Contains("OWNER TO", StringComparison.OrdinalIgnoreCase))
            .Where(l => !l.Contains("set_config('search_path'", StringComparison.OrdinalIgnoreCase));

        string sanitizedSql = string.Join("\n", lines).Trim();
        if (string.IsNullOrWhiteSpace(sanitizedSql)) return true;

        using var conn = new NpgsqlConnection(ConnectionString);
        try 
        {
            await conn.OpenAsync();
            
            string trimmedSql = sanitizedSql.Trim();
            bool isSelect = Regex.IsMatch(trimmedSql, @"^(?i)(--.*?\n|/\*.*?\*/|)\s*SELECT");

            if (showResults && isSelect)
            {
                using var cmd = new NpgsqlCommand(sanitizedSql, conn);
                cmd.CommandTimeout = 600;
                using var reader = await cmd.ExecuteReaderAsync();
                for (int i = 0; i < reader.FieldCount; i++) Console.Write($"{reader.GetName(i)}\t");
                Console.WriteLine("\n" + new string('-', 50));
                while (await reader.ReadAsync())
                {
                    for (int i = 0; i < reader.FieldCount; i++) Console.Write($"{reader.GetValue(i)}\t");
                    Console.WriteLine();
                }
            }
            else
            {
                var statements = new List<string>();
                var currentBatch = new StringBuilder();
                bool inBlock = false;

                foreach (var line in sanitizedSql.Split('\n'))
                {
                    string trimmed = line.Trim();
                    if (trimmed.Contains("$$") || trimmed.StartsWith("DO ")) inBlock = !inBlock;
                    
                    currentBatch.AppendLine(line);
                    
                    if (!inBlock && trimmed.EndsWith(";"))
                    {
                        statements.Add(currentBatch.ToString().Trim(';').Trim());
                        currentBatch.Clear();
                    }
                }
                if (currentBatch.Length > 0) statements.Add(currentBatch.ToString().Trim());

                int totalAffected = 0;
                foreach (var stmt in statements.Where(s => !string.IsNullOrWhiteSpace(s)))
                {
                    using var cmd = new NpgsqlCommand(stmt, conn);
                    cmd.CommandTimeout = 600;
                    try 
                    {
                        int affected = await cmd.ExecuteNonQueryAsync();
                        if (affected > 0)
                        {
                            totalAffected += affected;
                            if (showResults) Console.WriteLine($"[EXITO] {stmt.Substring(0, Math.Min(50, stmt.Length))}... -> {affected} filas");
                        }
                    }
                    catch (Exception exStatement)
                    {
                        if (showResults) Console.WriteLine($"\n[ERROR] en sentencia: {stmt.Substring(0, Math.Min(100, stmt.Length))}...\nMENSAJE: {exStatement.Message}");
                    }
                }
                if (showResults && totalAffected > 0) Console.WriteLine($"Filas afectadas totales: {totalAffected}");
            }
            return true;
        }
        catch (Exception ex)
        {
            if (showResults || (!ex.Message.Contains("ya existe") && !ex.Message.Contains("already exists")))
            {
                Console.WriteLine($"\n!!! ERROR EN SQL !!! {ex.Message}");
            }
            return false;
        }
    }
}
