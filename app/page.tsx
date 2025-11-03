"use client";

import { MinimalChatInterface } from "@/components/features/chat/minimal-chat-interface";
import { AdminLoginGuard } from "./AdminLoginGuard";

export default function ArticolloChatPage() {
  return (
    <div className="h-screen w-full bg-background">
      <AdminLoginGuard>
        <MinimalChatInterface />
      </AdminLoginGuard>
    </div>
  );
}
