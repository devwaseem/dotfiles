{ pkgs, config, ... }:
let
  username = "waseemakram";
  homeDir = "/Users/${username}";
in
{

  fonts.fontconfig.enable = true;
  programs.qmd.enable = true;

  home = {
    stateVersion = "25.05";
    inherit username;
    shell = {
      enableZshIntegration = true;
    };

    sessionVariables = {
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "${homeDir}/.config";
      SOPS_AGE_KEY_FILE = "${homeDir}/.config/sops/age/keys.txt";
      COLORTERM = "truecolor";
      TERM = "xterm-256color";
      ZK_PATH = "${homeDir}/Zettelkasten";
      BUN_INSTALL = "${homeDir}/.bun";
      PNPM_HOME = "${homeDir}/Library/pnpm";
    };
    file = { };
    packages = with pkgs; [
      # bitwarden-cli
      aria2
      ast-grep
      awscli2
      bruno
      btop
      bun
      cargo
      ccache
      clang
      cloudflared
      codex
      deadnix
      delta
      fd
      ffmpeg
      antigravity-cli
      gh
      gh-dash
      gnupg
      gum
      herdr
      hey
      hunk
      jq
      jujutsu
      just
      k9s
      kubecolor
      kubectl
      kubie
      lazydocker
      ncdu
      neovim
      nixd
      nixfmt
      nmap
      nodejs
      nvd
      oha
      pass
      pls
      pnpm
      postgresql_18
      pre-commit
      python315
      reattach-to-user-namespace
      ripgrep
      ruby_4_0
      rust-analyzer
      rustc
      scrcpy
      sentry-cli
      sesh
      sqlit-tui
      statix
      stow
      tesseract4
      terminal-notifier
      tree
      tree-sitter
      tuicr
      uv
      watch
      watchexec
      watchman
      yarn
      yazi
    ];
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "${homeDir}/.ssh/id_ed25519" ];
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
    secrets = {
      exa_api_key = { };
      context7_api_key = { };
      bw_session = { };
      pypi_token = { };
    };
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      signing = {
        key = "${homeDir}/.ssh/id_ed25519.pub";
        signByDefault = true;
      };
      ignores = [
        ".DS_Store"
        "*.swp"
        ".direnv/"
        "node_modules/"
        "build"
        "dist"
        ".venv"
        "venv"
      ];
      includes = [
        {
          condition = "gitdir:~/Work/";
          contents = {
            user.email = "waseem07799@gmail.com";
          };
        }
      ];
      settings = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;

        user = {
          name = "Waseem Akram";
          email = "waseem07799@gmail.com";
        };

        core = {
          editor = "nvim";
          whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        };

        merge.conflictstyle = "zdiff3";
        commit.verbose = true;

        credential.helper = "osxkeychain";

        delta = {
          enable = true;
          options = {
            line-numbers = true;
            side-by-side = true;
          };
        };

        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        defaultEditor = "nvim";
        auto_sync = true;
        style = "compact";
        inline_height = 20;
        update_check = false;
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      fileWidget.command = "fd --type f --hidden --follow --exclude .git";
      changeDirWidget.command = "fd --type d --hidden --follow --exclude .git";
      historyWidget.command = "";
    };

    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
        italic-text = "always";
        style = "numbers,changes,header";
        pager = "less -R";
      };
    };

    direnv = {
      enable = true;
      package = pkgs.direnv.overrideAttrs (_: {
        doCheck = false;
      });
      nix-direnv.enable = true; # Faster nix-shell loading
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

  };

  services.jankyborders = {
    enable = true;
    settings = {
      style = "rounded";
      hidpi = true;
    };
  };

  imports = [
    ./home/opencode
    ./home/zsh.nix
    ./home/starship.nix
    ./home/aerospace.nix
    ./home/lazygit.nix
    ./home/tmux.nix
    ./home/ghostty.nix
    ./home/pi.nix
    ./home/keyboard.nix
    ./home/herdr.nix
  ];

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/nvim";
    recursive = true;
  };

}
