import { describe, it, expect, vi, beforeEach } from 'vitest'
import { renderHook } from '@testing-library/react'
import { usePermiso, useEsAdmin } from '../hooks/usePermiso'
import { useAuth } from '@/features/identidad/context/AuthContext'

// Mock de useAuth
vi.mock('@/features/identidad/context/AuthContext', () => ({
  useAuth: vi.fn()
}))

describe('usePermiso Hook', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('usePermiso_CuandoUsuarioTienePermisoExacto_DevuelveTrue', () => {
    // Arrange
    vi.mocked(useAuth).mockReturnValue({
      permisos: ['VENTAS:VER'],
      roles: [],
      usuario: null,
      estaAutenticado: true,
      loginInfo: () => {},
      logout: () => {},
      cargando: false
    })

    // Act
    const { result } = renderHook(() => usePermiso('VENTAS', 'VER'))

    // Assert
    expect(result.current).toBe(true)
  })

  it('usePermiso_CuandoUsuarioNoTienePermiso_DevuelveFalse', () => {
    // Arrange
    vi.mocked(useAuth).mockReturnValue({
      permisos: ['PRODUCTOS:VER'],
      roles: [],
      usuario: null,
      estaAutenticado: true,
      loginInfo: () => {},
      logout: () => {},
      cargando: false
    })

    // Act
    const { result } = renderHook(() => usePermiso('VENTAS', 'VER'))

    // Assert
    expect(result.current).toBe(false)
  })

  it('useEsAdmin_CuandoUsuarioEsAdmin_DevuelveTrue', () => {
    // Arrange
    vi.mocked(useAuth).mockReturnValue({
      roles: ['ADMINISTRADOR'],
      permisos: [],
      usuario: null,
      estaAutenticado: true,
      loginInfo: () => {},
      logout: () => {},
      cargando: false
    })

    // Act
    const { result } = renderHook(() => useEsAdmin())

    // Assert
    expect(result.current).toBe(true)
  })
})
