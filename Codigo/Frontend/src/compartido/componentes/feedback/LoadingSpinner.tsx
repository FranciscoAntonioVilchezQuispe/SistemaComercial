import { Loader2 } from "lucide-react";
import { cn } from "@/lib/utils";

interface PropiedadesLoadingSpinner {
  tamaño?: "sm" | "md" | "lg";
  className?: string;
}

const tamaños = {
  sm: "h-4 w-4",
  md: "h-8 w-8",
  lg: "h-12 w-12",
};

export function LoadingSpinner({
  tamaño = "md",
  className,
}: PropiedadesLoadingSpinner) {
  return (
    <Loader2
      className={cn("animate-spin text-primary", tamaños[tamaño], className)}
    />
  );
}
