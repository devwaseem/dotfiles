export type TodoStatus = "pending" | "in_progress" | "completed";

export interface TodoItem {
  id: string;
  content: string;
  status: TodoStatus;
  subAction?: string;
}

export type SubagentStatus = "running" | "completed" | "failed";

export interface SubagentEntry {
  id: string;
  name: string;
  status: SubagentStatus;
  startedAt: number;
  completedAt?: number;
  turns: number;
  toolCount: number;
  tokens: number;
  toolLog: string[];
}

export interface McpServerInfo {
  name: string;
  directCount: number;
  totalCount: number;
  tokenEstimate: number;
  connected: boolean;
}

export interface StatusEntry {
  key: string;
  text: string;
}

export interface SidebarContext {
  sessionTitle: string | null;
  sessionId: string | null;
  todos: TodoItem[];
  statuses: StatusEntry[];
  subagents: SubagentEntry[];
  cwd: string | undefined;
  model: string | null;
  thinkingLevel: string | null;
  contextTokens: number | null;
  contextPercent: number | null;
  contextWindow: number | null;
  tokensIn: number;
  tokensOut: number;
  cacheRead: number;
  cacheWrite: number;
  sessionCost: number;
  turnCount: number;
  activeTools: string[];
  errorCount: number;
  hasTruncatedErrors: boolean;
  autoCompactEnabled: boolean | null;
  sessionStartMs: number;
  mcpServers: McpServerInfo[];
  modelProvider: string | null;
  liveTps: number | null;
  lastTps: number | null;
  lastTurnMs: number | null;
  cpuPercent: number | null;
  memoryPercent: number;
}
