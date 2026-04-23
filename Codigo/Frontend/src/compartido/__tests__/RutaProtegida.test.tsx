import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen } from '@testing-library/react'
import { RutaProtegida } from '../componentes/seguridad/RutaProtegida'
import { useAuth } from '@/features/identidad/context/AuthContext'
import { MemoryRouter, Routes, Route } from 'react-router-dom'
import React from 'react'

// Mock de useAuth
vi.mock('@/features/identidad/context/AuthContext', () => ({
  useAuth: vi.fn()
}))

describe('RutaProtegida Component', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  const ContenidoPrivado = () => <div>Contenido Privado</div>
  const Login = () => <div>Pagina Login</div>

  it('RutaProtegida_CuandoNoEstaAutenticado_RedirigeALogin', () => {
    // Arrange
    vi.mocked(useAuth).mockReturnValue({
      estaAutenticado: false,
      roles: [],
      permisos: [],
      cargando: false,
      usuario: null,
      loginInfo: () => {},
      logout: () => {}
    })

    // Act
    render(
      <MemoryRouter initialEntries={['/privado']}>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route path="/privado" element={
            <RutaProtegida>
              <ContenidoPrivado />
            </RutaProtegida>
          } />
        </Routes>
      </MemoryRouter>
    )

    // Assert
    expect(screen.getByText('Pagina Login')).toBeDefined()
    expect(screen.queryByText('Contenido Privado')).toBeNull()
  })

  it('RutaProtegida_CuandoEstaAutenticado_MuestraContenido', () => {
    // Arrange
    vi.mocked(useAuth).mockReturnValue({
      estaAutenticado: true,
      roles: ['USUARIO'],
      permisos: [],
      cargando: false,
      usuario: { username: 'test' } as any,
      loginInfo: () => {},
      logout: () => {}
    })

    // Act
    render(
      <MemoryRouter initialEntries={['/privado']}>
        <Routes>
          <Route path="/privado" element={
            <RutaProtegida>
              <ContenidoPrivado />
            </RutaProtegida>
          } />
        </Routes>
      </MemoryRouter>
    )

    // Assert
    expect(screen.getByText('Contenido Privado')).toBeDefined()
  })

  it('RutaProtegida_CuandoFaltaPermiso_NoMuestraContenido', () => {
     // Arrange
     vi.mocked(useAuth).mockReturnValue({
      estaAutenticado: true,
      roles: ['USUARIO'],
      permisos: ['OTROS:VER'],
      cargando: false,
      usuario: { username: 'test' } as any,
      loginInfo: () => {},
      logout: () => {}
    })

    // Act
    render(
      <MemoryRouter initialEntries={['/privado']}>
        <Routes>
          <Route path="/privado" element={
            <RutaProtegida codigoPermiso="VENTAS">
              <ContenidoPrivado />
            </RutaProtegida>
          } />
        </Routes>
      </MemoryRouter>
    )

    // Assert
    expect(screen.queryByText('Contenido Privado')).toBeNull()
  })
})
