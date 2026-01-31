using System;
using System.IO;
using System.Linq;
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
        Console.WriteLine("Iniciando DbSeeder V9 (Regex Perfection)...");

        try
        {
            var schemas = TableSchemaMap.Values.Distinct().ToList();
            Console.WriteLine("Limpiando esquemas...");
            foreach (var s in schemas)
            {
                await ExecuteSqlAsync($"DROP SCHEMA IF EXISTS {s} CASCADE;");
            }

            Console.WriteLine("Creando esquemas...");
            await ExecuteSqlAsync(string.Join("\n", schemas.Select(s => $"CREATE SCHEMA IF NOT EXISTS {s};")));

            string schemaPath = @"E:\ProyectosNuevos\SistemaComercial\Codigo\BaseDeDatos\schema_full.sql";
            if (File.Exists(schemaPath))
            {
                Console.WriteLine($"Procesando Schema {schemaPath}...");
                string content = File.ReadAllText(schemaPath);

                content = content.Replace("fecha_create", "fecha_creacion");
                content = content.Replace("usuario_create", "usuario_creacion");
                content = content.Replace("fecha_update", "fecha_modificacion");
                content = content.Replace("usuario_update", "usuario_modificacion");
                content = content.Replace("update_fecha_update_column", "update_fecha_modificacion_column");

                // Regex corregido V9: 
                // UPDATE no consume ON
                // ON no consume TABLE
                string pattern = @"\b(TABLE|REFERENCES|INTO|UPDATE(?!\s+ON\b)|ON(?!\s+TABLE\b)|FROM|JOIN)\s+(?:(IF\s+EXISTS)\s+)?([a-zA-Z0-9_]+)\b";

                string transformed = Regex.Replace(content, pattern, match =>
                {
                    string keyword = match.Groups[1].Value;
                    string ifExists = match.Groups[2].Value;
                    string tableName = match.Groups[3].Value;

                    if (tableName.Contains(".")) return match.Value;

                    if (TableSchemaMap.TryGetValue(tableName, out string? schema))
                    {
                        string fullTable = $"{schema}.{tableName}";
                        string middle = string.IsNullOrEmpty(ifExists) ? "" : $"{ifExists} ";
                        return $"{keyword} {middle}{fullTable}";
                    }
                    return match.Value;
                }, RegexOptions.IgnoreCase);

                string debugPath = @"E:\ProyectosNuevos\SistemaComercial\Codigo\BaseDeDatos\debug_schema_final_v9.sql";
                await File.WriteAllTextAsync(debugPath, transformed);

                await ExecuteSqlAsync(transformed);
                Console.WriteLine("Schema ejecutado correctamente.");
            }

            string seedPath = @"E:\ProyectosNuevos\SistemaComercial\Codigo\BaseDeDatos\seeds_catalogo.sql";
            if (File.Exists(seedPath))
            {
                Console.WriteLine($"Procesando Seeds {seedPath}...");
                string content = File.ReadAllText(seedPath);
                await ExecuteSqlAsync(content);
                Console.WriteLine("Seeds ejecutados correctamente.");
            }

            Console.WriteLine("=== PROCESO FINALIZADO EXITOSAMENTE ===");
        }
        catch (Exception ex)
        {
            await File.WriteAllTextAsync("error_dbseeder_v9.log", ex.ToString());
            Console.WriteLine($"\n!!! ERROR FATAL !!! Saved to error_dbseeder_v9.log");
        }
    }

    static async Task ExecuteSqlAsync(string sql)
    {
        using var conn = new NpgsqlConnection(ConnectionString);
        await conn.OpenAsync();
        using var cmd = new NpgsqlCommand(sql, conn);
        cmd.CommandTimeout = 600;
        await cmd.ExecuteNonQueryAsync();
    }
}
