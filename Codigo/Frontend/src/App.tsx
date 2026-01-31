import { RouterProvider } from 'react-router-dom'
import { ThemeProvider } from './componentes/ThemeProvider'
import { ruteador } from './configuracion/rutas'
import { Toaster } from './componentes/ui/toaster'
import './estilos/index.css'

function App() {
  return (
    <ThemeProvider
      attribute="class"
      defaultTheme="light"
      enableSystem
      disableTransitionOnChange
    >
      <RouterProvider router={ruteador} />
      <Toaster />
    </ThemeProvider>
  )
}

export default App
