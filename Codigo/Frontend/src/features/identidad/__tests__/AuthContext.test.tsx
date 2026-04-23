import { describe, it, expect, beforeEach, vi } from 'vitest'
import { renderHook, act, waitFor } from '@testing-library/react'
import { AuthProvider, useAuth } from '../context/AuthContext'
import { authService } from '../servicios/authService'
import React from 'react'

// Mock de jwt-decode
vi.mock('jwt-decode', () => ({
  jwtDecode: vi.fn()
}))

import { jwtDecode } from 'jwt-decode'

describe('AuthContext', () => {
  beforeEach(() => {
    localStorage.clear()
    vi.clearAllMocks()
  })

  const wrapper = ({ children }: { children: React.ReactNode }) => (
    <AuthProvider>{children}</AuthProvider>
  )

  it('useAuth_InicialmenteSinToken_EstaNoAutenticado', async () => {
    // Act
    const { result } = renderHook(() => useAuth(), { wrapper })

    // Assert
    expect(result.current.estaAutenticado).toBe(false)
    expect(result.current.usuario).toBeNull()
    expect(result.current.cargando).toBe(false)
  })

  it('useAuth_ConTokenValido_DecodificaRolesCorrectamente', async () => {
    // Arrange
    const mockToken = 'valido'
    localStorage.setItem('sc_token', mockToken)

    const mockDecoded = {
      exp: (Date.now() / 1000) + 3600,
      roles: ['ADMINISTRADOR'],
      permisos: ['VENTAS:VER'],
      nameid: '1',
      unique_name: 'admin',
      given_name: 'Admin',
      family_name: 'System',
      email: 'admin@test.com'
    }
    
    vi.mocked(jwtDecode).mockReturnValue(mockDecoded)

    // Act
    const { result } = renderHook(() => useAuth(), { wrapper })

    // Assert
    await waitFor(() => {
      expect(result.current.estaAutenticado).toBe(true)
      expect(result.current.roles).toContain('ADMINISTRADOR')
      expect(result.current.permisos).toContain('VENTAS:VER')
      expect(result.current.usuario?.username).toBe('admin')
    })
  })

  it('logout_AlLlamar_LimpiaEstadoDeAutenticacion', async () => {
    // Arrange
    const mockToken = 'valido'
    localStorage.setItem('sc_token', mockToken)

    vi.mocked(jwtDecode).mockReturnValue({
      exp: (Date.now() / 1000) + 3600,
      roles: []
    })

    const { result } = renderHook(() => useAuth(), { wrapper })

    // Act
    await act(async () => {
      result.current.logout()
    })

    // Assert
    expect(result.current.estaAutenticado).toBe(false)
    expect(result.current.usuario).toBeNull()
    expect(localStorage.getItem('sc_token')).toBeNull()
  })

  it('useAuth_ConTokenExpirado_NoAutenticaAlUsuario', async () => {
    // Arrange
    const mockToken = 'expirado'
    localStorage.setItem('sc_token', mockToken)

    const mockDecoded = {
      exp: (Date.now() / 1000) - 3600, // Hace una hora
      roles: ['ADMINISTRADOR']
    }
    
    vi.mocked(jwtDecode).mockReturnValue(mockDecoded)
    const logoutSpy = vi.spyOn(authService, 'logout')

    // Act
    const { result } = renderHook(() => useAuth(), { wrapper })

    // Assert
    expect(result.current.estaAutenticado).toBe(false)
    expect(logoutSpy).toHaveBeenCalled()
  })
})
