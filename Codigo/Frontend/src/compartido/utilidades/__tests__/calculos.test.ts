import { describe, it, expect } from 'vitest'
import { 
  calcularIGV, 
  calcularSubtotalDesdeTotal, 
  calcularSubtotal, 
  calcularTotalesVenta 
} from '../calculos'

describe('Utilidades de Cálculos', () => {
  describe('calcularIGV', () => {
    it('calcularIGV_ConMonto100_Devuelve18', () => {
      expect(calcularIGV(100)).toBe(18)
    })

    it('calcularIGV_ConMonto0_Devuelve0', () => {
      expect(calcularIGV(0)).toBe(0)
    })
  })

  describe('calcularSubtotalDesdeTotal', () => {
    it('calcularSubtotalDesdeTotal_ConTotal118_Devuelve100', () => {
      expect(calcularSubtotalDesdeTotal(118)).toBeCloseTo(100)
    })
  })

  describe('calcularSubtotal', () => {
    it('calcularSubtotal_SinDescuento_EsPrecioXCantidad', () => {
      expect(calcularSubtotal(10, 5)).toBe(50)
    })

    it('calcularSubtotal_ConDescuento10pct_ReduceElTotal', () => {
      expect(calcularSubtotal(100, 1, 10)).toBe(90)
    })
  })

  describe('calcularTotalesVenta', () => {
    it('calcularTotalesVenta_ConItemGravado_CalculaIGV', () => {
      const items = [{ precio: 118, cantidad: 1, codigoAfectacion: '10' }]
      const totales = calcularTotalesVenta(items)
      
      expect(totales.total).toBe(118)
      expect(totales.igv).toBe(18)
      expect(totales.subtotalGravado).toBe(100)
    })

    it('calcularTotalesVenta_ConItemExonerado_NoCalculaIGV', () => {
      const items = [{ precio: 100, cantidad: 1, codigoAfectacion: '20' }]
      const totales = calcularTotalesVenta(items)
      
      expect(totales.total).toBe(100)
      expect(totales.igv).toBe(0)
      expect(totales.subtotalExonerado).toBe(100)
    })

    it('calcularTotalesVenta_ConItemGratuito_VaATotalGratuito', () => {
      const items = [{ precio: 100, cantidad: 1, codigoAfectacion: '15' }]
      const totales = calcularTotalesVenta(items)
      
      expect(totales.total).toBe(0)
      expect(totales.totalGratuito).toBe(100)
    })

    it('calcularTotalesVenta_ConMultiplesItems_SumaTotalesCorrectamente', () => {
      const items = [
        { precio: 118, cantidad: 1, codigoAfectacion: '10' }, // Gravado 118 (100 + 18 IGV)
        { precio: 50, cantidad: 1, codigoAfectacion: '20' }   // Exonerado 50
      ]
      const totales = calcularTotalesVenta(items)
      
      expect(totales.total).toBe(168)
      expect(totales.igv).toBe(18)
      expect(totales.subtotalGravado).toBe(100)
      expect(totales.subtotalExonerado).toBe(50)
    })

    it('calcularTotalesVenta_ConDescuento_ReduceElTotal', () => {
      const items = [
        { precio: 100, cantidad: 1, porcentajeDescuento: 10, codigoAfectacion: '10' }
      ]
      const totales = calcularTotalesVenta(items)
      
      // 100 - 10% = 90 total. 
      // 90 / 1.18 = 76.27 base
      // 90 - 76.27 = 13.73 igv
      expect(totales.total).toBe(90)
      expect(totales.igv).toBeCloseTo(13.73)
      expect(totales.subtotalGravado).toBeCloseTo(76.27)
    })

    it('calcularTotalesVenta_ConListaVacia_DevuelveTodosEnCero', () => {
      const totales = calcularTotalesVenta([])
      expect(totales.total).toBe(0)
      expect(totales.igv).toBe(0)
    })
  })
})
