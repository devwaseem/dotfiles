import type {
  ExtensionAPI,
  ExtensionContext,
  SessionEntry,
} from "@earendil-works/pi-coding-agent";
import {
  CONFIG_DIR_NAME,
  getAgentDir,
  isToolCallEventType,
} from "@earendil-works/pi-coding-agent";
import { join } from "node:path";

import { loadPresetConfig } from "./config.ts";
import {
  adoptUserModelForRestoration,
  canRestoreModel,
  isClearlyModifyingShell,
  replayWorkflowBranch,
  WORKFLOW_ENTRY_TYPE,
} from "./state.ts";
import type {
  PresetChangedPayload,
  WorkflowPresets,
  WorkflowSnapshot,
  WorkflowState,
  WorkflowStateEvent,
} from "./types.ts";

const BUILTIN_NAMES = ["plan", "build", "review", "fast", "deep"];
const WORKFLOW_ALIASES = [...BUILTIN_NAMES, "woff"] as const;
const USAGE = "Usage: /workflow [list|status|plan|build|review|fast|deep|off]";
const textComponent = (text: string) => ({
  render: () => [text],
  invalidate() {},
});

function output(
  ctx: ExtensionContext,
  message: string,
  level: "info" | "warning" | "error" = "info",
) {
  if (ctx.hasUI) ctx.ui.notify(message, level);
  else console.log(message);
}
function snapshot(pi: ExtensionAPI, ctx: ExtensionContext): WorkflowSnapshot {
  return {
    modelProvider: ctx.model?.provider ?? null,
    modelId: ctx.model?.id ?? null,
    thinkingLevel: pi.getThinkingLevel(),
    tools: pi.getActiveTools(),
  };
}
function payload(state: WorkflowState | null): PresetChangedPayload {
  return state
    ? {
        name: state.name,
        thinkingLevel: state.effective.thinkingLevel,
        modelProvider: state.effective.modelProvider,
        modelId: state.effective.modelId,
        readOnly: state.readOnly,
      }
    : {
        name: null,
        thinkingLevel: null,
        modelProvider: null,
        modelId: null,
        readOnly: false,
      };
}

export default function workflowPresets(pi: ExtensionAPI) {
  let presets: WorkflowPresets = {};
  let active: WorkflowState | null = null;
  let applying = false;
  let currentContext: ExtensionContext | null = null;

  function publish(ctx: ExtensionContext) {
    ctx.ui.setStatus(
      "workflow-presets",
      active ? `mode:${active.name}` : undefined,
    );
    pi.events.emit("workflow:preset-changed", payload(active));
  }
  async function applySnapshot(
    target: WorkflowSnapshot,
    ctx: ExtensionContext,
  ) {
    applying = true;
    try {
      if (target.modelProvider && target.modelId) {
        const model = ctx.modelRegistry.find(
          target.modelProvider,
          target.modelId,
        );
        if (!model)
          output(
            ctx,
            `Model ${target.modelProvider}/${target.modelId} is unavailable; model unchanged`,
            "warning",
          );
        else if (!(await pi.setModel(model)))
          output(
            ctx,
            `No credentials for ${target.modelProvider}/${target.modelId}; model unchanged`,
            "warning",
          );
      }
      pi.setThinkingLevel(target.thinkingLevel);
      const available = new Set(pi.getAllTools().map((tool) => tool.name));
      pi.setActiveTools(target.tools.filter((tool) => available.has(tool)));
    } finally {
      applying = false;
    }
  }
  async function activate(name: string, ctx: ExtensionContext, persist = true) {
    const preset = presets[name];
    if (!preset) {
      output(
        ctx,
        `Unknown workflow "${name}". Available: ${Object.keys(presets).sort().join(", ") || "none"}`,
        "error",
      );
      return;
    }
    const original = active?.original ?? snapshot(pi, ctx);
    if (preset.provider && preset.model && !ctx.model) {
      output(
        ctx,
        `Workflow "${name}" cannot select a model because the session has no model to restore`,
        "error",
      );
      return;
    }
    const effective = snapshot(pi, ctx);
    if (preset.provider && preset.model) {
      effective.modelProvider = preset.provider;
      effective.modelId = preset.model;
    }
    if (preset.thinkingLevel) effective.thinkingLevel = preset.thinkingLevel;
    const available = new Set(pi.getAllTools().map((tool) => tool.name));
    if (preset.restoreTools)
      effective.tools = original.tools.filter((tool) => available.has(tool));
    else if (preset.tools) {
      const missing = preset.tools.filter((tool) => !available.has(tool));
      if (missing.length)
        output(
          ctx,
          `Workflow "${name}" unavailable tools: ${missing.join(", ")}`,
          "warning",
        );
      effective.tools = preset.tools.filter((tool) => available.has(tool));
    }
    await applySnapshot(effective, ctx);
    active = {
      name,
      readOnly: preset.readOnly === true,
      original,
      effective: snapshot(pi, ctx),
    };
    if (persist)
      pi.appendEntry(WORKFLOW_ENTRY_TYPE, {
        version: 1,
        kind: "activate",
        state: active,
      } satisfies WorkflowStateEvent);
    publish(ctx);
    output(ctx, `Workflow "${name}" active`);
  }
  async function disable(ctx: ExtensionContext) {
    if (!active) {
      output(ctx, "Workflow mode is already off");
      return;
    }
    const original = active.original;
    await applySnapshot(original, ctx);
    pi.appendEntry(WORKFLOW_ENTRY_TYPE, {
      version: 1,
      kind: "disable",
      original,
    } satisfies WorkflowStateEvent);
    active = null;
    publish(ctx);
    output(
      ctx,
      "Workflow mode off; original model, thinking and tools restored",
    );
  }
  async function selectWorkflow(ctx: ExtensionContext) {
    if (ctx.mode !== "tui" || !ctx.hasUI) {
      output(ctx, USAGE);
      return;
    }
    const choice = await ctx.ui.select("Workflow preset", [
      ...Object.keys(presets).sort(),
      "off",
    ]);
    if (!choice) return;
    if (choice === "off") await disable(ctx);
    else await activate(choice, ctx);
  }

  pi.registerCommand("workflow", {
    description: "Select or manage a workflow preset",
    getArgumentCompletions: (prefix) =>
      ["list", "status", ...BUILTIN_NAMES, "off"]
        .filter((name) => name.startsWith(prefix))
        .map((name) => ({ value: name, label: name })),
    handler: async (args, ctx) => {
      const command = args.trim();
      if (!command) return selectWorkflow(ctx);
      if (command === "list") {
        output(
          ctx,
          `Workflows: ${Object.keys(presets).sort().join(", ") || "none"}`,
        );
        return;
      }
      if (command === "status") {
        output(
          ctx,
          active
            ? `Workflow ${active.name}; thinking=${active.effective.thinkingLevel}; readOnly=${active.readOnly}`
            : "Workflow off",
        );
        return;
      }
      if (command === "off") return disable(ctx);
      if (/\s/.test(command)) {
        output(ctx, USAGE, "error");
        return;
      }
      await activate(command, ctx);
    },
  });
  for (const command of WORKFLOW_ALIASES)
    pi.registerCommand(command, {
      description:
        command === "woff"
          ? "Disable the active workflow"
          : `Activate the ${command} workflow`,
      handler: async (_args, ctx) => {
        if (command === "woff") await disable(ctx);
        else await activate(command, ctx);
      },
    });
  pi.registerCommand("wf", {
    description: "Select a workflow preset",
    handler: async (_args, ctx) => selectWorkflow(ctx),
  });
  pi.registerEntryRenderer<WorkflowStateEvent>(
    WORKFLOW_ENTRY_TYPE,
    (entry, _options, theme) => {
      if (!entry.data || entry.data.version !== 1) return undefined;
      const label =
        entry.data.kind === "disable"
          ? "workflow off"
          : `workflow ${entry.data.state.name}`;
      return textComponent(theme.fg("dim", label));
    },
  );
  pi.on("before_agent_start", (event) => {
    const instructions = active
      ? presets[active.name]?.instructions
      : undefined;
    if (instructions)
      return { systemPrompt: `${event.systemPrompt}\n\n${instructions}` };
  });
  pi.on("tool_call", (event) => {
    if (!active?.readOnly) return;
    if (event.toolName === "write" || event.toolName === "edit")
      return {
        block: true,
        reason: `Blocked by read-only workflow "${active.name}"`,
      };
    if (
      isToolCallEventType("bash", event) &&
      isClearlyModifyingShell(event.input.command)
    )
      return {
        block: true,
        reason: `Command appears modifying and is blocked by read-only workflow "${active.name}"`,
      };
  });
  async function reconstruct(ctx: ExtensionContext) {
    const previous = active;
    const replayed = replayWorkflowBranch(
      ctx.sessionManager.getBranch() as SessionEntry[],
    );
    active = replayed.active;
    if (active && !canRestoreModel(active.original, active.effective)) {
      output(
        ctx,
        `Workflow "${active.name}" was not restored because its original no-model state cannot be reapplied`,
        "warning",
      );
      active = null;
    }
    if (active) {
      if (!presets[active.name])
        output(
          ctx,
          `Active workflow "${active.name}" is no longer configured`,
          "warning",
        );
      await applySnapshot(active.effective, ctx);
      active.effective = snapshot(pi, ctx);
    } else if (previous)
      await applySnapshot(replayed.restore ?? previous.original, ctx);
    publish(ctx);
  }
  pi.on("session_start", async (_event, ctx) => {
    currentContext = ctx;
    const result = await loadPresetConfig(
      join(getAgentDir(), "presets.json"),
      ctx.isProjectTrusted()
        ? join(ctx.cwd, CONFIG_DIR_NAME, "presets.json")
        : undefined,
    );
    presets = result.presets;
    for (const warning of result.warnings) output(ctx, warning, "warning");
    await reconstruct(ctx);
  });
  pi.on("session_tree", async (_event, ctx) => {
    currentContext = ctx;
    await reconstruct(ctx);
  });
  function recordUserOverride(ctx: ExtensionContext) {
    if (!active || applying) return;
    const effective = snapshot(pi, ctx);
    active = {
      ...active,
      original: adoptUserModelForRestoration(active.original, effective),
      effective,
    };
    pi.appendEntry(WORKFLOW_ENTRY_TYPE, {
      version: 1,
      kind: "override",
      state: active,
    } satisfies WorkflowStateEvent);
    publish(ctx);
  }
  pi.on("model_select", (_event, ctx) => recordUserOverride(ctx));
  pi.on("thinking_level_select", (_event, ctx) => recordUserOverride(ctx));
  const offStateRequest = pi.events.on("herdr-companion:request-state", () => {
    if (currentContext) publish(currentContext);
  });
  pi.on("session_shutdown", () => {
    offStateRequest();
    if (currentContext)
      currentContext.ui.setStatus("workflow-presets", undefined);
    currentContext = null;
  });
}
