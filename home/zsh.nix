{ pkgs, lib, config, ... }:
{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autocd = true;
        completionInit = "autoload -U compinit && compinit";
        history = {
            size = 50000;
            save = 50000;
            path = "$HOME/.config/zsh/history";
            ignoreDups = true;
            share = true;
            extended = true;
        };
        autosuggestion = {
            enable = true;
            strategy = [
                "completion"
                "match_prev_cmd"
                "history"
            ];
        };
        sessionVariables = {
            EDITOR = "nvim";
            LZ_CONFIG_DIR = "$HOME/.config/lazygit/";
            COLORTERM = "truecolor";
            TERM = "xterm-256color";
            ZK_PATH = "$HOME/Zettelkasten";
            BUN_INSTALL = "$HOME/.bun";

            # Secrets
            EXA_API_KEY = "$(cat ${config.sops.secrets.exa_api_key.path})";
            CONTEXT7_API_KEY = "$(cat ${config.sops.secrets.context7_api_key.path})";
        };
        syntaxHighlighting ={
            enable = true;
            patterns = {
                "rm -rf *" = "fg=white,bold,bg=red";
            };
        };
        shellAliases = {
            # General
            zshconfig = "nvim ~/.zshrc";
            reload = "source ~/.zshrc";
            python = "python3";
            cat = "bat";
            grep = "rg";
            find = "fd";

            # Git
            gs = "git status -sb";
            gl = "git log --oneline --graph --decorate -n 20";
            gco = "git checkout";
            gcb = "git checkout -b";
            gwip = "git add -A && git commit -m 'WIP'";
            gundo = "git reset --soft HEAD~1";

            # Python/UV
            venv = "python -m venv .venv";
            va = "source .venv/bin/activate";
            vd = "deactivate";
            uvp = "uv pip";
            uvr = "uv run";
            uvs = "uv sync";
            uvl = "uv lock";
            uvlu = "uv lock --upgrade";

            # K8s
            k = "kubectl";
            kgp = "kubectl get pods";

            # nix darwin-rebuild
            ndrs = "sudo darwin-rebuild switch --flake .";
        };
        shellGlobalAliases = {
            ll = "ls -l";
            la = "ls -la";
            l = "ls -lA";
            c = "clear";
            h = "history";
            UUID = "$(uuidgen | tr -d \\n)";
            G = "| grep";
        };
        dirHashes = {
            docs = "$HOME/Documents";
            work = "$HOME/Work";
            dl = "$HOME/Downloads";
            nix = "$HOME/dotfiles/.nix";
        };
        initContent = let
            nixConfig = lib.mkOrder 500 ''
                export PATH="/etc/profiles/per-user/$USER/bin:$HOME/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH"
                if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
                  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
                fi
            '';
            zshExtraConfig = lib.mkOrder 1500 ''
            pyclean () {
              find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
            }

            function n() { nvim "''${1:-"$(fzf)"}" }

            function y() {
              local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
              yazi "$@" --cwd-file="$tmp"
              IFS= read -r -d ''' cwd < "$tmp"
              [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
              rm -f -- "$tmp"
            }

            # Keybindings
            bindkey -v
            bindkey "^[[A" history-beginning-search-backward
            bindkey "^[[B" history-beginning-search-forward

            # Zstyle completions
            zstyle ':completion:*' menu select
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

            # External Integrations
            [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
            [ -e "$HOME/.iterm2_shell_integration.zsh" ] && source "$HOME/.iterm2_shell_integration.zsh"

            # Path additions
            export PATH="$HOME/.local/bin:$HOME/.spicetify:$PNPM_HOME:$BUN_INSTALL/bin:$PATH"
            '';
        in
            lib.mkMerge [ nixConfig zshExtraConfig  ];
        oh-my-zsh = {
            enable = true;
            plugins = [
                "aliases"
                "aws"
                "celery"
                "cp"
                "copypath"
                "dirhistory"
                "docker"
                "docker-compose"
                "dotenv"
                "emoji"
                "encode64"
                "extract"
                "fzf"
                "git"
                "git-commit"
                "git-prompt"
                "github"
                "gitignore"
                "history"
                "httpie"
                "isodate"
                "kubectl"
                "last-working-dir"
                "macos"
                "magic-enter"
                "ngrok"
                "npm"
                "pip"
                "pre-commit"
                "python"
                "qrcode"
                "rsync"
                "rust"
                "ssh"
                "sudo"
                "tldr"
                "tmux"
                "uv"
                "vi-mode"
                "vscode"
                "yarn"
            ];
        };
    };
}
