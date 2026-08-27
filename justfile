set shell := ["zsh", "-eu", "-o", "pipefail", "-c"]

default:
    @just --list

# Format Nix files using the flake formatter.
fmt:
    nix fmt

# Run the reproducible lint checks used by CI and agents.
lint:
    nix flake check

check: lint

# Build the Darwin configuration without activating it.
build:
    darwin-rebuild build --flake .#Waseems-MacBook-Air

# Install the generated pre-commit hook for this repository.
install-hooks:
    git config --local --unset-all core.hooksPath || true
    nix develop -c pre-commit install --install-hooks

# Apply the Darwin configuration.
switch:
    sudo darwin-rebuild switch --flake .#Waseems-MacBook-Air
