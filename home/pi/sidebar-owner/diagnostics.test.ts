// @ts-nocheck — Tests run directly with Node's type stripping.
import assert from "node:assert/strict";
import test from "node:test";
import { DiagnosticState } from "./diagnostics.ts";

const error = {
  severity: "error",
  message: "Missing\nproperty",
  line: 12,
  col: 4,
};

function payload(seq: number, path: string, diagnostics: unknown[]) {
  return {
    v: 1,
    source: "pi-lens",
    seq,
    files: [{ path, diagnostics }],
  };
}

test("replaces diagnostics per file and clears errors", () => {
  const state = new DiagnosticState();
  assert.equal(state.replace(payload(1, "/repo/a.ts", [error])), true);
  assert.equal(state.errorCount, 1);
  assert.equal(state.replace(payload(2, "/repo/a.ts", [])), true);
  assert.equal(state.errorCount, 0);
});

test("ignores stale events and formats errors by file", () => {
  const state = new DiagnosticState();
  state.replace(payload(1, "/repo/b.ts", [error]));
  state.replace(
    payload(2, "/repo/a.ts", [{ ...error, message: "Earlier", line: 3 }]),
  );
  state.replace(payload(1, "/repo/stale.ts", [error]));

  assert.equal(state.errorCount, 2);
  assert.equal(
    state.formatErrors("/repo"),
    "a.ts (1)\n  3:4  Earlier\n\nb.ts (1)\n  12:4  Missing property",
  );
});

test("does not count warnings", () => {
  const state = new DiagnosticState();
  state.replace(
    payload(1, "/repo/a.ts", [
      error,
      { severity: "warning", message: "Unused", line: 3 },
    ]),
  );
  assert.equal(state.errorCount, 1);
});
