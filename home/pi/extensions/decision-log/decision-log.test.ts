import assert from "node:assert/strict";
import {
  chmod,
  mkdtemp,
  readFile,
  rm,
  stat,
  writeFile,
} from "node:fs/promises";
import os from "node:os";
import { join } from "node:path";
import test from "node:test";
import { replaceFileAtomically } from "./atomic.ts";
import { parseDecisionTemplate } from "./commands.ts";
import {
  END_MARKER,
  renderDecisionsMarkdown,
  resolveExportPath,
  START_MARKER,
  updateManagedSection,
} from "./markdown.ts";
import {
  decisionAlias,
  decisionAliases,
  decisionCounts,
  DECISION_ENTRY_TYPE,
  replayDecisions,
  resolveDecisionPrefix,
} from "./store.ts";
import type { Decision, DecisionEvent } from "./types.ts";

function decision(
  id: string,
  status: Decision["status"] = "accepted",
): Decision {
  return {
    id,
    status,
    summary: `Decision ${id}`,
    createdAt: "2026-01-01T00:00:00.000Z",
    updatedAt: "2026-01-01T00:00:00.000Z",
    source: "user",
  };
}
function entry(event: DecisionEvent) {
  return { type: "custom", customType: DECISION_ENTRY_TYPE, data: event };
}

test("parses the structured editor template defensively", () => {
  assert.deepEqual(
    parseDecisionTemplate(
      "Summary: Keep it small\nAlternatives:\n- Big\n- Bigger\nTags: architecture, pi",
    ),
    {
      summary: "Keep it small",
      context: undefined,
      rationale: undefined,
      alternatives: ["Big", "Bigger"],
      consequences: undefined,
      tags: ["architecture", "pi"],
      supersedes: undefined,
    },
  );
  assert.throws(() => parseDecisionTemplate("Context: none"), /required/);
  assert.equal(
    parseDecisionTemplate("Summary: old\nDecision: edited").summary,
    "edited",
  );
  assert.throws(
    () => parseDecisionTemplate("Summary: stale\nDecision:"),
    /Decision is required/,
  );
});
test("replays updates, transactions and tombstones on the supplied branch", () => {
  const first = decision("abc111");
  const replacement = { ...decision("def222"), supersedes: first.id };
  const old = {
    ...first,
    status: "superseded" as const,
    supersededBy: replacement.id,
  };
  const activeBranch = [
    entry({ version: 1, kind: "upsert", decision: first }),
    entry({ version: 1, kind: "transaction", decisions: [old, replacement] }),
  ];
  const state = replayDecisions(activeBranch);
  assert.equal(state.get(first.id)?.supersededBy, replacement.id);
  assert.equal(state.get(replacement.id)?.supersedes, first.id);
  const deleted = { ...replacement, status: "deleted" as const };
  assert.equal(
    replayDecisions([
      ...activeBranch,
      entry({ version: 1, kind: "upsert", decision: deleted }),
    ]).get(replacement.id)?.status,
    "deleted",
  );
  assert.equal(
    replayDecisions(activeBranch).get(replacement.id)?.status,
    "accepted",
  );
});
test("resolves short aliases and legacy ID prefixes", () => {
  const first = decision("abc111");
  const second = {
    ...decision("abc222", "deleted"),
    createdAt: "2026-01-02T00:00:00.000Z",
  };
  const third = {
    ...decision("def333"),
    createdAt: "2026-01-03T00:00:00.000Z",
  };
  const state = new Map([
    [first.id, first],
    [second.id, second],
    [third.id, third],
  ]);
  assert.deepEqual(
    [...decisionAliases(state.values()).values()],
    ["D1", "D2", "D3"],
  );
  assert.equal(decisionAlias(state, third.id), "D3");
  assert.equal(resolveDecisionPrefix(state, "d3").id, third.id);
  assert.equal(resolveDecisionPrefix(state, "abc1").id, first.id);
  assert.throws(() => resolveDecisionPrefix(state, "abc"), /Ambiguous/);
  assert.throws(() => resolveDecisionPrefix(state, "D4"), /Unknown/);
});
test("counts active decisions and emits latest data", () => {
  const proposed = decision("p", "proposed");
  const accepted = { ...decision("a"), updatedAt: "2026-01-02T00:00:00.000Z" };
  const counts = decisionCounts(
    new Map([
      ["p", proposed],
      ["a", accepted],
      ["d", decision("d", "deleted")],
    ]),
  );
  assert.deepEqual(counts, {
    count: 2,
    proposedCount: 1,
    acceptedCount: 1,
    latestId: "a",
    latestSummary: "Decision a",
  });
});
test("renders deterministic idempotent managed Markdown", () => {
  const rendered = renderDecisionsMarkdown([
    decision("b", "rejected"),
    decision("a"),
  ]);
  assert.equal(
    rendered,
    renderDecisionsMarkdown([decision("a"), decision("b", "rejected")]),
  );
  const once = updateManagedSection("# Project\n", rendered);
  const twice = updateManagedSection(once, rendered);
  assert.equal(once, twice);
  assert.equal((twice.match(new RegExp(START_MARKER, "g")) ?? []).length, 1);
  assert.equal((twice.match(new RegExp(END_MARKER, "g")) ?? []).length, 1);
  assert.throws(
    () => updateManagedSection(`${START_MARKER}\nunrelated`, rendered),
    /malformed/,
  );
  assert.throws(
    () =>
      updateManagedSection(
        `${START_MARKER}\n${START_MARKER}\n${END_MARKER}`,
        rendered,
      ),
    /malformed/,
  );
});
test("atomic replacement preserves existing file permissions", {
  skip: process.platform === "win32",
}, async () => {
  const dir = await mkdtemp(join(os.tmpdir(), "decision-log-"));
  const target = join(dir, "DECISIONS.md");
  try {
    await writeFile(target, "old", { mode: 0o600 });
    await chmod(target, 0o600);
    await replaceFileAtomically(target, "new");
    assert.equal(await readFile(target, "utf8"), "new");
    assert.equal((await stat(target)).mode & 0o777, 0o600);
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
});
test("rejects export traversal and absolute paths", () => {
  assert.equal(
    resolveExportPath("/repo", "docs/DECISIONS.md"),
    "/repo/docs/DECISIONS.md",
  );
  assert.throws(() => resolveExportPath("/repo", "../outside.md"), /inside/);
  assert.throws(() => resolveExportPath("/repo", "/tmp/out.md"), /relative/);
});
