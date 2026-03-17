import { NavLink, useLocation } from "react-router-dom";
import { cn } from "@/lib/utils";

interface Tab {
  label: string;
  to: string;
}

interface ModuleTabBarProps {
  tabs: Tab[];
}

export function ModuleTabBar({ tabs }: ModuleTabBarProps) {
  const { pathname } = useLocation();

  return (
    <div className="w-full border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container mx-auto">
        <div className="flex overflow-x-auto no-scrollbar items-center h-9 gap-1 px-1">
          {tabs.map((tab) => {
            const isActive = pathname === tab.to;
            return (
              <NavLink
                key={tab.to}
                to={tab.to}
                className={cn(
                  "relative h-9 flex items-center px-4 text-sm font-medium transition-colors hover:text-primary whitespace-nowrap",
                  isActive
                    ? "text-primary border-b-2 border-primary"
                    : "text-muted-foreground"
                )}
              >
                {tab.label}
              </NavLink>
            );
          })}
        </div>
      </div>
    </div>
  );
}

// Estilos globales adicionales para ocultar scrollbar si no se definen en index.css
const style = document.createElement('style');
style.textContent = `
  .no-scrollbar::-webkit-scrollbar {
    display: none;
  }
  .no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
  }
`;
if (typeof document !== 'undefined') {
  document.head.appendChild(style);
}
