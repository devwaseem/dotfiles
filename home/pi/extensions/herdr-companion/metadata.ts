import type {
  CompanionState,
  HerdrConfig,
  HerdrMetadataParams,
  SafeMetadataInput,
} from "./types.ts";

function short(value: string, max = 64): string {
  const clean = value.replace(/[\r\n\t]+/g, " ").trim();
  return clean.length <= max ? clean : `${clean.slice(0, max - 1)}…`;
}
export function resolveHerdrConfig(
  env: Record<string, string | undefined>,
  mode: string,
  platform = process.platform,
): HerdrConfig | null {
  if (
    mode !== "tui" ||
    env.HERDR_ENV !== "1" ||
    !env.HERDR_SOCKET_PATH ||
    !env.HERDR_PANE_ID
  )
    return null;
  return {
    paneId: env.HERDR_PANE_ID,
    endpoint:
      platform === "win32"
        ? `\\\\.\\pipe\\${env.HERDR_SOCKET_PATH}`
        : env.HERDR_SOCKET_PATH,
  };
}
export function updateWorkflow(
  state: CompanionState,
  value: unknown,
): CompanionState {
  if (!value || typeof value !== "object") return state;
  const name = (value as { name?: unknown }).name;
  return {
    ...state,
    workflow: typeof name === "string" ? short(name, 24) : null,
  };
}
export function updateDecisions(
  state: CompanionState,
  value: unknown,
): CompanionState {
  if (!value || typeof value !== "object") return state;
  const count = (value as { count?: unknown }).count;
  return typeof count === "number" && Number.isSafeInteger(count) && count >= 0
    ? { ...state, decisions: count }
    : state;
}
export function buildMetadata(input: SafeMetadataInput): HerdrMetadataParams {
  const workflow = input.workflow ? short(input.workflow, 24) : null;
  return {
    pane_id: input.paneId,
    source: "herdr:pi-companion",
    applies_to_source: "herdr:pi",
    agent: "pi",
    title: short(input.title, 80),
    display_agent: workflow ? `Pi · ${workflow}` : "Pi",
    state_labels: workflow ? { workflow } : {},
    tokens: {
      model: short(input.model),
      thinking: short(input.thinking, 16),
      mode: short(input.mode, 16),
      project: short(input.project, 40),
      git_branch: short(input.git.branch, 40),
      git_state: input.git.state,
      decisions: String(input.decisions),
    },
  };
}
export function metadataFingerprint(params: HerdrMetadataParams): string {
  return JSON.stringify(params);
}
export function shouldSendMetadata(
  lastFingerprint: string | null,
  params: HerdrMetadataParams,
): boolean {
  return metadataFingerprint(params) !== lastFingerprint;
}
