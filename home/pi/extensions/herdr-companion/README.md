# Herdr Companion

Metadata-only companion for Herdr's managed Pi integration. It never imports, wraps or replaces `herdr-agent-state.ts`, and never reports agent state or session authority.

The extension is a silent no-op unless `HERDR_ENV=1`, `HERDR_SOCKET_PATH` and `HERDR_PANE_ID` are present and Pi is in TUI mode. When active it sends bounded, debounced, deduplicated `pane.report_metadata` requests from `herdr:pi-companion`, applying them to `herdr:pi`.

Metadata is allowlisted to session name/project fallback, display agent, model, thinking, workflow mode, project basename, Git branch/state and active decision count. Prompts, file contents, tool inputs, command output and environment values are never serialized. Git checks are read-only, cached and triggered by relevant activity rather than polling.

Commands: `/herdr-companion status` and `/herdr-companion refresh`. One request is sent per connection with bounded timeout and one transient retry. Pending timers, event listeners and sockets are cleaned up on session shutdown; previously published metadata is cleared best-effort.
