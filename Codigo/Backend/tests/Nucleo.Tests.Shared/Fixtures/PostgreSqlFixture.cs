using System.Threading.Tasks;
using Testcontainers.PostgreSql;
using Xunit;

namespace Nucleo.Tests.Shared.Fixtures
{
    public class PostgreSqlFixture : IAsyncLifetime
    {
        private readonly PostgreSqlContainer _container;

        public PostgreSqlFixture()
        {
            _container = new PostgreSqlBuilder()
                .WithImage("postgres:15-alpine")
                .WithDatabase("sistema_comercial_test")
                .WithUsername("postgres")
                .WithPassword("test123")
                .Build();
        }

        public string ConnectionString => _container.GetConnectionString();

        public async Task InitializeAsync()
        {
            await _container.StartAsync();
        }

        public async Task DisposeAsync()
        {
            await _container.StopAsync();
        }
    }
}
