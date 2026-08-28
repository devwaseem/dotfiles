import { randomBytes } from "node:crypto";
import { constants } from "node:fs";
import { access, readFile, realpath, stat } from "node:fs/promises";
import { basename, dirname, relative } from "node:path";
import { Type } from "typebox";
import type {
  ExtensionAPI,
  ExtensionContext,
  SessionEntry,
} from "@earendil-works/pi-coding-agent";

import { replaceFileAtomically } from "./atomic.ts";
import {
  decisionTemplate,
  parseDecisionTemplate,
  splitCommand,
} from "./commands.ts";
import {
  END_MARKER,
  renderDecisionsMarkdown,
  resolveExportPath,
  START_MARKER,
  updateManagedSection,
} from "./markdown.ts";
import {
  activeDecisions,
  decisionAlias,
  decisionCounts,
  DECISION_ENTRY_TYPE,
  replayDecisions,
  resolveDecisionPrefix,
} from "./store.ts";
import type { Decision, DecisionEvent, DecisionStatus } from "./types.ts";

const USAGE =
  "Usage: /decision [add|propose|list [--all]|show <id>|accept <id>|reject <id> [reason]|edit <id>|supersede <id>|delete <id> [--confirm]|export [path]|status]";
const textComponent = (text: string) => ({
  render: () => text.split("\n"),
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
function id(): string {
  return `${Date.now().toString(36)}-${randomBytes(4).toString("hex")}`;
}
function cleanList(items?: string[]): string[] | undefined {
  const result = items?.map((item) => item.trim()).filter(Boolean);
  return result?.length ? result : undefined;
}

export default function decisionLog(pi: ExtensionAPI) {
  let decisions = new Map<string, Decision>();
  let workflowPreset: string | null = null;
  let currentContext: ExtensionContext | null = null;

  function publish(ctx: ExtensionContext) {
    const counts = decisionCounts(decisions);
    ctx.ui.setStatus("decision-log", `decisions:${counts.count}`);
    pi.events.emit("decision-log:changed", counts);
  }
  function append(event: DecisionEvent, ctx: ExtensionContext) {
    pi.appendEntry(DECISION_ENTRY_TYPE, event);
    const updates =
      event.kind === "upsert" ? [event.decision] : event.decisions;
    for (const decision of updates) decisions.set(decision.id, decision);
    publish(ctx);
  }
  async function repository(
    ctx: ExtensionContext,
  ): Promise<Decision["repository"]> {
    const root = await pi.exec("git", ["rev-parse", "--show-toplevel"], {
      timeout: 1500,
    });
    if (root.code !== 0) return { rootName: basename(ctx.cwd) };
    const branch = await pi.exec("git", ["branch", "--show-current"], {
      timeout: 1500,
    });
    return {
      rootName: basename(root.stdout.trim()),
      branch: branch.stdout.trim() || "detached",
    };
  }
  async function makeDecision(
    ctx: ExtensionContext,
    fields: Partial<Decision> & { summary: string },
    status: DecisionStatus,
    source: "user" | "agent",
  ) {
    const now = new Date().toISOString();
    return {
      id: id(),
      status,
      summary: fields.summary.trim(),
      context: fields.context?.trim() || undefined,
      rationale: fields.rationale?.trim() || undefined,
      alternatives: cleanList(fields.alternatives),
      consequences: cleanList(fields.consequences),
      tags: cleanList(fields.tags),
      createdAt: now,
      updatedAt: now,
      source,
      workflowPreset,
      model: { provider: ctx.model?.provider, id: ctx.model?.id },
      repository: await repository(ctx),
      supersedes: fields.supersedes,
    } satisfies Decision;
  }
  async function collect(
    ctx: ExtensionContext,
    existing?: Decision,
  ): Promise<ReturnType<typeof parseDecisionTemplate> | null> {
    if (ctx.mode !== "tui" || !ctx.hasUI) return null;
    const text = await ctx.ui.editor(
      existing ? "Edit decision" : "Add decision",
      decisionTemplate(existing),
    );
    if (text === undefined) return null;
    try {
      return parseDecisionTemplate(text);
    } catch (error) {
      output(
        ctx,
        error instanceof Error ? error.message : String(error),
        "error",
      );
      return null;
    }
  }
  function displayId(decision: Decision): string {
    return decisionAlias(decisions, decision.id);
  }
  function find(prefix: string, ctx: ExtensionContext): Decision | undefined {
    if (!prefix) {
      output(ctx, "Decision ID is required", "error");
      return;
    }
    try {
      return resolveDecisionPrefix(decisions, prefix);
    } catch (error) {
      output(
        ctx,
        error instanceof Error ? error.message : String(error),
        "error",
      );
      return;
    }
  }
  function render(decision: Decision): string {
    const line = (name: string, value?: string | string[]) =>
      value
        ? `\n${name}: ${Array.isArray(value) ? value.join("; ") : value}`
        : "";
    return `[${displayId(decision)}] ${decision.status}: ${decision.summary}${line("Captured", decision.createdAt)}${line("Context", decision.context)}${line("Rationale", decision.rationale)}${line("Alternatives", decision.alternatives)}${line("Consequences", decision.consequences)}${line("Tags", decision.tags)}${line("Supersedes", decision.supersedes ? decisionAlias(decisions, decision.supersedes) : undefined)}${line("Superseded by", decision.supersededBy ? decisionAlias(decisions, decision.supersededBy) : undefined)}`;
  }
  function supersededTarget(reference?: string): Decision | undefined {
    if (!reference) return;
    const target = resolveDecisionPrefix(decisions, reference);
    if (target.status !== "accepted")
      throw new Error(
        `${decisionAlias(decisions, target.id)} is not an accepted decision`,
      );
    return target;
  }
  function acceptDecision(decision: Decision, ctx: ExtensionContext) {
    const accepted = {
      ...decision,
      status: "accepted" as const,
      updatedAt: new Date().toISOString(),
    };
    if (!accepted.supersedes) {
      append({ version: 1, kind: "upsert", decision: accepted }, ctx);
      return;
    }
    const target = supersededTarget(accepted.supersedes);
    if (!target) return;
    const superseded = {
      ...target,
      status: "superseded" as const,
      supersededBy: accepted.id,
      updatedAt: accepted.updatedAt,
    };
    append(
      { version: 1, kind: "transaction", decisions: [superseded, accepted] },
      ctx,
    );
  }
  async function mutateStatus(
    prefix: string,
    status: DecisionStatus,
    ctx: ExtensionContext,
    reason?: string,
  ) {
    const current = find(prefix, ctx);
    if (!current) return;
    const updated = {
      ...current,
      status,
      updatedAt: new Date().toISOString(),
      rationale: reason?.trim()
        ? [current.rationale, reason.trim()].filter(Boolean).join("\n")
        : current.rationale,
    };
    try {
      if (status === "accepted") acceptDecision(updated, ctx);
      else append({ version: 1, kind: "upsert", decision: updated }, ctx);
      output(ctx, `${displayId(updated)} ${status}`);
    } catch (error) {
      output(
        ctx,
        error instanceof Error ? error.message : String(error),
        "error",
      );
    }
  }

  async function repositoryRoot(): Promise<string | null> {
    const result = await pi.exec("git", ["rev-parse", "--show-toplevel"], {
      timeout: 1500,
    });
    return result.code === 0 && result.stdout.trim()
      ? result.stdout.trim()
      : null;
  }
  async function ensureInsideRealRoot(root: string, target: string) {
    const realRoot = await realpath(root);
    let parent = dirname(target);
    while (true) {
      try {
        await access(parent, constants.F_OK);
        break;
      } catch {
        const next = dirname(parent);
        if (next === parent) throw new Error("Cannot resolve export parent");
        parent = next;
      }
    }
    const realParent = await realpath(parent);
    const rel = relative(realRoot, realParent);
    if (
      rel === ".." ||
      rel.startsWith(`..${process.platform === "win32" ? "\\" : "/"}`)
    )
      throw new Error("Export path escapes the repository through a symlink");
    try {
      const info = await stat(target);
      if (info.isSymbolicLink())
        throw new Error("Export target may not be a symlink");
      const realTarget = await realpath(target);
      const targetRel = relative(realRoot, realTarget);
      if (
        targetRel === ".." ||
        targetRel.startsWith(`..${process.platform === "win32" ? "\\" : "/"}`)
      )
        throw new Error("Export target escapes the repository");
    } catch (error) {
      if (
        !(
          error &&
          typeof error === "object" &&
          "code" in error &&
          error.code === "ENOENT"
        )
      )
        throw error;
    }
  }
  async function exportDecisions(
    requested: string,
    confirmed: boolean,
    ctx: ExtensionContext,
  ) {
    const root = await repositoryRoot();
    if (!root) {
      output(ctx, "Decision export requires a Git repository", "error");
      return;
    }
    try {
      const target = resolveExportPath(root, requested || "DECISIONS.md");
      await ensureInsideRealRoot(root, target);
      let existing = "";
      try {
        existing = await readFile(target, "utf8");
      } catch (error) {
        if (
          !(
            error &&
            typeof error === "object" &&
            "code" in error &&
            error.code === "ENOENT"
          )
        )
          throw error;
      }
      const managed = renderDecisionsMarkdown(decisions.values());
      const hasManaged =
        existing.includes(START_MARKER) && existing.includes(END_MARKER);
      if (existing.trim() && !hasManaged && !confirmed) {
        if (
          ctx.mode !== "tui" ||
          !ctx.hasUI ||
          !(await ctx.ui.confirm(
            "Export decisions",
            `Append a managed section to ${relative(root, target)}?`,
          ))
        ) {
          output(
            ctx,
            "Existing unrelated content not changed; rerun with --confirm in headless mode",
            "warning",
          );
          return;
        }
      }
      await replaceFileAtomically(
        target,
        updateManagedSection(existing, managed),
      );
      output(ctx, `Exported decisions to ${relative(root, target)}`);
    } catch (error) {
      output(
        ctx,
        error instanceof Error ? error.message : String(error),
        "error",
      );
    }
  }

  async function handle(args: string, ctx: ExtensionContext) {
    const parsed = splitCommand(args);
    if (!parsed.action) {
      if (ctx.mode !== "tui" || !ctx.hasUI) {
        output(ctx, USAGE);
        return;
      }
      const action = await ctx.ui.select("Decision log", [
        "add",
        "list",
        "status",
        "export",
      ]);
      if (action) await handle(action, ctx);
      return;
    }
    if (parsed.action === "add" || parsed.action === "propose") {
      const fields = parsed.rest
        ? { summary: parsed.rest }
        : await collect(ctx);
      if (!fields) {
        if (!parsed.rest && ctx.mode !== "tui")
          output(
            ctx,
            `${parsed.action} requires a summary in headless mode`,
            "error",
          );
        return;
      }
      try {
        const target = supersededTarget(fields.supersedes);
        const decision = await makeDecision(
          ctx,
          { ...fields, supersedes: target?.id },
          parsed.action === "add" ? "accepted" : "proposed",
          "user",
        );
        if (decision.status === "accepted") acceptDecision(decision, ctx);
        else append({ version: 1, kind: "upsert", decision }, ctx);
        output(ctx, render(decision));
      } catch (error) {
        output(
          ctx,
          error instanceof Error ? error.message : String(error),
          "error",
        );
      }
      return;
    }
    if (parsed.action === "list") {
      const all = /(?:^|\s)--all(?:\s|$)/.test(args);
      const items = all
        ? [...decisions.values()].sort((a, b) =>
            a.createdAt.localeCompare(b.createdAt),
          )
        : activeDecisions(decisions);
      output(
        ctx,
        items.length
          ? items
              .map(
                (decision) =>
                  `[${displayId(decision)}] ${decision.status}: ${decision.summary}`,
              )
              .join("\n")
          : "No decisions",
      );
      return;
    }
    if (parsed.action === "status") {
      const counts = decisionCounts(decisions);
      output(
        ctx,
        `Decisions: ${counts.count} active (${counts.acceptedCount} accepted, ${counts.proposedCount} proposed)`,
      );
      return;
    }
    const [prefix = "", ...tail] = parsed.rest.split(/\s+/);
    if (parsed.action === "show") {
      const decision = find(prefix, ctx);
      if (decision) output(ctx, render(decision));
      return;
    }
    if (parsed.action === "accept")
      return mutateStatus(prefix, "accepted", ctx);
    if (parsed.action === "reject")
      return mutateStatus(prefix, "rejected", ctx, tail.join(" "));
    if (parsed.action === "edit") {
      const current = find(prefix, ctx);
      if (!current) return;
      const fields = await collect(ctx, current);
      if (!fields) {
        if (ctx.mode !== "tui")
          output(ctx, "Editing requires TUI mode", "error");
        return;
      }
      try {
        const target =
          fields.supersedes === current.supersedes
            ? undefined
            : supersededTarget(fields.supersedes);
        const updated = {
          ...current,
          ...fields,
          supersedes: target?.id ?? current.supersedes,
          updatedAt: new Date().toISOString(),
        };
        append({ version: 1, kind: "upsert", decision: updated }, ctx);
        output(ctx, render(updated));
      } catch (error) {
        output(
          ctx,
          error instanceof Error ? error.message : String(error),
          "error",
        );
      }
      return;
    }
    if (parsed.action === "supersede") {
      const current = find(prefix, ctx);
      if (!current) return;
      const fields = await collect(ctx);
      if (!fields) {
        if (ctx.mode !== "tui")
          output(ctx, "Superseding requires TUI mode", "error");
        return;
      }
      const replacement = await makeDecision(
        ctx,
        { ...fields, supersedes: current.id },
        "accepted",
        "user",
      );
      acceptDecision(replacement, ctx);
      output(
        ctx,
        `${displayId(current)} superseded by ${displayId(replacement)}`,
      );
      return;
    }
    if (parsed.action === "delete") {
      const current = find(prefix, ctx);
      if (!current) return;
      if (!parsed.confirmed) {
        if (
          ctx.mode !== "tui" ||
          !ctx.hasUI ||
          !(await ctx.ui.confirm("Delete decision", current.summary))
        ) {
          output(
            ctx,
            "Deletion cancelled; use --confirm in headless mode",
            "warning",
          );
          return;
        }
      }
      return mutateStatus(current.id, "deleted", ctx);
    }
    if (parsed.action === "export")
      return exportDecisions(parsed.rest, parsed.confirmed, ctx);
    output(ctx, USAGE, "error");
  }

  pi.registerCommand("decision", {
    description: "Record and manage durable decisions",
    handler: handle,
  });
  pi.registerTool({
    name: "propose_decision",
    label: "Propose Decision",
    description:
      "Capture a consequential decision once the conversation clearly settles it. Include the deciding context and rationale. Infer supersedes from the supplied active-decision list; never guess an ID. Do not capture brainstorming, routine implementation details, or duplicates. The extension records capture time and requires user confirmation.",
    parameters: Type.Object({
      summary: Type.String({ minLength: 1 }),
      context: Type.Optional(Type.String()),
      rationale: Type.Optional(Type.String()),
      alternatives: Type.Optional(Type.Array(Type.String())),
      consequences: Type.Optional(Type.Array(Type.String())),
      tags: Type.Optional(Type.Array(Type.String())),
      supersedes: Type.Optional(
        Type.String({
          description: "Existing short decision ID, for example D2",
        }),
      ),
    }),
    async execute(_toolCallId, params, signal, _onUpdate, ctx) {
      if (signal?.aborted) throw new Error("Cancelled");
      const target = supersededTarget(params.supersedes);
      let decision = await makeDecision(
        ctx,
        { ...params, supersedes: target?.id },
        "proposed",
        "agent",
      );
      if (ctx.mode === "tui" && ctx.hasUI) {
        while (true) {
          const choice = await ctx.ui.select(
            `Decision detected\n\n${render(decision)}`,
            ["Accept", "Edit", "Ignore"],
          );
          if (!choice || choice === "Ignore")
            return {
              content: [
                {
                  type: "text",
                  text: "Decision ignored; do not propose it again",
                },
              ],
              details: { ignored: true },
            };
          if (choice === "Edit") {
            const fields = await collect(ctx, {
              ...decision,
              supersedes: decision.supersedes
                ? decisionAlias(decisions, decision.supersedes)
                : undefined,
            });
            if (!fields) continue;
            const editedTarget = supersededTarget(fields.supersedes);
            decision = {
              ...decision,
              ...fields,
              supersedes: editedTarget?.id,
            };
            continue;
          }
          acceptDecision(decision, ctx);
          decision = { ...decision, status: "accepted" };
          break;
        }
      } else append({ version: 1, kind: "upsert", decision }, ctx);
      return {
        content: [
          {
            type: "text",
            text: `Decision ${displayId(decision)} kept as ${decision.status}`,
          },
        ],
        details: {
          id: decision.id,
          displayId: displayId(decision),
          status: decision.status,
        },
      };
    },
  });
  pi.on("before_agent_start", async (event) => {
    const accepted = activeDecisions(decisions).filter(
      (decision) => decision.status === "accepted",
    );
    const visible = accepted.slice(-20);
    const list = visible.length
      ? visible
          .map((decision) => `${displayId(decision)} — ${decision.summary}`)
          .join("\n")
      : "None.";
    const omitted = accepted.length - visible.length;
    return {
      systemPrompt: `${event.systemPrompt}\n\nDECISION CAPTURE\nWhen the conversation clearly settles a consequential architectural, product, or workflow choice, proactively call propose_decision once. Include the deciding context and rationale. Do not capture brainstorming, routine implementation details, or duplicates. Infer supersedes only from the active accepted decisions below; omit it when none clearly conflicts. The extension supplies the capture time and asks the user to Accept, Edit, or Ignore.\n\nActive accepted decisions:\n${list}${omitted > 0 ? `\n(${omitted} older decisions omitted; do not guess their IDs.)` : ""}`,
    };
  });
  pi.registerEntryRenderer<DecisionEvent>(
    DECISION_ENTRY_TYPE,
    (entry, { expanded }, theme) => {
      if (!entry.data || entry.data.version !== 1) return undefined;
      const item =
        entry.data.kind === "upsert"
          ? entry.data.decision
          : entry.data.decisions.at(-1);
      if (!item) return undefined;
      const color =
        item.status === "accepted"
          ? "success"
          : item.status === "proposed"
            ? "warning"
            : "muted";
      let text = theme.fg(
        color,
        `[${decisionAlias(decisions, item.id)}] ${item.status}: ${item.summary}`,
      );
      if (expanded)
        text += `${item.rationale ? `\nRationale: ${item.rationale}` : ""}${item.alternatives?.length ? `\nAlternatives: ${item.alternatives.join("; ")}` : ""}${item.consequences?.length ? `\nConsequences: ${item.consequences.join("; ")}` : ""}`;
      return textComponent(text);
    },
  );
  function reconstruct(ctx: ExtensionContext) {
    decisions = replayDecisions(
      ctx.sessionManager.getBranch() as SessionEntry[],
    );
    publish(ctx);
  }
  pi.on("session_start", (_event, ctx) => {
    currentContext = ctx;
    reconstruct(ctx);
  });
  pi.on("session_tree", (_event, ctx) => {
    currentContext = ctx;
    reconstruct(ctx);
  });
  const offWorkflow = pi.events.on("workflow:preset-changed", (value) => {
    if (!value || typeof value !== "object") return;
    const name = (value as { name?: unknown }).name;
    workflowPreset = typeof name === "string" ? name : null;
  });
  const offStateRequest = pi.events.on("herdr-companion:request-state", () => {
    if (currentContext) publish(currentContext);
  });
  pi.on("session_shutdown", () => {
    offWorkflow();
    offStateRequest();
    if (currentContext) currentContext.ui.setStatus("decision-log", undefined);
    currentContext = null;
  });
}
