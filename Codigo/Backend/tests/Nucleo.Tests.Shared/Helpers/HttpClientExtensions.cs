using System.Net.Http;
using System.Net.Http.Headers;

namespace Nucleo.Tests.Shared.Helpers
{
    public static class HttpClientExtensions
    {
        public static HttpClient ConToken(this HttpClient client, string token)
        {
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            return client;
        }

        public static HttpClient ConHeadersGateway(this HttpClient client, long userId, string rol)
        {
            client.DefaultRequestHeaders.Add("X-User-Id", userId.ToString());
            client.DefaultRequestHeaders.Add("X-User-Roles", rol);
            return client;
        }
    }
}
