import assert from "node:assert/strict";
import { mkdtemp, rm } from "node:fs/promises";
import net from "node:net";
import os from "node:os";
import { join } from "node:path";
import test from "node:test";
import { sendHerdrRequest, sendRequestAttempt, SocketPool } from "./ipc.ts";
import {
  buildMetadata,
  metadataFingerprint,
  resolveHerdrConfig,
  shouldSendMetadata,
  updateDecisions,
  updateWorkflow,
} from "./metadata.ts";
import type { CompanionState } from "./types.ts";

test("requires all Herdr environment fields and TUI mode", () => {
  assert.equal(resolveHerdrConfig({}, "tui"), null);
  assert.equal(
    resolveHerdrConfig({ HERDR_ENV: "1", HERDR_SOCKET_PATH: "/x" }, "tui"),
    null,
  );
  assert.equal(
    resolveHerdrConfig(
      { HERDR_ENV: "1", HERDR_SOCKET_PATH: "/x", HERDR_PANE_ID: "p" },
      "print",
    ),
    null,
  );
  assert.deepEqual(
    resolveHerdrConfig(
      { HERDR_ENV: "1", HERDR_SOCKET_PATH: "/x", HERDR_PANE_ID: "p" },
      "tui",
      "darwin",
    ),
    { paneId: "p", endpoint: "/x" },
  );
});
test("constructs only allowlisted, normalized metadata", () => {
  const input = {
    paneId: "pane",
    title: "Title\nInjected",
    model: "provider/model",
    thinking: "high",
    mode: "plan",
    project: "repo",
    git: { rootName: "repo", branch: "main", state: "dirty" as const },
    workflow: "plan",
    decisions: 2,
    prompt: "secret",
    arbitraryEnvironment: process.env,
  };
  const params = buildMetadata(input);
  const encoded = JSON.stringify(params);
  assert.equal(params.source, "herdr:pi-companion");
  assert.equal(params.applies_to_source, "herdr:pi");
  assert.equal(params.display_agent, "Pi · plan");
  assert.ok(!encoded.includes("secret"));
  assert.ok(!encoded.includes("arbitraryEnvironment"));
  assert.ok(!params.title.includes("\n"));
  assert.equal(
    metadataFingerprint(params),
    metadataFingerprint(structuredClone(params)),
  );
  assert.equal(
    shouldSendMetadata(metadataFingerprint(params), structuredClone(params)),
    false,
  );
});
test("reacts defensively to workflow and decision events", () => {
  let state: CompanionState = { workflow: null, decisions: 0 };
  state = updateWorkflow(state, { name: "review" });
  state = updateDecisions(state, { count: 3, latestSummary: "must not leak" });
  assert.deepEqual(state, { workflow: "review", decisions: 3 });
  assert.deepEqual(updateDecisions(state, { count: "bad" }), state);
});
test("handles protocol errors and timeouts on a Unix socket", {
  skip: process.platform === "win32",
}, async () => {
  const dir = await mkdtemp(join(os.tmpdir(), "herdr-companion-"));
  const path = join(dir, "socket");
  let mode: "error" | "timeout" = "error";
  const server = net.createServer((socket) =>
    socket.on("data", () => {
      if (mode === "error")
        socket.end(`${JSON.stringify({ error: { code: 1 } })}\n`);
    }),
  );
  await new Promise<void>((resolve) => server.listen(path, resolve));
  try {
    assert.equal(
      await sendRequestAttempt(path, { method: "x" }, 100),
      "protocol_error",
    );
    mode = "timeout";
    assert.equal(
      await sendRequestAttempt(path, { method: "x" }, 20),
      "transient_error",
    );
    assert.equal(
      await sendHerdrRequest(path, { method: "x" }, new SocketPool()),
      false,
    );
  } finally {
    await new Promise<void>((resolve) => server.close(() => resolve()));
    await rm(dir, { recursive: true, force: true });
  }
});
