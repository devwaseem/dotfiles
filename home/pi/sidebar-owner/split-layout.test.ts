import assert from "node:assert/strict";
import test from "node:test";
import { splitSidebarWidth } from "./split-layout.ts";

test("uses 45% while preserving room for the main chat", () => {
  assert.equal(splitSidebarWidth(120), 54);
  assert.equal(splitSidebarWidth(80), 36);
  assert.equal(splitSidebarWidth(60), 20);
});
