{ pkgs, ... }:
let
  toml = pkgs.formats.toml { };
in
{
  xdg.configFile."herdr/config.toml".source = toml.generate "herdr-config.toml" {
    terminal = {
      default_shell = "zsh";
      shell_mode = "login";
      new_cwd = "follow";
    };

    worktrees.directory = "~/.local/share/herdr/worktrees";

    keys = {
      # Caps Lock is remapped to F13 by the LaunchAgent below.
      prefix = "f13";

      # Worktree lifecycle.
      new_worktree = "prefix+shift+g";
      open_worktree = "prefix+o";
      remove_worktree = "prefix+shift+d";
      close_workspace = "prefix+d";

      # Fast navigation.
      goto = "prefix+f";
      workspace_picker = "prefix+w";
      switch_workspace = "prefix+shift+1..9";
      focus_agent = "prefix+ctrl+1..9";
      previous_agent = "prefix+comma";
      next_agent = "prefix+period";
      last_pane = "prefix+backtick";

      # Keep notification focus available after giving prefix+o to worktrees.
      open_notification_target = "prefix+shift+o";

      command = [
        {
          key = "prefix+g";
          type = "popup";
          command = "lazygit";
          description = "Open Lazygit in the active worktree";
          width = "92%";
          height = "90%";
        }
        {
          key = "prefix+t";
          type = "popup";
          command = ''exec "''${SHELL:-zsh}"'';
          description = "Open a scratch terminal";
          width = "85%";
          height = "80%";
        }
      ];
    };

    ui = {
      accent = "#ffcb6b";
      agent_panel_sort = "priority";
      status_indicators = "symbols";

      sidebar_width = 30;
      sidebar_min_width = 22;
      sidebar_max_width = 38;
      sidebar_start_collapsed = false;
      sidebar_collapsed_mode = "compact";

      pane_borders = true;
      pane_outer_borders = false;
      pane_gaps = false;
      pane_scrollbars = false;
      show_agent_labels_on_pane_borders = true;

      prompt_new_workspace_name = true;
      confirm_close = true;
      copy_on_select = true;
      right_click_passthrough_modifier = "cmd";
      window_title = "{workspace} · {tab}";

      tab_bar_right = [
        { type = "zoom"; }
        {
          type = "datetime";
          format = "%H:%M";
        }
      ];
      tab_bar_right_separator = " · ";

      toast = {
        delivery = "system";
        delay_seconds = 2;
        herdr.position = "bottom-right";
      };

      sound.enabled = false;
    };
  };

}
