export interface HerdrConfig {
  paneId: string;
  endpoint: string;
}
export interface GitMetadata {
  rootName: string;
  branch: string;
  state: "clean" | "dirty" | "unknown";
}
export interface CompanionState {
  workflow: string | null;
  decisions: number;
}
export interface SafeMetadataInput {
  paneId: string;
  title: string;
  model: string;
  thinking: string;
  mode: string;
  project: string;
  git: GitMetadata;
  workflow: string | null;
  decisions: number;
}
export interface HerdrMetadataParams {
  pane_id: string;
  source: "herdr:pi-companion";
  applies_to_source: "herdr:pi";
  agent: "pi";
  title: string;
  display_agent: string;
  state_labels: Record<string, string>;
  tokens: Record<string, string | null>;
}
