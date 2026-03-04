{ pkgs, config, ... }:
let
  username = "waseemakram";
  homeDir = "/Users/${username}";
in
{

  fonts.fontconfig.enable = true;
  home = {
    stateVersion = "25.05";
    username = username;
    shell = {
      enableZshIntegration = true;
    };

    sessionVariables = {
      EDITOR = "nvim";
      XDG_CONFIG_HOME = "$HOME/.config";
      SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
      LZ_CONFIG_DIR = "$HOME/.config/lazygit/";
      COLORTERM = "truecolor";
      TERM = "xterm-256color";
      ZK_PATH = "$HOME/Zettelkasten";
      BUN_INSTALL = "$HOME/.bun";

      # ── secrets ───────────────────────────────────────────────────────────
      EXA_API_KEY = "$(cat ${config.sops.secrets.exa_api_key.path})";
      CONTEXT7_API_KEY = "$(cat ${config.sops.secrets.context7_api_key.path})";
      # Bitwarden
      BW_SESSION = "$(cat ${config.sops.secrets.bw_session.path})";
    };
    file = { };
    packages = with pkgs; [
      aerc
      aria2
      awscli2
      bat
      bitwarden-cli
      btop
      bun
      ccache
      cloudflared
      delta
      direnv
      eza
      fd
      ffmpeg
      gh
      gnupg
      gum
      hey
      jq
      just
      kubectl
      lazydocker
      ncdu
      neovim
      nmap
      nodejs
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
      scrcpy
      sesh
      sqlit-tui
      starship
      stow
      tesseract4
      tmux
      tree
      uv
      watchman
      yarn
      yazi
      zsh-autosuggestions
      zsh-syntax-highlighting
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
      fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
      changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    };

    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        italic-text = "always";
        style = "numbers,changes,header";
        pager = "less -R";
      };
    };

    direnv = {
      enable = true;
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

    lazyworktree = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  services.jankyborders =
    {
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
  ];

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/nvim";
    recursive = true;
  };

}

