import { describe, it, expect } from 'vitest'
import { waitFor, act } from '@testing-library/react'
import { useVentas, useCrearVenta } from '../hooks/useVentas'
import { server, API_BASE } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'

describe('useVentas Hook', () => {
  const mockVenta = {
    id: 1,
    serie: 'F001',
    correlativo: 123,
    total: 118,
    clienteRazonSocial: 'Cliente 1',
    fechaEmision: '2024-05-20'
  }

  it('useVentas_ConRespuestaExitosa_DevuelveLista', async () => {
    // Arrange
    server.use(
      http.get(`${API_BASE}/ventas`, () => {
        return HttpResponse.json({
          datos: [mockVenta],
          total: 1
        })
      })
    )

    // Act
    const { result } = renderHookConProveedores(() => useVentas())

    // Assert
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data?.datos).toHaveLength(1)
    expect(result.current.data?.datos[0].serie).toBe('F001')
  })

  it('useCrearVenta_ConDatosValidos_RegistraVenta', async () => {
    // Arrange
    server.use(
      http.post(`${API_BASE}/ventas`, () => {
        return HttpResponse.json({ data: { ...mockVenta, id: 999 } })
      })
    )

    const { result } = renderHookConProveedores(() => useCrearVenta())

    // Act
    act(() => {
      result.current.mutate({ 
        idCliente: 1, 
        items: [], 
        idTipoComprobante: 1 
      } as any)
    })

    // Assert
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data?.id).toBe(999)
  })
})
