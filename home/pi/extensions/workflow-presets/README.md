# Workflow Presets

Named Pi workflows with session-persisted model, thinking, tools and per-turn instructions.

## Commands

- `/plan`, `/build`, `/review`, `/fast`, `/deep` — activate a built-in preset directly.
- `/wf` — short TUI selector.
- `/woff` — restore the settings captured before workflow activation.
- `/workflow` — full TUI selector; prints usage in headless modes.
- `/workflow list|status`
- `/workflow plan|build|review|fast|deep`
- `/workflow off` — restore the model, thinking level and tools captured before the first activation.

Global presets come from `~/.pi/agent/presets.json`; trusted projects may override names in `.pi/presets.json`. Invalid entries warn without preventing startup. Configured tools are intersected with Pi's registered tools.

Plan and review disable `write` and `edit` and reject clearly modifying `bash` commands. This is a workflow guard, **not a security sandbox**: shell syntax is too broad to secure with pattern matching.

Explicit model or thinking changes made while a workflow is active become session-persisted overrides. Switching workflows applies the new workflow settings; `off` always restores the original snapshot. Instructions are injected into the system prompt for each turn and are not stored as repeated conversation messages.

Direct aliases are intentionally limited to built-in presets; project-defined presets remain available through `/workflow <name>`.
