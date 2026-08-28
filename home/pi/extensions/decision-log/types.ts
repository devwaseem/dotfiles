export type DecisionStatus =
  | "proposed"
  | "accepted"
  | "superseded"
  | "rejected"
  | "deleted";
export interface Decision {
  id: string;
  status: DecisionStatus;
  summary: string;
  context?: string;
  rationale?: string;
  alternatives?: string[];
  consequences?: string[];
  tags?: string[];
  createdAt: string;
  updatedAt: string;
  supersedes?: string;
  supersededBy?: string;
  source: "user" | "agent";
  workflowPreset?: string | null;
  model?: { provider?: string; id?: string };
  repository?: { rootName?: string; branch?: string };
}
export type DecisionEvent =
  | { version: 1; kind: "upsert"; decision: Decision }
  | { version: 1; kind: "transaction"; decisions: Decision[] };
export interface DecisionCounts {
  count: number;
  proposedCount: number;
  acceptedCount: number;
  latestId: string | null;
  latestSummary: string | null;
}
