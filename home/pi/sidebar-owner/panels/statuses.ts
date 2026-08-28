import type { SidebarContext } from "../types.ts";
import { dim, panelHeader } from "../colors.ts";

export function renderStatusesPanel(
  ctx: SidebarContext,
  width: number,
): string[] {
  if (ctx.statuses.length === 0) return [];

  const lines = [...panelHeader("Statuses", width)];
  for (const status of ctx.statuses) {
    lines.push(`${dim("  ")}${status.text}`);
  }
  return lines;
}
