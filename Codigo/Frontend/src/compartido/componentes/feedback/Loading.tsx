import { LoadingSpinner } from "./LoadingSpinner";
import { cn } from "@/lib/utils";

interface PropiedadesLoading {
  mensaje?: string;
  className?: string;
}

export function Loading({
  mensaje = "Cargando...",
  className,
}: PropiedadesLoading) {
  return (
    <div
      className={cn(
        "flex flex-col items-center justify-center p-8 space-y-4",
        className,
      )}
    >
      <LoadingSpinner tamaño="lg" />
      {mensaje && <p className="text-muted-foreground">{mensaje}</p>}
    </div>
  );
}
