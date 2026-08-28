import type {
  WorkflowSnapshot,
  WorkflowState,
  WorkflowStateEvent,
} from "./types.ts";

interface CustomEntryLike {
  type?: string;
  customType?: string;
  data?: unknown;
}
export const WORKFLOW_ENTRY_TYPE = "workflow-presets-state";

export function canRestoreModel(
  original: WorkflowSnapshot,
  effective: WorkflowSnapshot,
): boolean {
  return (
    original.modelProvider !== null ||
    (effective.modelProvider === null && effective.modelId === null)
  );
}

export function adoptUserModelForRestoration(
  original: WorkflowSnapshot,
  effective: WorkflowSnapshot,
): WorkflowSnapshot {
  if (canRestoreModel(original, effective)) return original;
  return {
    ...original,
    modelProvider: effective.modelProvider,
    modelId: effective.modelId,
  };
}

function isSnapshot(value: unknown): value is WorkflowSnapshot {
  if (!value || typeof value !== "object") return false;
  const item = value as Partial<WorkflowSnapshot>;
  const hasModel =
    typeof item.modelProvider === "string" && typeof item.modelId === "string";
  const hasNoModel = item.modelProvider === null && item.modelId === null;
  return (
    (hasModel || hasNoModel) &&
    typeof item.thinkingLevel === "string" &&
    Array.isArray(item.tools) &&
    item.tools.every((tool) => typeof tool === "string")
  );
}

export function isWorkflowStateEvent(
  value: unknown,
): value is WorkflowStateEvent {
  if (!value || typeof value !== "object") return false;
  const event = value as Partial<WorkflowStateEvent> & {
    state?: Partial<WorkflowState>;
  };
  if (event.version !== 1) return false;
  if (event.kind === "disable") return isSnapshot(event.original);
  return (
    (event.kind === "activate" || event.kind === "override") &&
    typeof event.state?.name === "string" &&
    typeof event.state.readOnly === "boolean" &&
    isSnapshot(event.state.original) &&
    isSnapshot(event.state.effective)
  );
}

export function replayWorkflowState(
  entries: readonly CustomEntryLike[],
): WorkflowState | null {
  return replayWorkflowBranch(entries).active;
}

export function replayWorkflowBranch(entries: readonly CustomEntryLike[]): {
  active: WorkflowState | null;
  restore: WorkflowSnapshot | null;
} {
  let state: WorkflowState | null = null;
  let restore: WorkflowSnapshot | null = null;
  for (const entry of entries) {
    if (
      entry.type !== "custom" ||
      entry.customType !== WORKFLOW_ENTRY_TYPE ||
      !isWorkflowStateEvent(entry.data)
    )
      continue;
    if (entry.data.kind === "disable") {
      state = null;
      restore = structuredClone(entry.data.original);
    } else state = structuredClone(entry.data.state);
  }
  return { active: state, restore };
}

export function isClearlyModifyingShell(command: string): boolean {
  const normalized = command.replace(/\\\n/g, " ").trim();
  if (!normalized) return false;
  return [
    /(^|[;&|]\s*)(rm|mv|cp|mkdir|rmdir|touch|truncate|chmod|chown|ln|install)\b/i,
    /(^|[;&|]\s*)git\s+(add|commit|push|pull|fetch|merge|rebase|reset|restore|checkout|switch|clean|stash|tag|branch\s+(-d|-D)|worktree\s+(add|remove|move|prune))\b/i,
    /\bsed\b[^;&|]*\s-i(?:\s|$)/i,
    /\b(npm|pnpm|yarn|bun)\s+(add|install|remove|update|publish)\b/i,
    /\b(nix|darwin-rebuild)\s+(build|develop|run|shell|flake\s+(update|lock))\b/i,
    /(^|[^<])>{1,2}(?!>)/,
    /\btee\b/i,
    /\b(curl|wget)\b[^;&|]*(\s-o\s|\s-O(?:\s|$)|--output\b|--remote-name\b)/i,
  ].some((pattern) => pattern.test(normalized));
}
