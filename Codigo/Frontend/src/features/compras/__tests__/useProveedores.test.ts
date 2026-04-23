import { describe, it, expect } from 'vitest'
import { waitFor } from '@testing-library/react'
import { useProveedores } from '../proveedores/hooks/useProveedores'
import { server, API_BASE } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'

describe('useProveedores Hook', () => {
  const mockProveedor = {
    id: 1,
    numeroDocumento: '20123456789',
    razonSocial: 'Proveedor Test',
    activo: true
  }

  it('useProveedores_ConRespuestaExitosa_DevuelveLista', async () => {
    // Arrange
    server.use(
      http.get(`${API_BASE}/proveedores`, () => {
        return HttpResponse.json({
          datos: [mockProveedor],
          total: 1
        })
      })
    )

    // Act
    const { result } = renderHookConProveedores(() => useProveedores())

    // Assert
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data?.datos).toHaveLength(1)
    expect(result.current.data?.datos[0].razonSocial).toBe('Proveedor Test')
  })
})
