using Yarp.ReverseProxy.Transforms;
using Nucleo.Comun.API.Extensions;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add YARP
builder.Services.AddReverseProxy()
    .LoadFromConfig(builder.Configuration.GetSection("ReverseProxy"))
    .AddTransforms(builderContext =>
    {
        builderContext.AddResponseTransform(transformContext =>
        {
            if (transformContext.ProxyResponse != null)
            {
                transformContext.ProxyResponse.Headers.Remove("Access-Control-Allow-Origin");
                transformContext.ProxyResponse.Headers.Remove("Access-Control-Allow-Credentials");
                transformContext.ProxyResponse.Headers.Remove("Access-Control-Allow-Methods");
                transformContext.ProxyResponse.Headers.Remove("Access-Control-Allow-Headers");
            }
            return ValueTask.CompletedTask;
        });
    });

// Add Global CORS
// Add Global CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.SetIsOriginAllowed(_ => true) // Allow any origin
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseManejoExcepcionesGlobal();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// Use Global CORS
app.UseCors("AllowFrontend");

app.UseAuthorization();

// Map YARP
app.MapReverseProxy();

app.MapGet("/", () => "API Gateway Running");

app.Run();
