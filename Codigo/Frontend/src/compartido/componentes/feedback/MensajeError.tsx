import { AlertDialog, AlertDialogTitle, AlertDialogDescription, AlertDialogContent } from "@/componentes/ui/alert-dialog";

interface PropiedadesMensajeError {
  titulo?: string;
  mensaje: string;
}

export function MensajeError({
  titulo = "Error",
  mensaje,
}: PropiedadesMensajeError) {
  return (
    <AlertDialog>
      <AlertDialogContent>
        <AlertDialogTitle>{titulo}</AlertDialogTitle>
        <AlertDialogDescription>{mensaje}</AlertDialogDescription>
      </AlertDialogContent>
    </AlertDialog>
  );
}
