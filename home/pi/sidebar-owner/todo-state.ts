import type { TodoItem } from "./types.ts";

interface BranchEntry {
  type?: string;
  message?: {
    role?: string;
    toolName?: string;
    details?: unknown;
  };
}

export function todosFromDetails(details: unknown): TodoItem[] | null {
  if (!details || typeof details !== "object") return null;
  const raw = (details as Record<string, unknown>)["tasks"];
  if (!Array.isArray(raw)) return null;

  const todos: TodoItem[] = [];
  for (const value of raw) {
    if (!value || typeof value !== "object") continue;
    const task = value as Record<string, unknown>;
    const status = task["status"];
    const subject = task["subject"];
    if (status === "deleted" || typeof subject !== "string") continue;
    if (
      status !== "pending" &&
      status !== "in_progress" &&
      status !== "completed"
    )
      continue;

    todos.push({
      id: String(task["id"] ?? todos.length),
      content: subject,
      status,
      ...(typeof task["activeForm"] === "string"
        ? { subAction: task["activeForm"] }
        : {}),
    });
  }
  return todos;
}

export function replayTodos(sessionManager: {
  getBranch(): Iterable<unknown>;
}): TodoItem[] {
  let todos: TodoItem[] = [];
  for (const value of sessionManager.getBranch()) {
    const entry = value as BranchEntry;
    if (entry.type !== "message") continue;
    const message = entry.message;
    if (message?.role !== "toolResult" || message.toolName !== "todo") continue;
    const snapshot = todosFromDetails(message.details);
    if (snapshot !== null) todos = snapshot;
  }
  return todos;
}
