{ pkgs, ... }:
let
  palette = import ./theme.nix;
  yaml = pkgs.formats.yaml { };

  settings = {
    git.diffContextSize = 3;

    gui = {
      border = "single";
      mainPanelSplitMode = "flexible";
      scrollHeight = 3;
      scrollOffMargin = 3;
      showBottomLine = false;
      showCommandLog = false;
      showFileTree = true;
      showListFooter = false;
      showNumstatInFilesView = true;
      showRandomTip = false;
      shrinkSidePanelsToContent = false;
      sidePanelWidth = 0.3;
      splitDiff = "auto";
      wrapLinesInStagingView = true;
      sidePanels = [
        [
          "files"
          "worktrees"
          "submodules"
          "status"
        ]
        [
          "branches"
          "remotes"
          "tags"
        ]
        [
          "commits"
          "reflog"
          "stash"
        ]
      ];

      theme = {
        activeBorderColor = [
          palette.yellow
          "bold"
        ];
        inactiveBorderColor = [ palette.overlay1 ];
        optionsTextColor = [ palette.yellow ];
        selectedLineBgColor = [ palette.surface1 ];
        inactiveViewSelectedLineBgColor = [ palette.surface0 ];
        cherryPickedCommitBgColor = [ palette.surface1 ];
        cherryPickedCommitFgColor = [ palette.blue ];
        unstagedChangesColor = [ palette.red ];
        defaultFgColor = [ palette.text ];
        searchingActiveBorderColor = [ palette.blue ];
      };

      authorColors = {
        "*" = palette.blue;
      };
    };
  };
in
{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    inherit settings;
  };

  # Lazygit follows XDG_CONFIG_HOME, while Home Manager uses macOS' native
  # Application Support path. Manage both so every launch uses the same UI.
  xdg.configFile."lazygit/config.yml" = {
    source = yaml.generate "lazygit-config.yml" settings;
    force = true;
  };
}
