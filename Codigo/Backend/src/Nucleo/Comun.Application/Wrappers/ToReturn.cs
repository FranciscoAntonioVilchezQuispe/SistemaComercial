using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using FluentValidation.Results;

namespace Nucleo.Comun.Application.Wrappers
{
    public interface IToReturn<T>
    {
        T Data { get; }
        int Status { get; }
        string TransactionId { get; }
        string Message { get; }
    }

    public class ToReturn<T> : IToReturn<T>
    {
        public ToReturn(T value) : this() => Data = value;

        public ToReturn()
        {
        }

        [JsonPropertyName("data")]
        public T Data { get; init; }

        [JsonPropertyName("status")]
        public int Status => 200;

        [JsonPropertyName("transactionId")]
        public string TransactionId => DateTime.Now.ToString("yyyyMMddHHmmssFFF");

        [JsonPropertyName("message")]
        public string Message => "";
    }

    public class ToReturnError<T> : IToReturn<T>
    {
        public ToReturnError(string value = "", int codestatus = 500) : this() => (Message, Status) = (value, codestatus);
        public ToReturnError()
        {
        }

        [JsonPropertyName("data")]
        public T Data { get; }

        [JsonPropertyName("status")]
        public int Status { get; }

        [JsonPropertyName("transactionId")]
        public string TransactionId => DateTime.Now.ToString("yyyyMMddHHmmssFFF");

        [JsonPropertyName("message")]
        public string Message { get; }
    }

    public class ToReturnNoEncontrado<T> : IToReturn<T>
    {
        public ToReturnNoEncontrado(string value = "Datos No encontrados", int codestatus = 404) : this() => (Message, Status) = (value, codestatus);
        public ToReturnNoEncontrado()
        {
        }

        [JsonPropertyName("data")]
        public T Data { get; }

        [JsonPropertyName("status")]
        public int Status { get; }

        [JsonPropertyName("transactionId")]
        public string TransactionId => DateTime.Now.ToString("yyyyMMddHHmmssFFF");

        [JsonPropertyName("message")]
        public string Message { get; }
    }

    public class ToReturnValidation<T> : IToReturn<T>
    {
        public ToReturnValidation(ValidationResult value, int codestatus = 412) : this() => (Message, Status) = (
            string.Join(Environment.NewLine, value.Errors.Select(x => $"- {x.ErrorMessage}.").ToList())
            , codestatus);
        public ToReturnValidation(string value, int codestatus = 412) : this() => (Message, Status) = (value, codestatus);

        public ToReturnValidation()
        {
        }

        [JsonPropertyName("data")]
        public T Data { get; }

        [JsonPropertyName("status")]
        public int Status { get; }

        [JsonPropertyName("transactionId")]
        public string TransactionId => DateTime.Now.ToString("yyyyMMddHHmmssFFF");

        [JsonPropertyName("message")]
        public string Message { get; }
    }

    public interface IToReturnList<T>
    {
        IEnumerable<T> Data { get; }
        int Status { get; }
        string Message { get; }
        string TransactionId { get; }
        int Total { get; }
    }

    public class ToReturnList<T> : IToReturnList<T>
    {
        public ToReturnList(IEnumerable<T> value) : this()
        {
            var list = value?.ToList() ?? new List<T>();
            Data = list;
            Total = list.Count;
        }

        public ToReturnList(IEnumerable<T> value, int total) : this()
        {
            Data = value;
            Total = total;
        }

        public ToReturnList()
        {
        }

        [JsonPropertyName("datos")]
        public IEnumerable<T> Data { get; init; }

        [JsonPropertyName("total")]
        public int Total { get; init; }

        [JsonPropertyName("status")]
        public int Status => 200;

        [JsonPropertyName("transactionId")]
        public string TransactionId => DateTime.Now.ToString("yyyyMMddHHmmssFFF");

        [JsonPropertyName("message")]
        public string Message => "";
    }

    public class ToReturnNoEncontradoList<T> : IToReturnList<T>
    {
        public ToReturnNoEncontradoList(string value = "", int codestatus = 404) : this() => (Message, Status) = (value, codestatus);
        public ToReturnNoEncontradoList()
        {
        }

        [JsonPropertyName("datos")]
        public IEnumerable<T> Data { get; }

        [JsonPropertyName("total")]
        public int Total => 0;

        [JsonPropertyName("status")]
        public int Status { get; }

        [JsonPropertyName("transactionId")]
        public string TransactionId => DateTime.Now.ToString("yyyyMMddHHmmssFFF");

        [JsonPropertyName("message")]
        public string Message { get; }
    }

    public class ToReturnErrorList<T> : IToReturnList<T>
    {
        public ToReturnErrorList(string value = "", int codestatus = 500) : this() => (Message, Status) = (value, codestatus);
        public ToReturnErrorList()
        {
        }

        [JsonPropertyName("datos")]
        public IEnumerable<T> Data { get; }

        [JsonPropertyName("total")]
        public int Total => 0;

        [JsonPropertyName("status")]
        public int Status { get; }

        [JsonPropertyName("transactionId")]
        public string TransactionId => DateTime.Now.ToString("yyyyMMddHHmmssFFF");

        [JsonPropertyName("message")]
        public string Message { get; }
    }
}
