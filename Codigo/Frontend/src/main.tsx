import ReactDOM from 'react-dom/client'
import { AppProviders } from './providers'
import App from './App'
import './estilos/index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <AppProviders>
    <App />
  </AppProviders>,
)
