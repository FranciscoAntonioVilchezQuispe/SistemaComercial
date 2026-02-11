import { RouterProvider } from "react-router-dom";
import { ThemeProvider } from "./componentes/ThemeProvider";
import { ruteador } from "./configuracion/rutas";
import { Toaster as SonnerToaster } from "sonner";
import { Toaster as RadixToaster } from "./componentes/ui/toaster";
import "./estilos/index.css";

function App() {
  return (
    <ThemeProvider
      attribute="class"
      defaultTheme="light"
      enableSystem
      disableTransitionOnChange
    >
      <RouterProvider router={ruteador} />
      <RadixToaster />
      <SonnerToaster position="top-right" richColors />
    </ThemeProvider>
  );
}

export default App;
