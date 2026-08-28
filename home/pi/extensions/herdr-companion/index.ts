import { basename } from "node:path";
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import {
  buildMetadata,
  metadataFingerprint,
  resolveHerdrConfig,
  shouldSendMetadata,
  updateDecisions,
  updateWorkflow,
} from "./metadata.ts";
import { sendHerdrRequest, SocketPool } from "./ipc.ts";
import type {
  CompanionState,
  GitMetadata,
  HerdrConfig,
  HerdrMetadataParams,
} from "./types.ts";

export default function herdrCompanion(pi: ExtensionAPI) {
  let config: HerdrConfig | null = null;
  let context: ExtensionContext | null = null;
  let state: CompanionState = { workflow: null, decisions: 0 };
  let git: GitMetadata = { rootName: "", branch: "none", state: "unknown" };
  let gitCachedAt = 0;
  let debounce: ReturnType<typeof setTimeout> | null = null;
  let sequence = Date.now() * 1000;
  let lastFingerprint: string | null = null;
  let lastParams: HerdrMetadataParams | null = null;
  let lastDeliveredAt: number | null = null;
  let lastError: string | null = null;
  let stopped = true;
  let offWorkflow: (() => void) | null = null;
  let offDecisions: (() => void) | null = null;
  const inFlightReports = new Set<Promise<void>>();
  const pool = new SocketPool();

  function nextSequence() {
    sequence += 1;
    return sequence;
  }
  async function refreshGit(ctx: ExtensionContext, force = false) {
    if (!force && Date.now() - gitCachedAt < 2_000) return;
    gitCachedAt = Date.now();
    const root = await pi.exec("git", ["rev-parse", "--show-toplevel"], {
      timeout: 1200,
    });
    if (root.code !== 0 || !root.stdout.trim()) {
      git = { rootName: basename(ctx.cwd), branch: "none", state: "unknown" };
      return;
    }
    const [branch, status] = await Promise.all([
      pi.exec("git", ["branch", "--show-current"], { timeout: 1200 }),
      pi.exec("git", ["status", "--porcelain=v1", "--untracked-files=normal"], {
        timeout: 1500,
      }),
    ]);
    let branchName = branch.stdout.trim();
    if (!branchName) {
      const head = await pi.exec("git", ["rev-parse", "--short", "HEAD"], {
        timeout: 1200,
      });
      branchName =
        head.code === 0 ? `detached:${head.stdout.trim()}` : "detached";
    }
    git = {
      rootName: basename(root.stdout.trim()),
      branch: branchName,
      state:
        status.code === 0
          ? status.stdout.trim()
            ? "dirty"
            : "clean"
          : "unknown",
    };
  }
  async function report(force = false) {
    const ctx = context;
    if (stopped || !config || !ctx) return;
    await refreshGit(ctx, force);
    if (stopped || !config) return;
    const project = git.rootName || basename(ctx.cwd);
    const params = buildMetadata({
      paneId: config.paneId,
      title: ctx.sessionManager.getSessionName() ?? project,
      model: ctx.model ? `${ctx.model.provider}/${ctx.model.id}` : "unknown",
      thinking: pi.getThinkingLevel(),
      mode: state.workflow ?? "default",
      project,
      git,
      workflow: state.workflow,
      decisions: state.decisions,
    });
    const fingerprint = metadataFingerprint(params);
    if (!force && !shouldSendMetadata(lastFingerprint, params)) return;
    const request = {
      id: `herdr:pi-companion:${nextSequence()}`,
      method: "pane.report_metadata",
      params: { ...params, seq: sequence },
    };
    if (await sendHerdrRequest(config.endpoint, request, pool)) {
      lastFingerprint = fingerprint;
      lastParams = params;
      lastDeliveredAt = Date.now();
      lastError = null;
    } else lastError = "metadata delivery failed";
  }
  function runReport(force = false): Promise<void> {
    const pending = report(force);
    inFlightReports.add(pending);
    void pending.then(
      () => inFlightReports.delete(pending),
      () => inFlightReports.delete(pending),
    );
    return pending;
  }
  function schedule(force = false) {
    if (stopped || !config) return;
    if (force) lastFingerprint = null;
    if (debounce) clearTimeout(debounce);
    debounce = setTimeout(() => {
      debounce = null;
      void runReport(force);
    }, 120);
    debounce.unref?.();
  }
  function stopListeners() {
    offWorkflow?.();
    offWorkflow = null;
    offDecisions?.();
    offDecisions = null;
  }

  pi.registerCommand("herdr-companion", {
    description: "Show or refresh Herdr companion metadata",
    handler: async (args, ctx) => {
      const action = args.trim() || "status";
      if (!config || stopped) {
        const text =
          "Herdr companion is inactive (requires Herdr TUI environment)";
        if (ctx.hasUI) ctx.ui.notify(text, "info");
        else console.log(text);
        return;
      }
      if (action === "refresh") {
        gitCachedAt = 0;
        await runReport(true);
        const text = lastError ?? "Herdr metadata refreshed";
        if (ctx.hasUI) ctx.ui.notify(text, lastError ? "warning" : "info");
        else console.log(text);
        return;
      }
      if (action !== "status") {
        const text = "Usage: /herdr-companion [status|refresh]";
        if (ctx.hasUI) ctx.ui.notify(text, "error");
        else console.log(text);
        return;
      }
      const text =
        lastError ??
        (lastDeliveredAt
          ? `Herdr metadata active; last delivered ${new Date(lastDeliveredAt).toLocaleTimeString()}`
          : "Herdr metadata active; delivery pending");
      if (ctx.hasUI) ctx.ui.notify(text, lastError ? "warning" : "info");
      else console.log(text);
    },
  });

  pi.on("session_start", (_event, ctx) => {
    const resolved = resolveHerdrConfig(process.env, ctx.mode);
    if (!resolved) return;
    config = resolved;
    context = ctx;
    stopped = false;
    state = { workflow: null, decisions: 0 };
    git = { rootName: basename(ctx.cwd), branch: "none", state: "unknown" };
    gitCachedAt = 0;
    offWorkflow = pi.events.on("workflow:preset-changed", (value) => {
      state = updateWorkflow(state, value);
      schedule();
    });
    offDecisions = pi.events.on("decision-log:changed", (value) => {
      state = updateDecisions(state, value);
      schedule();
    });
    pi.events.emit("herdr-companion:request-state", undefined);
    schedule(true);
  });
  pi.on("session_info_changed", () => schedule());
  pi.on("model_select", () => schedule());
  pi.on("thinking_level_select", () => schedule());
  pi.on("tool_execution_end", (event) => {
    if (
      event.toolName === "bash" ||
      event.toolName === "edit" ||
      event.toolName === "write"
    ) {
      gitCachedAt = 0;
      schedule();
    }
  });
  pi.on("session_shutdown", async () => {
    stopped = true;
    if (debounce) {
      clearTimeout(debounce);
      debounce = null;
    }
    stopListeners();
    await Promise.allSettled([...inFlightReports]);
    if (config) {
      const tokenKeys = lastParams
        ? Object.keys(lastParams.tokens)
        : [
            "model",
            "thinking",
            "mode",
            "project",
            "git_branch",
            "git_state",
            "decisions",
          ];
      const tokens = Object.fromEntries(tokenKeys.map((key) => [key, null]));
      await sendHerdrRequest(
        config.endpoint,
        {
          id: `herdr:pi-companion:clear:${nextSequence()}`,
          method: "pane.report_metadata",
          params: {
            pane_id: config.paneId,
            source: "herdr:pi-companion",
            applies_to_source: "herdr:pi",
            agent: "pi",
            seq: sequence,
            clear_title: true,
            clear_display_agent: true,
            clear_state_labels: true,
            tokens,
          },
        },
        pool,
      );
    }
    pool.close();
    config = null;
    context = null;
    lastParams = null;
    lastFingerprint = null;
  });
}
