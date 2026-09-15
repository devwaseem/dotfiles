export function splitSidebarWidth(columns: number): number {
  const safeColumns = Math.max(1, Math.floor(columns));
  return Math.max(
    1,
    Math.min(Math.max(30, Math.floor(safeColumns * 0.45)), safeColumns - 40),
  );
}
