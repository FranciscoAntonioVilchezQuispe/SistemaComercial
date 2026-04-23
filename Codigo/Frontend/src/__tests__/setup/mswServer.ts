import { setupServer } from 'msw/node'
import { http, HttpResponse } from 'msw'

export const API_BASE = 'http://localhost:5000/api'

export function respuestaPaginadaVacia<T>() {
  return {
    datos: [] as T[],
    total: 0, pageNumber: 1, pageSize: 10,
    totalPages: 0, hasPreviousPage: false, hasNextPage: false,
    status: 200, message: '', transactionId: 'test-id',
  }
}

export const defaultHandlers = [
  http.get(`${API_BASE}/productos`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/categorias`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/marcas`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/ventas`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/compras`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/clientes`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/inventario/stock`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/inventario/movimientos`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/proveedores`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/ordenes-compra`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.post(`${API_BASE}/auth/login`, () =>
    HttpResponse.json({
      data: {
        token: 'token-test',
        refreshToken: 'refresh-test',
        usuario: { id: 1, username: 'test', nombres: 'Test', apellidos: 'User', email: 'test@test.com' },
      }
    })
  ),
]

export const server = setupServer(...defaultHandlers)
