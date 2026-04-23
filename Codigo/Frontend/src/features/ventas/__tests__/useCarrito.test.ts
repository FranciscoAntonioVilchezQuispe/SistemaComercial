import { describe, it, expect, beforeEach } from 'vitest'
import { useCarrito } from '../hooks/useCarrito'
import { act } from '@testing-library/react'

describe('useCarrito Store (Zustand)', () => {
  const mockProducto = {
    id: 1,
    nombre: 'Producto 1',
    precioVentaPublico: 100,
    idTipoAfectacionIgv: 1, // Gravado
    activo: true
  }

  beforeEach(() => {
    act(() => {
      useCarrito.getState().limpiarCarrito()
    })
  })

  it('agregarProducto_CuandoElCarritoEstaVacio_AgregaNuevoItem', () => {
    act(() => {
      useCarrito.getState().agregarProducto(mockProducto as any, 2)
    })

    const estado = useCarrito.getState()
    expect(estado.items).toHaveLength(1)
    expect(estado.items[0].cantidad).toBe(2)
    expect(estado.total).toBe(200)
    expect(estado.igv).toBe(30.51) // 200 / 1.18 = 169.49 base. 200 - 169.49 = 30.51
  })

  it('agregarProducto_CuandoYaExiste_SumaLaCantidad', () => {
    act(() => {
      useCarrito.getState().agregarProducto(mockProducto as any, 1)
      useCarrito.getState().agregarProducto(mockProducto as any, 2)
    })

    const estado = useCarrito.getState()
    expect(estado.items).toHaveLength(1)
    expect(estado.items[0].cantidad).toBe(3)
    expect(estado.total).toBe(300)
  })

  it('actualizarCantidad_ConValorValido_ActualizaTotales', () => {
    act(() => {
      useCarrito.getState().agregarProducto(mockProducto as any, 1)
      useCarrito.getState().actualizarCantidad(1, 5)
    })

    const estado = useCarrito.getState()
    expect(estado.items[0].cantidad).toBe(5)
    expect(estado.total).toBe(500)
  })

  it('eliminarProducto_AlLlamar_RemueveItemDelCarrito', () => {
    act(() => {
      useCarrito.getState().agregarProducto(mockProducto as any, 1)
      useCarrito.getState().eliminarProducto(1)
    })

    const estado = useCarrito.getState()
    expect(estado.items).toHaveLength(0)
    expect(estado.total).toBe(0)
  })

  it('limpiarCarrito_AlLlamar_ReseteaTodoAero', () => {
    act(() => {
      useCarrito.getState().agregarProducto(mockProducto as any, 1)
      useCarrito.getState().limpiarCarrito()
    })

    const estado = useCarrito.getState()
    expect(estado.items).toHaveLength(0)
    expect(estado.total).toBe(0)
  })
})
