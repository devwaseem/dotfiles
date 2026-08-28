import type { Decision } from "./types.ts";

export const DECISION_TEMPLATE = `Decision:
Context:
Rationale:
Alternatives:
Consequences:
Tags:
Supersedes:
`;
const FIELDS = [
  "Summary",
  "Context",
  "Decision",
  "Rationale",
  "Alternatives",
  "Consequences",
  "Tags",
  "Supersedes",
] as const;
type Field = (typeof FIELDS)[number];

function lines(value: string | undefined): string[] | undefined {
  const result = value
    ?.split(/\n|,/)
    .map((item) => item.replace(/^[-*]\s*/, "").trim())
    .filter(Boolean);
  return result?.length ? result : undefined;
}
export function parseDecisionTemplate(
  text: string,
): Pick<
  Decision,
  | "summary"
  | "context"
  | "rationale"
  | "alternatives"
  | "consequences"
  | "tags"
  | "supersedes"
> {
  const fields: Partial<Record<Field, string>> = {};
  let current: Field | undefined;
  for (const line of text.split(/\r?\n/)) {
    const match = line.match(
      /^(Summary|Context|Decision|Rationale|Alternatives|Consequences|Tags|Supersedes):\s*(.*)$/i,
    );
    if (match) {
      current = FIELDS.find(
        (field) => field.toLowerCase() === match[1].toLowerCase(),
      );
      if (current) fields[current] = match[2].trim();
    } else if (current && line.trim())
      fields[current] = `${fields[current] ?? ""}\n${line.trim()}`.trim();
  }
  const summary = (
    Object.hasOwn(fields, "Decision")
      ? (fields.Decision ?? "")
      : (fields.Summary ?? "")
  ).trim();
  if (!summary) throw new Error("Decision is required");
  return {
    summary,
    context: fields.Context?.trim() || undefined,
    rationale: fields.Rationale?.trim() || undefined,
    alternatives: lines(fields.Alternatives),
    consequences: lines(fields.Consequences),
    tags: lines(fields.Tags),
    supersedes: fields.Supersedes?.trim() || undefined,
  };
}
export function decisionTemplate(decision?: Decision): string {
  if (!decision) return DECISION_TEMPLATE;
  const list = (items?: string[]) =>
    items?.map((item) => `- ${item}`).join("\n") ?? "";
  return `Decision: ${decision.summary}\nContext: ${decision.context ?? ""}\nRationale: ${decision.rationale ?? ""}\nAlternatives:\n${list(decision.alternatives)}\nConsequences:\n${list(decision.consequences)}\nTags: ${decision.tags?.join(", ") ?? ""}\nSupersedes: ${decision.supersedes ?? ""}\n`;
}
export function splitCommand(input: string): {
  action: string;
  rest: string;
  confirmed: boolean;
} {
  const confirmed = /(?:^|\s)--(?:confirm|force)(?:\s|$)/.test(input);
  const clean = input
    .replace(/(?:^|\s)--(?:confirm|force)(?=\s|$)/g, " ")
    .trim();
  const [action = "", ...rest] = clean.split(/\s+/);
  return { action: action.toLowerCase(), rest: rest.join(" "), confirmed };
}
