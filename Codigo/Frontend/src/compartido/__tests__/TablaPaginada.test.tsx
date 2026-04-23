import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import { TablaPaginada } from '../componentes/tablas/TablaPaginada'
import React from 'react'

describe('TablaPaginada Component', () => {
  const columnas = [
    { clave: 'id', titulo: 'ID' },
    { clave: 'nombre', titulo: 'Nombre' }
  ]

  const datos = [
    { id: 1, nombre: 'Item 1' },
    { id: 2, nombre: 'Item 2' }
  ]

  it('TablaPaginada_ConDatos_RenderizaFilasYColumnas', () => {
    // Act
    render(
      <TablaPaginada 
        datos={datos} 
        columnas={columnas} 
      />
    )

    // Assert
    expect(screen.getByText('Item 1')).toBeDefined()
    expect(screen.getByText('Item 2')).toBeDefined()
    expect(screen.getByText('Nombre')).toBeDefined()
  })

  it('TablaPaginada_EnEstadoCargando_MuestraLoading', () => {
    // Act
    render(
      <TablaPaginada 
        datos={[]} 
        columnas={columnas} 
        cargando={true}
      />
    )

    // Assert
    expect(screen.getByText(/Cargando/i)).toBeDefined()
  })

  it('TablaPaginada_SinDatos_MuestraEstadoVacio', () => {
    // Act
    render(
      <TablaPaginada 
        datos={[]} 
        columnas={columnas} 
      />
    )

    // Assert
    expect(screen.getByText(/No hay datos disponibles/i)).toBeDefined()
  })
})
