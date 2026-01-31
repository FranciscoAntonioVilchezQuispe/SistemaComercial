import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: 5180,
    proxy: {
      "/api/usuarios": "http://localhost:5001",
      "/api/roles": "http://localhost:5001",
      "/api/permisos": "http://localhost:5001",
      "/api/menus": "http://localhost:5001",
      "/api/tipos-permiso": "http://localhost:5001",
      "/api/productos": "http://localhost:5008",
      "/api/categorias": "http://localhost:5008",
      "/api/marcas": "http://localhost:5008",
      "/api/unidades-medida": "http://localhost:5008",
      "/api/listas-precios": "http://localhost:5008",
      "/api/inventario": "http://localhost:5003",
      "/api/stock": "http://localhost:5003",
      "/api/movimientos": "http://localhost:5003",
      "/api/clientes": "http://localhost:5009",
      "/api/ventas": "http://localhost:5005",
      "/api/compras": "http://localhost:5010",
      "/api/configuracion": "http://localhost:5002",
      "/api/contabilidad": "http://localhost:5004",
    },
  },
  resolve: {
    alias: {
      "@/components": path.resolve(__dirname, "./src/componentes"),
      "@": path.resolve(__dirname, "./src"),
      "@features": path.resolve(__dirname, "./src/features"),
      "@compartido": path.resolve(__dirname, "./src/compartido"),
      "@layouts": path.resolve(__dirname, "./src/layouts"),
      "@lib": path.resolve(__dirname, "./src/lib"),
      "@servicios": path.resolve(__dirname, "./src/servicios"),
      "@configuracion": path.resolve(__dirname, "./src/configuracion"),
    },
  },
});
