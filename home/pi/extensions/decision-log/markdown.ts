import { isAbsolute, relative, resolve } from "node:path";
import { decisionAliases } from "./store.ts";
import type { Decision } from "./types.ts";

export const START_MARKER = "<!-- pi-decision-log:start -->";
export const END_MARKER = "<!-- pi-decision-log:end -->";
function section(title: string, value?: string | string[]): string {
  if (!value || (Array.isArray(value) && value.length === 0)) return "";
  const text = Array.isArray(value)
    ? value.map((item) => `- ${item}`).join("\n")
    : value;
  return `\n**${title}**\n\n${text}\n`;
}
function renderDecision(
  decision: Decision,
  aliases: ReadonlyMap<string, string>,
): string {
  let text = `### ${aliases.get(decision.id) ?? decision.id} — ${decision.summary}\n\n- Status: ${decision.status}\n- Captured: ${decision.createdAt}\n`;
  if (decision.supersedes)
    text += `- Supersedes: \`${aliases.get(decision.supersedes) ?? decision.supersedes}\`\n`;
  if (decision.supersededBy)
    text += `- Superseded by: \`${aliases.get(decision.supersededBy) ?? decision.supersededBy}\`\n`;
  text +=
    section("Context", decision.context) +
    section("Rationale", decision.rationale) +
    section("Alternatives", decision.alternatives) +
    section("Consequences", decision.consequences) +
    section("Tags", decision.tags);
  return text.trimEnd();
}
export function renderDecisionsMarkdown(decisions: Iterable<Decision>): string {
  const items = [...decisions];
  const aliases = decisionAliases(items);
  const sorted = items
    .filter((decision) => decision.status !== "deleted")
    .sort(
      (a, b) =>
        a.createdAt.localeCompare(b.createdAt) || a.id.localeCompare(b.id),
    );
  const active = sorted.filter(
    (decision) =>
      decision.status === "accepted" || decision.status === "proposed",
  );
  const history = sorted.filter(
    (decision) =>
      decision.status === "rejected" || decision.status === "superseded",
  );
  const group = (items: Decision[]) =>
    items.length
      ? items.map((decision) => renderDecision(decision, aliases)).join("\n\n")
      : "_None._";
  return `${START_MARKER}\n# Decisions\n\n## Active\n\n${group(active)}\n\n## History\n\n${group(history)}\n${END_MARKER}`;
}
export function updateManagedSection(
  existing: string,
  managed: string,
): string {
  const starts = existing.split(START_MARKER).length - 1;
  const ends = existing.split(END_MARKER).length - 1;
  if (starts !== ends || starts > 1)
    throw new Error(
      "Decision export markers are malformed; repair them before exporting",
    );
  const start = existing.indexOf(START_MARKER);
  const end = existing.indexOf(END_MARKER);
  if (start < 0)
    return existing.trim()
      ? `${existing.trimEnd()}\n\n${managed}\n`
      : `${managed}\n`;
  if (end < start)
    throw new Error(
      "Decision export markers are malformed; repair them before exporting",
    );
  return `${existing.slice(0, start)}${managed}${existing.slice(end + END_MARKER.length)}`;
}
export function resolveExportPath(
  root: string,
  requested = "DECISIONS.md",
): string {
  if (!requested || isAbsolute(requested))
    throw new Error("Export path must be relative to the repository root");
  const target = resolve(root, requested);
  const rel = relative(resolve(root), target);
  if (
    rel === ".." ||
    rel.startsWith(`..${process.platform === "win32" ? "\\" : "/"}`)
  )
    throw new Error("Export path must remain inside the repository root");
  return target;
}
