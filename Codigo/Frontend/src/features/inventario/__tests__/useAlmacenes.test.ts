import { describe, it, expect } from 'vitest'
import { waitFor } from '@testing-library/react'
import { useAlmacenes } from '../almacenes/hooks/useAlmacenes'
import { server, API_BASE } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'

describe('useAlmacenes Hook', () => {
  const mockAlmacen = {
    id: 1,
    nombre: 'Almacén Central',
    direccion: 'Av. Test 123',
    activo: true
  }

  it('useAlmacenes_ConRespuestaExitosa_DevuelveLista', async () => {
    // Arrange
    server.use(
      http.get(`${API_BASE}/inventario/almacenes`, ({ request }) => {
        return HttpResponse.json({
          datos: [mockAlmacen],
          total: 1
        })
      })
    )

    // Act
    const { result } = renderHookConProveedores(() => useAlmacenes())

    // Assert
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data?.datos).toHaveLength(1)
    expect(result.current.data?.datos[0].nombre).toBe('Almacén Central')
  })
})
