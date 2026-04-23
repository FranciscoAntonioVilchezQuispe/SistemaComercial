using FluentAssertions;
using FluentValidation;
using FluentValidation.Results;
using MediatR;
using Moq;
using Nucleo.Comun.Application.Comportamientos;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace Nucleo.Tests.Unit.Comportamientos
{
    public class ComportamientoValidacionTests
    {
        public class SampleRequest : IRequest<string> { }

        [Fact]
        public async Task Handle_ConDatosValidos_DebeLlamarAlSiguienteHandler()
        {
            // Arrange
            var request = new SampleRequest();
            bool nextCalled = false;
            RequestHandlerDelegate<string> next = (ct) => 
            { 
                nextCalled = true; 
                return Task.FromResult("Success"); 
            };

            var validator = new Mock<IValidator<SampleRequest>>();
            validator.Setup(x => x.ValidateAsync(It.IsAny<ValidationContext<SampleRequest>>(), It.IsAny<CancellationToken>()))
                .ReturnsAsync(new ValidationResult());

            var validators = new List<IValidator<SampleRequest>> { validator.Object };
            var behavior = new ComportamientoValidacion<SampleRequest, string>(validators);

            // Act
            var result = await behavior.Handle(request, next, CancellationToken.None);

            // Assert
            result.Should().Be("Success");
            nextCalled.Should().BeTrue();
        }

        [Fact]
        public async Task Handle_ConDatosInvalidos_DebeLanzarValidationException()
        {
            // Arrange
            var request = new SampleRequest();
            bool nextCalled = false;
            RequestHandlerDelegate<string> next = (ct) => 
            { 
                nextCalled = true; 
                return Task.FromResult("Success"); 
            };

            var validator = new Mock<IValidator<SampleRequest>>();
            var failure = new ValidationFailure("Prop", "Error message");
            validator.Setup(x => x.ValidateAsync(It.IsAny<ValidationContext<SampleRequest>>(), It.IsAny<CancellationToken>()))
                .ReturnsAsync(new ValidationResult(new[] { failure }));

            var validators = new List<IValidator<SampleRequest>> { validator.Object };
            var behavior = new ComportamientoValidacion<SampleRequest, string>(validators);

            // Act
            Func<Task> act = async () => await behavior.Handle(request, next, CancellationToken.None);

            // Assert
            await act.Should().ThrowAsync<ValidationException>();
            nextCalled.Should().BeFalse();
        }

        [Fact]
        public async Task Handle_ConMultiplesErrores_DebeAcumularTodos()
        {
            // Arrange
            var request = new SampleRequest();
            RequestHandlerDelegate<string> next = (ct) => Task.FromResult("Success");

            var validator1 = new Mock<IValidator<SampleRequest>>();
            validator1.Setup(x => x.ValidateAsync(It.IsAny<ValidationContext<SampleRequest>>(), It.IsAny<CancellationToken>()))
                .ReturnsAsync(new ValidationResult(new[] { new ValidationFailure("P1", "E1") }));

            var validator2 = new Mock<IValidator<SampleRequest>>();
            validator2.Setup(x => x.ValidateAsync(It.IsAny<ValidationContext<SampleRequest>>(), It.IsAny<CancellationToken>()))
                .ReturnsAsync(new ValidationResult(new[] { new ValidationFailure("P2", "E2") }));

            var validators = new List<IValidator<SampleRequest>> { validator1.Object, validator2.Object };
            var behavior = new ComportamientoValidacion<SampleRequest, string>(validators);

            // Act
            Func<Task> act = async () => await behavior.Handle(request, next, CancellationToken.None);

            // Assert
            var ex = await act.Should().ThrowAsync<ValidationException>();
            ex.And.Errors.Should().HaveCount(2);
        }
    }
}
