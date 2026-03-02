{ pkgs, config, ... }:
let
    username = "waseemakram";
    homeDir = "/Users/${username}";
in
{
    sops = {
        defaultSopsFile = ./secrets.yaml;
        age.sshKeyPaths = [ "${homeDir}/.ssh/id_ed25519" ];
        age.keyFile =  "${homeDir}/.config/sops/age/keys.txt";
        secrets = {
            exa_api_key = {};
            context7_api_key = {};
        };
    };
    home = {
        stateVersion = "25.05";
        username = username;
        shell = {
            enableZshIntegration = true;
        };
        sessionVariables = {
            COLORTERM = "truecolor";
            TERM = "xterm-256color";
            EDITOR = "nvim";
            LZ_CONFIG_DIR = "$HOME/.config/lazygit/";
            ZK_PATH = "$HOME/Zettelkasten";
        };
        file = {};
        packages = with pkgs; [
            bat
            btop
            delta
            direnv
            eza
            fd
            ffmpeg
            gh
            gum
            hey
            jq
            just
            kubectl
            lazydocker
            lazyworktree
            ncdu
            neovim
            ninja
            nixd
            nmap
            nodejs
            oha
            pls
            python3
            ripgrep
            ruby
            scrcpy
            sesh
            starship
            stow
            tree
            watchman
            yarn
            yazi
            zsh-autosuggestions
            zsh-syntax-highlighting
        ];
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

        git-worktree-switcher = {
            enable = true;
            enableZshIntegration = true;
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
    };

    imports = [
        ./home/zsh.nix
        ./home/starship.nix
        ./home/aerospace.nix
        ./home/opencode
        ./home/lazygit.nix
    ];

    xdg.configFile."nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/nvim";
        recursive = true;
    };

}

