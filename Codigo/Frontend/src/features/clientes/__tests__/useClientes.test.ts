import { describe, it, expect } from 'vitest'
import { waitFor, act } from '@testing-library/react'
import { useClientes, useCliente, useCrearCliente } from '../hooks/useClientes'
import { server, API_BASE } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'

describe('useClientes Hook', () => {
  const mockCliente = {
    id: 1,
    idTipoDocumento: 1,
    numeroDocumento: '12345678',
    razonSocial: 'Cliente de Prueba',
    activado: true
  }

  it('useClientes_ConRespuestaExitosa_DevuelveListaPaginada', async () => {
    // Arrange
    server.use(
      http.get(`${API_BASE}/clientes`, () => {
        return HttpResponse.json({
          datos: [mockCliente],
          total: 1,
          pageNumber: 1,
          pageSize: 10
        })
      })
    )

    // Act
    const { result } = renderHookConProveedores(() => useClientes())

    // Assert
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data?.datos).toHaveLength(1)
    expect(result.current.data?.datos[0].razonSocial).toBe('Cliente de Prueba')
  })

  it('useCliente_ConIdValido_DevuelveDetalleCompleto', async () => {
    // Arrange
    server.use(
      http.get(`${API_BASE}/clientes/1`, () => {
        return HttpResponse.json({ data: mockCliente })
      })
    )

    // Act
    const { result } = renderHookConProveedores(() => useCliente(1))

    // Assert
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data?.id).toBe(1)
  })

  it('useCrearCliente_ConDniValido_CreaElCliente', async () => {
    // Arrange
    server.use(
      http.post(`${API_BASE}/clientes`, () => {
        return HttpResponse.json({ data: { ...mockCliente, id: 99 } })
      })
    )

    const { result } = renderHookConProveedores(() => useCrearCliente())

    // Act
    act(() => {
      result.current.mutate({ 
        idTipoDocumento: 1, 
        numeroDocumento: '12345678', 
        razonSocial: 'Nuevo Cliente' 
      } as any)
    })

    // Assert
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data?.id).toBe(99)
  })
})
