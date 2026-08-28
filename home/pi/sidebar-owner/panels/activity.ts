import type { SidebarContext } from "../types.ts";
import { dim, fg, COLORS, panelHeader, trunc } from "../colors.ts";

export function renderActivityPanel(
  ctx: SidebarContext,
  width: number,
): string[] {
  const lines = [...panelHeader("Activity", width)];

  if (ctx.activeTools.length === 0) {
    lines.push(dim("  tools   —"));
  } else {
    for (const tool of ctx.activeTools) {
      lines.push(
        dim("  tool    ") + fg(COLORS.accent, trunc(tool, width - 10)),
      );
    }
  }

  const color = ctx.errorCount > 0 ? COLORS.warning : COLORS.success;
  const count = `${ctx.errorCount}${ctx.hasTruncatedErrors ? "+" : ""}`;
  lines.push(dim("  errors  ") + fg(color, count));
  return lines;
}
