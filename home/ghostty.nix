{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;
    installVimSyntax = true;
    settings = {
      # ui
      background = "#000000";
      mouse-hide-while-typing = true;

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
      background-blur = 20;
      background-opacity-cells = true;

      # macos
      title = "";
      window-decoration = "auto";
      macos-titlebar-style = "hidden";
      macos-option-as-alt = true;
      macos-window-shadow = true;
    };
  };
}
