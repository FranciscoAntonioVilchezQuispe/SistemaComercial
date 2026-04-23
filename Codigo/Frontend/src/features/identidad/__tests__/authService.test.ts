import { describe, it, expect, beforeEach, vi } from 'vitest'
import { authService } from '../servicios/authService'
import { server, API_BASE } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'

describe('authService', () => {
  beforeEach(() => {
    localStorage.clear()
    vi.clearAllMocks()
  })

  it('login_ConCredencialesValidas_GuardaTokenEnLocalStorage', async () => {
    // Arrange
    const comando = { username: 'admin', password: 'password' }
    
    // Act
    const resultado = await authService.login(comando)

    // Assert
    expect(resultado.token).toBe('token-test')
    expect(localStorage.getItem('sc_token')).toBe('token-test')
    expect(localStorage.getItem('sc_refresh')).toBe('refresh-test')
  })

  it('login_ConCredencialesInvalidas_LanzaError', async () => {
    // Arrange
    server.use(
      http.post(`${API_BASE}/auth/login`, () => {
        return new HttpResponse(null, { status: 401 })
      })
    )

    // Act & Assert
    await expect(authService.login({ username: 'bad', password: 'bad' }))
      .rejects.toThrow()
  })

  it('logout_LimpiaTokensDelLocalStorage', () => {
    // Arrange
    localStorage.setItem('sc_token', 'token')
    localStorage.setItem('sc_refresh', 'refresh')

    // Act
    authService.logout()

    // Assert
    expect(localStorage.getItem('sc_token')).toBeNull()
    expect(localStorage.getItem('sc_refresh')).toBeNull()
  })

  it('getToken_CuandoHayToken_DevuelveToken', () => {
    localStorage.setItem('sc_token', 'token')
    expect(authService.getToken()).toBe('token')
  })

  it('getToken_CuandoNoHayToken_DevuelveNull', () => {
    expect(authService.getToken()).toBeNull()
  })

  it('refresh_ConRefreshTokenValido_ActualizaToken', async () => {
    // Arrange
    server.use(
      http.post(`${API_BASE}/auth/refresh`, () => {
        return HttpResponse.json({
          data: {
            token: 'new-token',
            refreshToken: 'new-refresh',
            usuario: { id: 1 }
          }
        })
      })
    )

    // Act
    await authService.refresh('old-refresh')

    // Assert
    expect(localStorage.getItem('sc_token')).toBe('new-token')
    expect(localStorage.getItem('sc_refresh')).toBe('new-refresh')
  })
})
