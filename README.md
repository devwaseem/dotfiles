# Dotfiles (nix-darwin + Home Manager)

This repository defines a complete macOS development environment using:

- `nix-darwin` for system-level configuration
- `home-manager` for user-level tools and shell/editor setup
- `sops-nix` for encrypted secrets
- a modular Neovim config powered by `lazy.nvim`

It is currently tailored for an Apple Silicon Mac and a single user (`waseemakram`), but it is straightforward to adapt.

## What this config manages

- macOS defaults (Dock, Finder, keyboard repeat, Touch ID for `sudo`)
- Homebrew taps/brews/casks and App Store apps
- CLI tools (`gh`, `bun`, `uv`, `tmux`, `ripgrep`, `fd`, etc.)
- Shell tooling (`zsh`, `oh-my-zsh`, `fzf`, `zoxide`, `atuin`, `starship`)
- Tmux and Lazygit configuration
- AeroSpace window manager config
- Opencode configuration and MCP providers (Exa + Context7)
- Neovim setup with LSP, Telescope, Treesitter, Git, AI, DAP/testing plugins

## Repository layout

- `flake.nix` - flake inputs/outputs and `darwinConfigurations`
- `darwin.nix` - system packages and macOS/nix-darwin options
- `home.nix` - user packages, shell/session vars, Home Manager programs
- `home/*.nix` - modular program configs (`zsh`, `tmux`, `starship`, etc.)
- `secrets.yaml` - encrypted secrets consumed by `sops-nix`
- `.sops.yaml` - SOPS creation rules (Age recipients)
- `nvim/` - Neovim configuration (Lua modules + plugin specs)

## Prerequisites

1. macOS (Apple Silicon recommended; this config targets `aarch64-darwin`)
2. [Nix](https://nixos.org/download/)
3. [nix-darwin](https://github.com/nix-darwin/nix-darwin)
4. [Homebrew](https://brew.sh/) (enabled and managed by nix-darwin)
5. [SOPS](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age)

## Quick start

### 1) Clone in the expected location

This repo assumes the path `~/dotfiles` in a few places (for example, Neovim is linked from `${homeDir}/dotfiles/nvim`).

```bash
git clone https://github.com/devwaseem/dotfiles ~/dotfiles
cd ~/dotfiles
```

### 2) Adapt identity and host settings

Before applying, update these values to match your machine/user:

- `flake.nix`
  - `darwinConfigurations."Waseems-MacBook-Air"`
  - `users.users.waseemakram.home`
- `darwin.nix`
  - `user = "waseemakram";`
- `home.nix`
  - `username = "waseemakram";`

### 3) Configure secrets with SOPS

This repo expects these secret keys in `secrets.yaml`:

- `exa_api_key`
- `context7_api_key`
- `bw_session`

Generate/import an Age key, then either:

- replace the recipient in `.sops.yaml`, or
- add your recipient and re-encrypt `secrets.yaml`.

Example workflow:

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# edit .sops.yaml recipient(s), then edit secrets
sops secrets.yaml
```

### 4) Apply configuration

```bash
sudo darwin-rebuild switch --flake .#<your-hostname>
```

If successful, open a new shell session so all managed environment changes take effect.

## Neovim notes

- Entry point is `nvim/init.lua`.
- Plugins are organized by domain under `nvim/lua/plugins/*`.
- LSP server configs are in `nvim/lsp/*.lua` and enabled from `nvim/lua/core/lsp.lua`.
- `lazy.nvim` bootstraps itself on first launch.

## Common commands

- Rebuild and switch:

  ```bash
  sudo darwin-rebuild switch --flake .#<your-hostname>
  ```

- Build without switching:

  ```bash
  darwin-rebuild build --flake .#<your-hostname>
  ```

- Edit secrets:

  ```bash
  sops secrets.yaml
  ```

## Troubleshooting

- If `darwin-rebuild` fails on SOPS secrets, verify:
  - `~/.config/sops/age/keys.txt` exists
  - recipient in `.sops.yaml` matches your key
  - `secrets.yaml` is encrypted for that recipient
- If Neovim config does not load, confirm repo path is `~/dotfiles` or update the symlink path in `home.nix`.
- If Homebrew apps do not appear immediately, run `darwin-rebuild switch` again after fixing brew-specific errors.

## Security

- Do not commit plaintext secrets.
- Keep `secrets.yaml` encrypted with SOPS.
- Rotate API/session tokens periodically.
