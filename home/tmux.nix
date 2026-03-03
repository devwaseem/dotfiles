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
    resizeAmount = 10;

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
      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

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

      # Opencode - run a tmux session with the current directory
      bind o run-shell '
        # 1. Get the cwd name
        PROJECT_NAME=$(basename "#{pane_current_path}")

        # 2. Get a short hash of the full path for uniqueness
        PATH_HASH=$(printf "#{pane_current_path}" | sha256sum | cut -c1-5)

        # 3. Combine them: e.g., opencode_my-project_a7b2c
        SESSION_NAME="opencode_''${PROJECT_NAME}_''${PATH_HASH}"

        # 4. Create the session if it doesn't exist
        if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
          tmux new-session -d -s "$SESSION_NAME" -c "#{pane_current_path}" "opencode"
        fi

        # 5. Attach. The -E flag closes the popup when you exit opencode or detach.
        tmux display-popup -E -w 90% -h 85% -b rounded "tmux attach-session -t $SESSION_NAME"
      '

      # Lazygit
      bind g display-popup -E -w 90% -h 85% -d "#{pane_current_path}" -b rounded "lazygit"

      # Custom Session Picker
      unbind s
      bind s display-popup -E -w 40% "sesh connect \"$(sesh list -i | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a sesh' --height 50 --prompt='⚡')\""
      bind T run-shell "sesh connect \"$(sesh list | fzf)\""
    '';
  };
}
