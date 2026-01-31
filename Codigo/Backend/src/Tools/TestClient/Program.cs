using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        try
        {
            var client = new HttpClient();
            var json = "{ \"codigo\": \"PROD_AUDIT_03\", \"nombre\": \"Producto Auditado\", \"descripcion\": \"Desc\", \"precioBase\": 100, \"idCategoria\": 1, \"idMarca\": 1, \"idUnidadMedida\": 1 }";
            var content = new StringContent(json, Encoding.UTF8, "application/json");
            var response = await client.PostAsync("http://localhost:5008/api/productos", content);
            Console.WriteLine("Status: " + response.StatusCode);
            var body = await response.Content.ReadAsStringAsync();
            Console.WriteLine("Body: " + body);
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error: " + ex.Message);
        }
    }
}
