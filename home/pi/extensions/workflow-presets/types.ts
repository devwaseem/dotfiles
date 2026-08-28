export const THINKING_LEVELS = [
  "off",
  "minimal",
  "low",
  "medium",
  "high",
  "xhigh",
  "max",
] as const;
export type ThinkingLevel = (typeof THINKING_LEVELS)[number];

export interface WorkflowPreset {
  provider?: string;
  model?: string;
  thinkingLevel?: ThinkingLevel;
  tools?: string[];
  restoreTools?: boolean;
  readOnly?: boolean;
  instructions?: string;
}
export type WorkflowPresets = Record<string, WorkflowPreset>;

export interface WorkflowSnapshot {
  modelProvider: string | null;
  modelId: string | null;
  thinkingLevel: ThinkingLevel;
  tools: string[];
}
export interface WorkflowState {
  name: string;
  readOnly: boolean;
  original: WorkflowSnapshot;
  effective: WorkflowSnapshot;
}
export type WorkflowStateEvent =
  | { version: 1; kind: "activate" | "override"; state: WorkflowState }
  | { version: 1; kind: "disable"; original: WorkflowSnapshot };
export interface PresetChangedPayload {
  name: string | null;
  thinkingLevel: string | null;
  modelProvider: string | null;
  modelId: string | null;
  readOnly: boolean;
}
