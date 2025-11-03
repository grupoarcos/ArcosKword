"use client";

import { useEffect, useState } from "react";

interface AdminLoginGuardProps {
  children: React.ReactNode;
}

export function AdminLoginGuard({ children }: AdminLoginGuardProps) {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isChecking, setIsChecking] = useState(true);

  useEffect(() => {
    // Verifica se já está autenticado na sessão
    const authStatus = sessionStorage.getItem("admin_authenticated");

    if (authStatus === "true") {
      setIsAuthenticated(true);
      setIsChecking(false);
      return;
    }

    // Mostra o prompt de login
    const attemptLogin = () => {
      const username = prompt("🔐 Login de Administrador\n\nUsuário:");

      if (username === null) {
        // Usuário cancelou
        alert("Acesso negado!");
        window.location.href = "about:blank";
        return;
      }

      const password = prompt("🔐 Login de Administrador\n\nSenha:");

      if (password === null) {
        // Usuário cancelou
        alert("Acesso negado!");
        window.location.href = "about:blank";
        return;
      }

      // Pega as credenciais das variáveis de ambiente
      const validUsername = process.env.NEXT_PUBLIC_ADMIN_USERNAME || "admin";
      const validPassword =
        process.env.NEXT_PUBLIC_ADMIN_PASSWORD || "admin123";

      if (username === validUsername && password === validPassword) {
        sessionStorage.setItem("admin_authenticated", "true");
        setIsAuthenticated(true);
        setIsChecking(false);
      } else {
        alert("❌ Credenciais inválidas!");
        attemptLogin(); // Tenta novamente
      }
    };

    attemptLogin();
  }, []);

  if (isChecking || !isAuthenticated) {
    return (
      <div className="h-screen w-full flex items-center justify-center bg-background">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
          <p className="text-muted-foreground">Verificando acesso...</p>
        </div>
      </div>
    );
  }

  return <>{children}</>;
}
