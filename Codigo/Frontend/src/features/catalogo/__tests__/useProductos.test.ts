import { describe, it, expect, beforeEach } from 'vitest'
import { waitFor, act } from '@testing-library/react'
import { useProductos, useProducto, useCrearProducto } from '../hooks/useProductos'
import { server, API_BASE } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'

describe('useProductos Hook', () => {
  const mockProducto = {
    id: 1,
    codigo: 'P001',
    nombre: 'Producto Test',
    precioVentaPublico: 100,
    stock: 10,
    activo: true
  }

  it('useProductos_ConRespuestaExitosa_DevuelveListaDeDatos', async () => {
    // Arrange
    server.use(
      http.get(`${API_BASE}/productos`, () => {
        return HttpResponse.json({
          datos: [mockProducto],
          total: 1,
          pageNumber: 1,
          pageSize: 10
        })
      })
    )

    // Act
    const { result } = renderHookConProveedores(() => useProductos())

    // Assert
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data?.datos).toHaveLength(1)
    expect(result.current.data?.datos[0].nombre).toBe('Producto Test')
  })

  it('useProductos_ConError500_DevuelveEstadoError', async () => {
    // Arrange
    server.use(
      http.get(`${API_BASE}/productos`, () => {
        return new HttpResponse(null, { status: 500 })
      })
    )

    // Act
    const { result } = renderHookConProveedores(() => useProductos())

    // Assert
    await waitFor(() => expect(result.current.isError).toBe(true))
  })

  it('useProducto_ConIdValido_DevuelveDetalleDelProducto', async () => {
    // Arrange
    server.use(
      http.get(`${API_BASE}/productos/1`, () => {
        return HttpResponse.json({ data: mockProducto })
      })
    )

    // Act
    const { result } = renderHookConProveedores(() => useProducto(1))

    // Assert
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data?.id).toBe(1)
  })

  it('useCrearProducto_ConDatosValidos_LlamaAlEndpointPost', async () => {
    // Arrange
    server.use(
      http.post(`${API_BASE}/productos`, () => {
        return HttpResponse.json({ data: { ...mockProducto, id: 99 } })
      })
    )

    const { result } = renderHookConProveedores(() => useCrearProducto())

    // Act
    act(() => {
      result.current.mutate({ nombre: 'Nuevo', codigo: 'N001' } as any)
    })

    // Assert
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data?.id).toBe(99)
  })
})
