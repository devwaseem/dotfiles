{ pkgs, ... }:
let
  palette = import ./theme.nix;
  toml = pkgs.formats.toml { };
in
{
  xdg.configFile."herdr/config.toml".source = toml.generate "herdr-config.toml" {
    theme.name = "gruvbox";

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
          key = "prefix+k";
          type = "plugin_action";
          command = "herdr-bar.open";
          description = "Open command bar";
        }
        {
          key = "prefix+g";
          type = "popup";
          command = "lazygit";
          description = "Open Lazygit in the active worktree";
          width = "98%";
          height = "95%";
        }
        {
          key = "prefix+shift+f";
          type = "popup";
          command = "gh-dash";
          description = "Open GitHub dashboard";
          width = "98%";
          height = "95%";
        }
        {
          key = "prefix+shift+k";
          type = "shell";
          command = "herdr plugin action invoke open-board --plugin herdr-board";
          description = "Open agent kanban board";
        }
        {
          key = "prefix+t";
          type = "popup";
          command = ''exec "''${SHELL:-zsh}"'';
          description = "Open a scratch terminal";
          width = "85%";
          height = "80%";
        }
        {
          key = "prefix+e";
          type = "plugin_action";
          command = "chmarax.herdr-nvim.toggle";
          description = "Toggle Neovim sidebar";
        }
        {
          key = "prefix+shift+e";
          type = "plugin_action";
          command = "chmarax.herdr-nvim.pick-file";
          description = "Open referenced file in Neovim";
        }
        {
          key = "prefix+a";
          type = "plugin_action";
          command = "herdr-notes.open-notes";
          description = "Toggle workspace notes";
        }
        {
          key = "prefix+y";
          type = "plugin_action";
          command = "hotchpotch.herdr-tiny-fingers.open";
          description = "Copy visible text with hints";
        }
        {
          key = "prefix+shift+y";
          type = "plugin_action";
          command = "tab-smart-rename.rename-now";
          description = "Smart rename current tab";
        }
        {
          key = "prefix+ctrl+shift+y";
          type = "plugin_action";
          command = "tab-smart-rename.rename-all";
          description = "Smart rename all tabs";
        }
        {
          key = "prefix+shift+h";
          type = "plugin_action";
          command = "jhochenbaum.hunkdiff.review";
          description = "Review changes in Hunk";
        }
        {
          key = "prefix+shift+s";
          type = "plugin_action";
          command = "jhochenbaum.hunkdiff.send-review";
          description = "Send Hunk comments to agent";
        }
        {
          key = "prefix+u";
          type = "plugin_action";
          command = "worktrunk.open";
          description = "Open or create worktree";
        }
        {
          key = "prefix+shift+u";
          type = "plugin_action";
          command = "worktrunk.open-current";
          description = "Create worktree from current branch";
        }
        {
          key = "prefix+m";
          type = "plugin_action";
          command = "worktrunk.merge";
          description = "Merge worktree";
        }
        {
          key = "prefix+shift+m";
          type = "plugin_action";
          command = "worktrunk.remove";
          description = "Remove worktree";
        }
      ];
    };

    ui = {
      accent = palette.yellow;
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
