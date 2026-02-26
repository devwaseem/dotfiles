{ pkgs, ... }:
{
    programs.tmux = {
        enable = true;
        shell = "${pkgs.zsh}/bin/zsh";
        terminal = "tmux-256color";
        historyLimit = 50000;
        keyMode = "vi";
        mouse = true;
        prefix = "C-a";
        baseIndex = 1;

        plugins = with pkgs.tmuxPlugins; [
            sensible
            vim-tmux-navigator
            yank
            tmux-which-key
            {
                plugin = tmux-thumbs;
                extraConfig = ''
                    set -g @thumbs-command 'echo -n {} | pbcopy'
                    set -g @thumbs-position off_left
                '';
            }
            {
                plugin = continuum;
                extraConfig = ''
                    set -g @continuum-restore 'on'
                '';
            }
            {
                plugin = dotbar;
                extraConfig = ''
                    set -g @tmux-dotbar-bg default
                    set -g @tmux-dotbar-fg "#585b70"
                    set -g @tmux-dotbar-fg-current "#cdd6f4"
                    set -g @tmux-dotbar-fg-session "#9399b2"
                    set -g @tmux-dotbar-fg-prefix "#cba6f7"
                    set -g @tmux-dotbar-maximized-icon "󰊓"
                    set -g @tmux-dotbar-position top
                    set -g @tmux-dotbar-right "false"
                '';
            }
            {
                plugin = resurrect;
                extraConfig = "set -g @resurrect-strategy-nvim 'session'";
            }
        ];

        extraConfig = ''
          set -as terminal-overrides ",xterm*:Tc"

          # Custom Bindings (copied from your config)
          bind | split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"

          # Sesh / Popup logic
          bind T run-shell "sesh connect \"$(sesh list | fzf)\""

        '';
    };
}
