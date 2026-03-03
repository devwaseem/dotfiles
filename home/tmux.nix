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
    focusEvents = true;
    # Automatically spawn a session if trying to attach and none are running.
    newSession = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;

    # tmuxp.enable = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-command 'echo -n {} | ${if pkgs.stdenv.isDarwin then "pbcopy" else "wl-copy"}'
          set -g @thumbs-position off_left
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

          set -g mode-style "fg=#000000,bg=#ffd700"
          set -g status-style bg=default
          set -g status-style fg=#c5c6c7
        '';
      }
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];

    extraConfig = ''
      # Fix colors
      set -as terminal-overrides ",xterm*:Tc"

      setw -g pane-base-index 1
      set -g renumber-windows on
      set -g detach-on-destroy off
      setw -g xterm-keys on

      # Better naming
      set-option -g allow-rename on
      set -g automatic-rename on
      setw -g automatic-rename-format "#{b:pane_current_command}"

      # Clipboard and Passthrough
      set -g set-clipboard on
      set -g allow-passthrough on

      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      set -g bell-action none
      setw -g monitor-activity on
      set -g window-status-activity-style "fg=#fab387,bold"

      # Custom Splits (Opening in CWD)
      bind |   split-window -h -c "#{pane_current_path}"
      bind -   split-window -v -c "#{pane_current_path}"
      bind \\  split-window -h -c "#{pane_current_path}"
      bind Enter split-window -v -c "#{pane_current_path}"

      # Pane Navigation (Alt + Arrow)
      bind -n M-Left  select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up    select-pane -U
      bind -n M-Down  select-pane -D

      # Prefix + hjkl (Classic)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Copy Mode
      bind -T copy-mode-vi v send -X begin-selection

      # Utilities
      bind-key q set-option status
      bind-key x kill-pane # No prompt

      # Mouse Scrollback
      bind -n WheelUpPane if -F "#{mouse_any_flag}" "send-keys -M" "copy-mode -e; send-keys -M"
      bind -n WheelDownPane select-pane -t= \; send-keys -M

      # Opencode
      bind o display-popup -E -w 90% -h 85% -d "#{pane_current_path}" -b rounded "opencode"

      # Lazygit
      bind g display-popup -E -w 90% -h 85% -d "#{pane_current_path}" -b rounded "lazgit"

      # Custom Session Picker
      unbind s
      bind s display-popup -E -w 40% "sesh connect \"$(sesh list -i | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a sesh' --height 50 --prompt='⚡')\""
      bind T run-shell "sesh connect \"$(sesh list | fzf)\""
    '';
  };
}
