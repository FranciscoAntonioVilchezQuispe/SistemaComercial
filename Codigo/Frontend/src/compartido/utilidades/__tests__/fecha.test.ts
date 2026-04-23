import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'
import { formatFecha, formatearFechaHora, quedenMenosDe24Horas } from '../fecha'
import { subHours, subDays } from 'date-fns'

describe('Utilidades de Fecha', () => {
  describe('formatFecha', () => {
    it('formatFecha_ConFechaValida_DevuelveString', () => {
      const fecha = new Date(2024, 0, 1) // 1 de enero de 2024
      expect(formatFecha(fecha)).toBe('01/01/2024')
    })

    it('formatFecha_ConFechaISO_ContieneAnio', () => {
      expect(formatFecha('2024-05-20T10:00:00Z')).toBe('20/05/2024')
    })
  })

  describe('formatearFechaHora', () => {
    it('formatearFechaHora_ConFecha_ContieneHoraYMinutos', () => {
      const fecha = new Date(2024, 0, 1, 15, 30)
      expect(formatearFechaHora(fecha)).toBe('01/01/2024 15:30')
    })
  })

  describe('quedenMenosDe24Horas', () => {
    beforeEach(() => {
      vi.useFakeTimers()
      vi.setSystemTime(new Date(2024, 0, 10, 12, 0, 0)) // 10 de enero, 12:00
    })

    afterEach(() => {
      vi.useRealTimers()
    })

    it('quedenMenosDe24Horas_ConFechaReciente_DevuelveTrue', () => {
      const fechaReciente = subHours(new Date(), 1) // hace 1 hora
      expect(quedenMenosDe24Horas(fechaReciente)).toBe(true)
    })

    it('quedenMenosDe24Horas_ConFechaAnterior_DevuelveFalse', () => {
      const fechaAntigua = subDays(new Date(), 2) // hace 2 días
      expect(quedenMenosDe24Horas(fechaAntigua)).toBe(false)
    })

    it('quedenMenosDe24Horas_ConFechaExacta25h_DevuelveFalse', () => {
      const fecha25h = subHours(new Date(), 25)
      expect(quedenMenosDe24Horas(fecha25h)).toBe(false)
    })
  })
})
