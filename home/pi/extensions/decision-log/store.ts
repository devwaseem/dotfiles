import type { Decision, DecisionCounts, DecisionEvent } from "./types.ts";

export const DECISION_ENTRY_TYPE = "decision-log-event";
interface EntryLike {
  type?: string;
  customType?: string;
  data?: unknown;
}

function isDecision(value: unknown): value is Decision {
  if (!value || typeof value !== "object") return false;
  const item = value as Partial<Decision>;
  return (
    typeof item.id === "string" &&
    typeof item.summary === "string" &&
    typeof item.status === "string" &&
    typeof item.createdAt === "string" &&
    typeof item.updatedAt === "string" &&
    (item.source === "user" || item.source === "agent")
  );
}
export function isDecisionEvent(value: unknown): value is DecisionEvent {
  if (!value || typeof value !== "object") return false;
  const event = value as Partial<DecisionEvent>;
  if (event.version !== 1) return false;
  if (event.kind === "upsert") return isDecision(event.decision);
  return (
    event.kind === "transaction" &&
    Array.isArray(event.decisions) &&
    event.decisions.every(isDecision)
  );
}
export function replayDecisions(
  entries: readonly EntryLike[],
): Map<string, Decision> {
  const decisions = new Map<string, Decision>();
  for (const entry of entries) {
    if (
      entry.type !== "custom" ||
      entry.customType !== DECISION_ENTRY_TYPE ||
      !isDecisionEvent(entry.data)
    )
      continue;
    const updates =
      entry.data.kind === "upsert"
        ? [entry.data.decision]
        : entry.data.decisions;
    for (const decision of updates)
      decisions.set(decision.id, structuredClone(decision));
  }
  return decisions;
}
export function decisionAliases(
  decisions: Iterable<Decision>,
): Map<string, string> {
  return new Map(
    [...decisions]
      .sort(
        (a, b) =>
          a.createdAt.localeCompare(b.createdAt) || a.id.localeCompare(b.id),
      )
      .map((decision, index) => [decision.id, `D${index + 1}`]),
  );
}
export function decisionAlias(
  decisions: ReadonlyMap<string, Decision>,
  id: string,
): string {
  return decisionAliases(decisions.values()).get(id) ?? id;
}
export function resolveDecisionPrefix(
  decisions: ReadonlyMap<string, Decision>,
  prefix: string,
): Decision {
  const aliases = decisionAliases(decisions.values());
  const alias = [...decisions.values()].find(
    (decision) =>
      aliases.get(decision.id)?.toLowerCase() === prefix.toLowerCase(),
  );
  if (alias) return alias;
  const matches = [...decisions.values()].filter((decision) =>
    decision.id.startsWith(prefix),
  );
  if (matches.length === 0) throw new Error(`Unknown decision ID: ${prefix}`);
  if (matches.length > 1) throw new Error(`Ambiguous decision ID: ${prefix}`);
  return matches[0];
}
export function activeDecisions(
  decisions: ReadonlyMap<string, Decision>,
): Decision[] {
  return [...decisions.values()]
    .filter(
      (decision) =>
        decision.status === "proposed" || decision.status === "accepted",
    )
    .sort(
      (a, b) =>
        a.createdAt.localeCompare(b.createdAt) || a.id.localeCompare(b.id),
    );
}
export function decisionCounts(
  decisions: ReadonlyMap<string, Decision>,
): DecisionCounts {
  const active = activeDecisions(decisions);
  const latest = [...active].sort(
    (a, b) =>
      b.updatedAt.localeCompare(a.updatedAt) || b.id.localeCompare(a.id),
  )[0];
  return {
    count: active.length,
    proposedCount: active.filter((decision) => decision.status === "proposed")
      .length,
    acceptedCount: active.filter((decision) => decision.status === "accepted")
      .length,
    latestId: latest?.id ?? null,
    latestSummary: latest?.summary ?? null,
  };
}
