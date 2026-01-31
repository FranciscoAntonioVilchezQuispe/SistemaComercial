export function Footer() {
  const añoActual = new Date().getFullYear();

  return (
    <footer className="border-t bg-background">
      <div className="container mx-auto px-4 py-4">
        <div className="flex flex-col md:flex-row items-center justify-between gap-4 text-sm text-muted-foreground">
          <p>© {añoActual} Sistema Comercial. Todos los derechos reservados.</p>
          <div className="flex gap-4">
            <a href="#" className="hover:text-primary transition-colors">
              Ayuda
            </a>
            <a href="#" className="hover:text-primary transition-colors">
              Soporte
            </a>
            <a href="#" className="hover:text-primary transition-colors">
              Términos
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
