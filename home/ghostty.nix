_: {
  programs.ghostty = {
    enable = true;
    package = null;
    enableZshIntegration = true;
    installVimSyntax = false;
    settings = {
      # ui
      theme = "Catppuccin Mocha";
      background = "#000000";
      mouse-hide-while-typing = true;

      # Avoid leaking Herdr pane identity into standalone Ghostty shells.
      env = [
        "HERDR_BIN_PATH="
        "HERDR_ENV="
        "HERDR_PANE_ID="
        "HERDR_SOCKET_PATH="
        "HERDR_STARTUP_CWD="
        "HERDR_TAB_ID="
        "HERDR_WORKSPACE_ID="
      ];

      # font
      font-family = "Lilex";
      font-size = 14;
      font-synthetic-style = true;
      font-thicken = false;
      font-codepoint-map = [
        "U+E000-U+F8FF=MesloLGS NF"
        "U+F0000-U+FFFFF=MesloLGS NF"
        "U+2100-U+21FF=MesloLGS NF"
      ];

      # shell
      cursor-style = "block";
      shell-integration = "zsh";

      # clipboard
      copy-on-select = true;
      clipboard-trim-trailing-spaces = true;
      background-opacity = 0.85;
      background-opacity-cells = true;
      background-blur = true;

      # macos
      keybind = [ "cmd+k=text:\\x1b[107;7u" ];
      title = "";
      window-decoration = "auto";
      macos-titlebar-style = "hidden";
      macos-option-as-alt = true;
      macos-window-shadow = true;
    };
  };
}
