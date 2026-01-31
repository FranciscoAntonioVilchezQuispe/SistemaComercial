using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Configuracion.API.Endpoints
{
    public static class EmpresaEndpoints
    {
        public static void MapEmpresaEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/empresa").WithTags("Empresa");

            grupo.MapGet("/", async (IEmpresaRepositorio repo) =>
            {
                var empresa = await repo.ObtenerActualAsync();
                if (empresa == null) return Results.NotFound(new ToReturnError<Empresa>("Empresa no configurada", 404));
                return Results.Ok(new ToReturn<Empresa>(empresa));
            });

            grupo.MapPut("/", async (EmpresaDto dto, IEmpresaRepositorio repo) =>
            {
                var empresa = await repo.ObtenerActualAsync();
                if (empresa == null) return Results.NotFound(new ToReturnError<Empresa>("Empresa no configurada", 404));

                empresa.Ruc = dto.Ruc;
                empresa.RazonSocial = dto.RazonSocial;
                empresa.NombreComercial = dto.NombreComercial;
                empresa.DireccionFiscal = dto.DireccionFiscal;
                empresa.Telefono = dto.Telefono;
                empresa.CorreoContacto = dto.CorreoContacto;
                empresa.SitioWeb = dto.SitioWeb;
                empresa.LogoUrl = dto.LogoUrl;
                empresa.MonedaPrincipal = dto.MonedaPrincipal;
                empresa.UsuarioActualizacion = "SISTEMA";
                empresa.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(empresa);
                return Results.Ok(new ToReturn<Empresa>(empresa));
            });
        }
    }
}
