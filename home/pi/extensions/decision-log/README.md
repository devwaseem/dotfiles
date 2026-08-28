# Decision Log

Pi automatically proposes consequential decisions when the conversation settles them. The proposal includes context, rationale, capture time, and any clearly superseded active decision. In TUI mode, choose **Accept**, **Edit**, or **Ignore**; ignored proposals are not stored. Headless proposals remain proposed for later review.

Decisions use branch-local short IDs such as `D1`; legacy internal IDs still work. Accepted replacements atomically mark the previous decision as superseded. State remains branch-aware in immutable Pi custom session entries, with no external database.

## Commands

- `/decision` — compact TUI action selector; usage in headless modes.
- `/decision add [summary]` — accepted user decision.
- `/decision propose <summary>` — proposed user decision.
- `/decision list [--all]`, `/decision show <id>`, `/decision status`
- `/decision accept|reject|edit|supersede|delete <id>`
- `/decision delete <id> --confirm` — required outside TUI.
- `/decision export [relative/path.md] [--confirm]` — atomically updates a marked section; defaults to repository `DECISIONS.md`.

`propose_decision` is called proactively by the model only after a consequential choice is clear. It cannot silently accept one. Manual `/decision add` remains available as a fallback.

Edits, status changes, supersession and deletion append new events. Deletion is a tombstone. Replay uses only Pi's active session branch, so resume, fork, clone and tree navigation reconstruct the correct state. Export excludes deleted decisions and keeps rejected/superseded records in history.
