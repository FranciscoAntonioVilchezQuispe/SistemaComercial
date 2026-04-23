import { describe, it, expect } from 'vitest'
import { formatMoneda, parsearMoneda, formatearPorcentaje } from '../moneda'

describe('Utilidades de Moneda', () => {
  describe('formatMoneda', () => {
    it('formatMoneda_ConValorEntero_DevuelveFormatoPEN', () => {
      // Usamos regex para permitir diferentes tipos de espacios (espacio normal vs espacio no rompible)
      expect(formatMoneda(100)).toMatch(/S\/ 100\.00/)
    })

    it('formatMoneda_ConValorDecimal_DevuelveConDosDecimales', () => {
      expect(formatMoneda(1234.56)).toMatch(/S\/ 1,234\.56/)
    })

    it('formatMoneda_ConCero_DevuelveCero', () => {
      expect(formatMoneda(0)).toMatch(/S\/ 0\.00/)
    })
    
    it('formatMoneda_ConNulo_DevuelveCero', () => {
      expect(formatMoneda(null)).toMatch(/S\/ 0\.00/)
    })
  })

  describe('parsearMoneda', () => {
    it('parsearMoneda_ConStringFormateado_DevuelveNumero', () => {
      expect(parsearMoneda('S/ 1,234.56')).toBe(1234.56)
    })

    it('parsearMoneda_ConStringSimple_DevuelveNumero', () => {
      expect(parsearMoneda('100')).toBe(100)
    })
  })

  describe('formatearPorcentaje', () => {
    it('formatearPorcentaje_Con18_DevuelveString18pct', () => {
      expect(formatearPorcentaje(18)).toBe('18.00%')
    })
  })
})
