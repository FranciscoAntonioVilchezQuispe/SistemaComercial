import React from 'react'
import { render, renderHook, RenderOptions, RenderHookOptions } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { MemoryRouter } from 'react-router-dom'

export function crearQueryClient(): QueryClient {
  return new QueryClient({
    defaultOptions: {
      queries: { retry: false, gcTime: 0, staleTime: 0 },
      mutations: { retry: false },
    },
  })
}

function crearWrapper(initialEntries: string[] = ['/']) {
  const queryClient = crearQueryClient()
  return function Wrapper({ children }: { children: React.ReactNode }) {
    return (
      <QueryClientProvider client={queryClient}>
        <MemoryRouter initialEntries={initialEntries}>{children}</MemoryRouter>
      </QueryClientProvider>
    )
  }
}

export function renderConProveedores(
  ui: React.ReactElement,
  options?: Omit<RenderOptions, 'wrapper'> & { initialEntries?: string[] }
) {
  const { initialEntries, ...renderOptions } = options ?? {}
  return render(ui, { wrapper: crearWrapper(initialEntries), ...renderOptions })
}

export function renderHookConProveedores<TResult, TProps = void>(
  hook: (props: TProps) => TResult,
  options?: Omit<RenderHookOptions<TProps>, 'wrapper'> & { initialEntries?: string[] }
) {
  const { initialEntries, ...hookOptions } = options ?? {}
  return renderHook(hook, { wrapper: crearWrapper(initialEntries), ...hookOptions })
}
