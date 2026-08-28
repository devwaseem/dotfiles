_:
let
  palette = import ./theme.nix;
in
{
  programs.ghostty = {
    enable = true;
    package = null;
    enableZshIntegration = true;
    installVimSyntax = false;
    settings = {
      # ui
      background = palette.base;
      foreground = palette.text;
      palette = [
        "0=${palette.base}"
        "1=${palette.red}"
        "2=${palette.green}"
        "3=${palette.yellow}"
        "4=${palette.blue}"
        "5=${palette.mauve}"
        "6=${palette.teal}"
        "7=${palette.subtext1}"
        "8=${palette.overlay1}"
        "9=${palette.red}"
        "10=${palette.green}"
        "11=${palette.yellow}"
        "12=${palette.blue}"
        "13=${palette.mauve}"
        "14=${palette.teal}"
        "15=${palette.text}"
      ];
      cursor-color = palette.text;
      cursor-text = palette.base;
      selection-background = palette.surface2;
      selection-foreground = palette.text;
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
      background-opacity = 1.0;
      background-blur = 0;

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
