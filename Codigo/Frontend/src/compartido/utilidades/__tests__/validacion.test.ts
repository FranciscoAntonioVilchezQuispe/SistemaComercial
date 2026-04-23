import { describe, it, expect } from 'vitest'
import { validarRUC, validarDNI, validarEmail, validarTelefono } from '../validacion'

describe('Utilidades de Validación', () => {
  describe('validarRUC', () => {
    it('validarRUC_ConRUCValido11Digitos_DevuelveTrue', () => {
      expect(validarRUC('20123456789')).toBe(true)
      expect(validarRUC('10123456789')).toBe(true)
    })

    it('validarRUC_Con10Digitos_DevuelveFalse', () => {
      expect(validarRUC('2012345678')).toBe(false)
    })

    it('validarRUC_ConLetras_DevuelveFalse', () => {
      expect(validarRUC('2012345678A')).toBe(false)
    })

    it('validarRUC_QueComienzaConCero_DevuelveFalse', () => {
      expect(validarRUC('00123456789')).toBe(false)
    })
  })

  describe('validarDNI', () => {
    it('validarDNI_ConDNI8Digitos_DevuelveTrue', () => {
      expect(validarDNI('12345678')).toBe(true)
    })

    it('validarDNI_Con7Digitos_DevuelveFalse', () => {
      expect(validarDNI('1234567')).toBe(false)
    })

    it('validarDNI_Con9Digitos_DevuelveFalse', () => {
      expect(validarDNI('123456789')).toBe(false)
    })
  })

  describe('validarEmail', () => {
    it('validarEmail_ConEmailValido_DevuelveTrue', () => {
      expect(validarEmail('test@example.com')).toBe(true)
    })

    it('validarEmail_SinArroba_DevuelveFalse', () => {
      expect(validarEmail('testexample.com')).toBe(false)
    })
  })

  describe('validarTelefono', () => {
    it('validarTelefono_ConCelularPeruano_DevuelveTrue', () => {
      expect(validarTelefono('912345678')).toBe(true)
    })

    it('validarTelefono_ConFijoLima_DevuelveTrue', () => {
      expect(validarTelefono('1234567')).toBe(true)
    })

    it('validarTelefono_ConStringVacio_DevuelveFalse', () => {
      expect(validarTelefono('')).toBe(false)
    })
  })
})
