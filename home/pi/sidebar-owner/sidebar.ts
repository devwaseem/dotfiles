import { truncateToWidth } from "@earendil-works/pi-tui";
import type { SidebarContext } from "./types.ts";
import { renderSessionPanel } from "./panels/session.ts";
import { renderTodosPanel } from "./panels/todos.ts";
import { renderStatusesPanel } from "./panels/statuses.ts";
import { renderSubagentsPanel } from "./panels/subagents.ts";
import { renderMcpPanel } from "./panels/mcp.ts";
import { renderActivityPanel } from "./panels/activity.ts";

export function renderSidebar(ctx: SidebarContext, width: number): string[] {
  const safeWidth = Math.max(1, width);

  const allPanels = [
    renderSessionPanel(ctx, safeWidth),
    renderActivityPanel(ctx, safeWidth),
    renderStatusesPanel(ctx, safeWidth),
    renderMcpPanel(ctx, safeWidth),
    renderTodosPanel(ctx, safeWidth),
    renderSubagentsPanel(ctx, safeWidth),
  ];
  // Skip empty panels (MCP panel returns [] when no servers)
  const panels = allPanels.filter((p) => p.length > 0);

  const result: string[] = [];
  for (let i = 0; i < panels.length; i++) {
    if (i > 0) result.push("");
    for (const line of panels[i]) {
      result.push(truncateToWidth(line, safeWidth, "", true));
    }
  }

  return result;
}
