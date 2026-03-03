# AGENTS.md

Guidance for coding agents working in this repository.

## Scope and Priority

- This is a personal dotfiles repo centered on `nix-darwin`, `home-manager`, and Neovim Lua config.
- Prefer minimal, targeted edits; avoid broad refactors unless asked.
- Keep existing patterns and file layout intact.
- Do not rotate secrets or rewrite encrypted files unless explicitly requested.

## Rule Files (Cursor/Copilot)

- Checked for `.cursorrules`: not found.
- Checked for `.cursor/rules/`: not found.
- Checked for `.github/copilot-instructions.md`: not found.
- If any of these files are added later, treat them as higher-priority repo instructions.

## Repository Map

- `flake.nix`, `darwin.nix`, `home.nix`: system/home-manager entry points.
- `home/*.nix`: module-level Home Manager config (zsh, tmux, starship, aerospace, etc.).
- `home/opencode/default.nix`: OpenCode config exposed via Home Manager.
- `nvim/`: Neovim config (Lua modules, plugin specs, colors, ftplugins).
- `secrets.yaml`, `.sops.yaml`: SOPS-managed secrets and policy.

## Setup and Build Commands

- Primary build target is Darwin system config from flake host `Waseems-MacBook-Air`.
- Build (no switch):
- `darwin-rebuild build --flake .#Waseems-MacBook-Air`
- Apply config:
- `sudo darwin-rebuild switch --flake .#Waseems-MacBook-Air`
- Fast alias used by repo owner (from zsh config):
- `ndrs` (expands to `sudo darwin-rebuild switch --flake .`)
- Validate flake structure:
- `nix flake show`
- Evaluate/check flake:
- `nix flake check --show-trace`

## Secrets Workflow (SOPS)

- Secrets live in `secrets.yaml` and are encrypted with SOPS (age).
- Never paste decrypted secret values into commits, logs, PR descriptions, or chat.
- Edit secrets with SOPS so encryption metadata stays valid:
- `sops secrets.yaml`
- Add/update keys as top-level fields (for example `my_service_token`).
- Keep `.sops.yaml` policy intact unless explicitly asked to change key management.
- When wiring secrets into Home Manager, reference `config.sops.secrets.<name>.path` instead of hardcoding values.
- If a new secret is added to `secrets.yaml`, also add a corresponding entry under `sops.secrets` in `home.nix`.
- Do not hand-edit SOPS `mac`, `age`, or ciphertext blocks.

## Lint and Format Commands

- There is no single root lint script; linting/formatting is mostly editor-driven.
- Neovim formatter configuration is in `nvim/lua/plugins/lsp/conform.lua`.
- Format current buffer in Neovim:
- `:Format` or `<leader>lf`
- Format on save is enabled unless disabled with `:FormatDisable`.
- Filetype formatter mapping (from Conform):
- Lua: `stylua`
- Python: `ruff_format` then `ruff_fix`
- JavaScript/TypeScript/Astro: `prettierd` or `prettier`
- HTML/htmldjango: `djlint` (or prettier fallback for html)
- SQL: `sqruff` then `pg_format`
- JSON/JQ: `jq`
- Linting in Neovim is configured in `nvim/lua/plugins/lsp/nvim-lint.lua`.
- Key linter mapping examples:
- Python: `mypy`, `bandit`
- JS/TS/React: `eslint_d`
- HTML Django: `djlint`
- Shell: `shellcheck`
- Manual lint trigger in Neovim:
- `<leader>ll`

## Test Commands

- No dedicated root CI test suite was found in this repo.
- Testing support in Neovim is configured via `neotest` + `neotest-python`.
- Runner is `pytest` with interpreter `.venv/bin/python` (see `nvim/lua/plugins/testing/neotest.lua`).

### Run all tests

- `pytest`

### Run tests in one file

- `pytest path/to/test_file.py`

### Run a single test (important)

- `pytest path/to/test_file.py::test_name`
- If matching neotest defaults is needed:
- `pytest path/to/test_file.py::test_name --color=yes --strict-markers --strict-config --tb=short --no-cov`

### Run by keyword expression

- `pytest -k "keyword"`

### Neovim test keymaps

- Nearest test: `<leader>rc`
- Current file tests: `<leader>rf`
- Nearest test with DAP: `<leader>rC`
- Current file tests with DAP: `<leader>rF`
- Stop running test: `<leader>rs`
- Toggle output panel: `<leader>ro`

## Style Guidelines

## General

- Prefer small, composable changes.
- Preserve existing idioms per language/module.
- Do not introduce new tooling unless requested.
- Keep comments sparse and useful; avoid obvious comments.
- Avoid committing secrets or plaintext tokens.

## Nix Style

- Use 2-space indentation.
- Keep function headers in the form `{ pkgs, config, ... }:`.
- Keep attribute sets sorted/grouped logically (system, programs, imports, etc.).
- End Nix statements with semicolons.
- Use `let ... in` for shared values (for example `username`, `homeDir`).
- Prefer explicit package names in lists; avoid clever dynamic generation unless needed.
- Keep inline comments concise and operational.

## Lua Style (Neovim)

- Use 4-space indentation.
- Keep plugin spec modules returning a single table (`return { ... }`).
- Put `require(...)` locals near the top of the module.
- Prefer local variables/functions over globals.
- Use trailing commas in multiline tables.
- Keep keymap definitions close to feature config.
- Prefer descriptive local names (`on_attach`, `enabled_servers`, `capabilities`).
- Use `snake_case` for locals/functions and lowercase module names.

## Imports and Dependencies

- Nix: include only required attrs in lambda args; keep `...` when module extensibility is needed.
- Lua: use `require('module.path')` consistently; cache with `local x = require(...)` if reused.
- For optional plugins/modules, guard imports with `pcall(require, "...")`.

## Types and Contracts

- Nix has no static types here; rely on clear option names and module boundaries.
- In Lua, encode contracts through clear table shapes and option keys.
- Prefer explicit field names over positional assumptions in config tables.

## Naming Conventions

- Nix variables: `camelCase` or concise lowercase names already used in file.
- Lua locals/functions: `snake_case`.
- Module filenames:
- Nix modules: lowercase names like `zsh.nix`, `tmux.nix`.
- Lua plugin modules may use hyphenated filenames where ecosystem names include hyphens.
- Keymap description strings should be action-oriented and short.

## Error Handling and Safety

- Lua optional dependency handling should use `pcall` before calling plugin APIs.
- Provide sensible fallback behavior when optional plugins are absent.
- Avoid hard failures in startup paths for optional tooling.
- In shell snippets, fail fast for dangerous operations; avoid destructive defaults.
- In Nix changes, prefer `darwin-rebuild build` before `switch` when possible.

## Secrets and Sensitive Data

- Secrets are managed via SOPS (`secrets.yaml`, `.sops.yaml`).
- Never hardcode API keys/tokens in committed files.
- Prefer reading secrets from `config.sops.secrets.*.path` in Home Manager.
- Treat backup/example config files that may contain tokens as sensitive; do not propagate values.
- Avoid editing `opencode-bk/opencode.json` with plaintext keys; use env-backed values in managed configs.

## Validation Checklist for Agents

- Run `nix flake check --show-trace` after Nix changes.
- Run `darwin-rebuild build --flake .#Waseems-MacBook-Air` for system-level edits.
- For Neovim Lua edits, open Neovim and ensure startup has no Lua errors.
- If touching testing config, verify at least one `pytest` invocation (single-test command preferred).
- Summarize changed files and any commands not run.

## Commit Guidance

- Keep commits scoped (Nix system vs Neovim vs shell docs).
- Use imperative commit subjects.
- Mention user-visible behavior changes and risk areas in body when relevant.
- Do not include unrelated formatting churn.
