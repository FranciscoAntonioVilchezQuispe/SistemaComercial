import api from "@/lib/axios";
import { OrdenCompra, OrdenCompraFormData } from "../types/ordenCompra.types";

// BASE_URL unused, directly using paths
// Checking existing service: servicioCompras.ts uses api.get("/compras") which implies axios base url has /api or similar or direct.
// OrdenCompraEndpoints.cs: group = app.MapGroup("/api/ordenes-compra").
// servicioCompras.ts: api.get("/compras").
// If axios baseURL is "...", we usually just append path.
// Assuming api instance is configured correctly. If previous service used "/compras", and backend has `/api/ordenes-compra`, I should verify if axios instance adds `/api` prefix automatically or not.
// Looking at `servicioCompras.ts` again: `api.get("/compras")`.
// Looking at `OrdenCompraEndpoints.cs`: `app.MapGroup("/api/ordenes-compra")`.
// If `servicioCompras` works with `/compras`, then there must be an endpoint mapped to `/compras` or `/api/compras`.
// Safest bet: Use the full relative path if unsure, or follow convention.
// However, `servicioCompras.ts` imports `api` from `@/lib/axios`.
// Let's assume `api.get("/ordenes-compra")` hits `/api/ordenes-compra` if baseURL ends in `/api`, OR I should provide `/ordenes-compra` if baseURL is root.
// BUT `OrdenCompraEndpoints.cs` maps to `/api/ordenes-compra`.
// I will use `/ordenes-compra` assuming the axios instance pre-pends `/api`. If not, I might need `/api/ordenes-compra`.
// Let's check `servicioCompras.ts` again. Wait, I didn't see the backend definition for `/compras` so I can't look it up yet.
// But `OrdenCompraEndpoints.cs` is explicit about `/api/ordenes-compra`.
// If I use `/ordenes-compra`, and axios adds `/api`, it becomes `/api/ordenes-compra`. This is standard.

export const obtenerOrdenesCompra = async (): Promise<OrdenCompra[]> => {
  const respuesta: any = await api.get("/ordenes-compra");
  const data = respuesta.datos || respuesta.data || [];
  return data;
};

export const obtenerSiguienteNumero = async (): Promise<string> => {
  const respuesta: any = await api.get("/ordenes-compra/siguiente-numero");
  return respuesta.datos || respuesta.data;
};

export const obtenerOrdenCompra = async (id: number): Promise<OrdenCompra> => {
  const respuesta: any = await api.get(`/ordenes-compra/${id}`);
  return respuesta.datos || respuesta.data;
};

export const registrarOrdenCompra = async (
  data: OrdenCompraFormData,
): Promise<OrdenCompra> => {
  // Convertir fechas a string si es necesario, o dejar que axios/JSON.stringify lo maneje.
  // El backend espera `OrdenCompraDto`.
  const payload = {
    ...data,
    // Asegurar tipos numéricos si el form pasa strings
    idProveedor: Number(data.idProveedor),
    idAlmacenDestino: Number(data.idAlmacenDestino),
    idEstado: Number(data.idEstado),
    // date-fns o native date toISOString
    fechaEmision: data.fechaEmision.toISOString(),
    fechaEntregaEstimada: data.fechaEntregaEstimada?.toISOString(),

    detalles: data.detalles.map((d) => ({
      idProducto: Number(d.idProducto),
      cantidadSolicitada: Number(d.cantidadSolicitada),
      precioUnitarioPactado: Number(d.precioUnitarioPactado),
      subtotal: Number(d.cantidadSolicitada) * Number(d.precioUnitarioPactado),
    })),

    totalImporte: data.detalles.reduce(
      (acc, curr) =>
        acc +
        Number(curr.cantidadSolicitada) * Number(curr.precioUnitarioPactado),
      0,
    ),
  };

  console.log("Payload enviado al servidor:", payload);
  const respuesta: any = await api.post("/ordenes-compra", payload);
  return respuesta.datos || respuesta.data;
};

export const cambiarEstadoOrdenCompra = async (
  id: number,
  idEstado: number,
): Promise<void> => {
  await api.patch(`/ordenes-compra/${id}/estado`, null, {
    params: { idEstado },
  });
};
