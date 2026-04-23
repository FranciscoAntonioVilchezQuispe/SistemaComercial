using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Nucleo.Tests.Shared.Helpers
{
    public static class AuthHelper
    {
        private const string SecretKey = "SUPER_SECRET_KEY_PROVISIONAL_1234567890";

        public static string GenerarTokenAdmin(long userId = 1)
        {
            var permisos = new[] { "ventas:crear", "ventas:ver", "compras:ver", "compras:crear", "catalogo:ver" };
            return GenerarToken(userId, "ADMIN", permisos);
        }

        public static string GenerarTokenVendedor(long userId = 2)
        {
            var permisos = new[] { "ventas:crear", "ventas:ver" };
            return GenerarToken(userId, "VENDEDOR", permisos);
        }

        public static string GenerarToken(long userId, string rol, string[] permisos)
        {
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, userId.ToString()),
                new Claim(ClaimTypes.Role, rol),
                new Claim("uid", userId.ToString())
            };

            foreach (var permiso in permisos)
            {
                claims.Add(new Claim("permiso", permiso));
            }

            return CreateToken(claims, DateTime.UtcNow.AddHours(1));
        }

        public static string GenerarTokenExpirado(long userId = 99)
        {
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, userId.ToString()),
                new Claim(ClaimTypes.Role, "ADMIN"),
                new Claim("uid", userId.ToString())
            };

            return CreateToken(claims, DateTime.UtcNow.AddHours(-1));
        }

        private static string CreateToken(IEnumerable<Claim> claims, DateTime expires)
        {
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(SecretKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: "SistemaComercial",
                audience: "SistemaComercialAPI",
                claims: claims,
                expires: expires,
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
