using System;

namespace Nucleo.Comun.Domain
{
    // Clase de error personalizada basada en el estándar global de GEMINI.md
    public class AppException : Exception
    {
        public string Contexto { get; }
        public object? Detalle { get; }

        public AppException(string contexto, string mensaje, object? detalle = null, Exception? inner = null)
            : base(mensaje, inner)
        {
            Contexto = contexto;
            Detalle = detalle;
        }
    }
}
