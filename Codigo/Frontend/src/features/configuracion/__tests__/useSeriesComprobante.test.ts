import { describe, it, expect } from 'vitest'
import { waitFor } from '@testing-library/react'
import { useSeriesComprobante } from '../hooks/useSeriesComprobante'
import { server, API_BASE } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'

describe('useSeriesComprobante Hook', () => {
  const mockSerie = {
    id: 1,
    idTipoComprobante: 1,
    serie: 'F001',
    correlativoSiguiente: 1,
    activo: true
  }

  it('useSeriesComprobante_ConRespuestaExitosa_DevuelveLista', async () => {
    // Arrange
    server.use(
      http.get(`${API_BASE}/series`, () => {
        return HttpResponse.json({
          datos: [mockSerie],
          total: 1
        })
      })
    )

    // Act
    const { result } = renderHookConProveedores(() => useSeriesComprobante())

    // Assert
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data?.datos).toHaveLength(1)
    expect(result.current.data?.datos[0].serie).toBe('F001')
  })
})
