import assert from "node:assert/strict";
import test from "node:test";
import { replayTodos, todosFromDetails } from "./todo-state.ts";

const details = {
  nextId: 4,
  tasks: [
    { id: 1, subject: "Done", status: "completed" },
    {
      id: 2,
      subject: "Working",
      status: "in_progress",
      activeForm: "working now",
    },
    { id: 3, subject: "Hidden", status: "deleted" },
  ],
};

test("uses rpiv snapshots and hides tombstones", () => {
  assert.deepEqual(todosFromDetails(details), [
    { id: "1", content: "Done", status: "completed" },
    {
      id: "2",
      content: "Working",
      status: "in_progress",
      subAction: "working now",
    },
  ]);
});

test("replays the latest todo snapshot", () => {
  const todos = replayTodos({
    getBranch: () => [
      {
        type: "message",
        message: {
          role: "toolResult",
          toolName: "todo",
          details: { nextId: 1, tasks: [] },
        },
      },
      {
        type: "message",
        message: { role: "toolResult", toolName: "todo", details },
      },
    ],
  });
  assert.equal(todos.length, 2);
  assert.equal(todos[1].content, "Working");
});
