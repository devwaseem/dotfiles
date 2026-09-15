import assert from "node:assert/strict";
import test from "node:test";
import herdrQuestionState from "./index.ts";

test("bridges question waits to Herdr blocked state", () => {
  const previous = process.env["HERDR_ENV"];
  process.env["HERDR_ENV"] = "1";
  const handlers = new Map<string, (value?: unknown) => void>();
  const emitted: Array<[string, unknown]> = [];
  const pi = {
    events: {
      on(name: string, handler: (value?: unknown) => void) {
        handlers.set(name, handler);
        return () => handlers.delete(name);
      },
      emit(name: string, value: unknown) {
        emitted.push([name, value]);
      },
    },
    on(name: string, handler: () => void) {
      handlers.set(name, handler);
    },
  };

  try {
    herdrQuestionState(pi as never);
    handlers.get("rpiv:ask-user:blocked")?.({ active: true });
    handlers.get("rpiv:ask-user:blocked")?.({ active: false });
    assert.deepEqual(emitted, [
      ["herdr:blocked", { active: true, label: "Question" }],
      ["herdr:blocked", { active: false }],
    ]);
  } finally {
    if (previous === undefined) delete process.env["HERDR_ENV"];
    else process.env["HERDR_ENV"] = previous;
  }
});
