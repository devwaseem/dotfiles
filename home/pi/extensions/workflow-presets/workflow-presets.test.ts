import assert from "node:assert/strict";
import test from "node:test";
import { parsePresetConfig } from "./config.ts";
import {
  adoptUserModelForRestoration,
  canRestoreModel,
  isClearlyModifyingShell,
  replayWorkflowBranch,
  replayWorkflowState,
  WORKFLOW_ENTRY_TYPE,
} from "./state.ts";
import type { WorkflowStateEvent } from "./types.ts";

const state = {
  name: "plan",
  readOnly: true,
  original: {
    modelProvider: "p",
    modelId: "m",
    thinkingLevel: "medium" as const,
    tools: ["read", "edit"],
  },
  effective: {
    modelProvider: "p",
    modelId: "m",
    thinkingLevel: "high" as const,
    tools: ["read"],
  },
};
test("validates presets without rejecting the whole file", () => {
  const result = parsePresetConfig(
    { plan: { thinkingLevel: "high", tools: ["read"] }, bad: 4 },
    "test",
  );
  assert.deepEqual(result.presets.plan.tools, ["read"]);
  assert.equal(result.warnings.length, 1);
});
test("replays supplied active-branch events", () => {
  const activate: WorkflowStateEvent = { version: 1, kind: "activate", state };
  const disable: WorkflowStateEvent = {
    version: 1,
    kind: "disable",
    original: state.original,
  };
  const branch = [
    { type: "custom", customType: WORKFLOW_ENTRY_TYPE, data: activate },
  ];
  assert.equal(replayWorkflowState(branch)?.name, "plan");
  assert.equal(
    replayWorkflowState([
      ...branch,
      { type: "custom", customType: WORKFLOW_ENTRY_TYPE, data: disable },
    ]),
    null,
  );
  assert.deepEqual(
    replayWorkflowBranch([
      ...branch,
      { type: "custom", customType: WORKFLOW_ENTRY_TYPE, data: disable },
    ]).restore,
    state.original,
  );
});
test("rejects model transitions that cannot restore a no-model state", () => {
  const noModel = {
    ...state.original,
    modelProvider: null,
    modelId: null,
  };
  assert.equal(canRestoreModel(noModel, state.effective), false);
  assert.deepEqual(adoptUserModelForRestoration(noModel, state.effective), {
    ...noModel,
    modelProvider: "p",
    modelId: "m",
  });
  assert.equal(canRestoreModel(noModel, noModel), true);
  assert.equal(canRestoreModel(state.original, state.effective), true);
  assert.equal(
    replayWorkflowState([
      {
        type: "custom",
        customType: WORKFLOW_ENTRY_TYPE,
        data: {
          version: 1,
          kind: "disable",
          original: { ...state.original, modelId: null },
        },
      },
    ]),
    null,
  );
});
test("blocks clear writes but permits ordinary inspection", () => {
  for (const command of [
    "rm -rf build",
    "git commit -am x",
    "sed -i '' file",
    "echo x > file",
    "curl -o x URL",
  ]) {
    assert.equal(isClearlyModifyingShell(command), true);
  }
  for (const command of [
    "rg TODO",
    "git status --short",
    "git diff",
    "sed -n '1,5p' file",
    "find . -type f",
  ]) {
    assert.equal(isClearlyModifyingShell(command), false);
  }
});
