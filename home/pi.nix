{
  config,
  lib,
  pkgs,
  ...
}:
let
  palette = import ./theme.nix;
  themeName = "shared-gruvbox";
  settingsPath = "${config.home.homeDirectory}/.pi/agent/settings.json";
in
{
  home.file.".pi/agent/themes/${themeName}.json".text = builtins.toJSON {
    "$schema" =
      "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
    name = themeName;
    vars = palette;
    colors = {
      accent = "teal";
      border = "blue";
      borderAccent = "yellow";
      borderMuted = "surface2";
      success = "green";
      error = "red";
      warning = "yellow";
      muted = "overlay1";
      dim = "overlay0";
      text = "text";
      thinkingText = "subtext0";

      selectedBg = "surface1";
      scrollbarThumb = "surface2";
      searchMatchBg = "surface2";
      searchMatchText = "text";
      userMessageBg = "surface0";
      userMessageText = "text";
      customMessageBg = "mantle";
      customMessageText = "text";
      customMessageLabel = "mauve";
      toolPendingBg = "mantle";
      toolSuccessBg = "surface0";
      toolErrorBg = "surface0";
      toolTitle = "blue";
      toolOutput = "subtext1";

      mdHeading = "yellow";
      mdLink = "blue";
      mdLinkUrl = "overlay1";
      mdCode = "teal";
      mdCodeBlock = "green";
      mdCodeBlockBorder = "surface2";
      mdQuote = "subtext0";
      mdQuoteBorder = "overlay0";
      mdHr = "surface2";
      mdListBullet = "teal";

      toolDiffAdded = "green";
      toolDiffRemoved = "red";
      toolDiffContext = "overlay1";

      syntaxComment = "overlay1";
      syntaxKeyword = "red";
      syntaxFunction = "green";
      syntaxVariable = "text";
      syntaxString = "teal";
      syntaxNumber = "mauve";
      syntaxType = "yellow";
      syntaxOperator = "peach";
      syntaxPunctuation = "subtext1";

      thinkingOff = "overlay0";
      thinkingMinimal = "overlay1";
      thinkingLow = "blue";
      thinkingMedium = "teal";
      thinkingHigh = "mauve";
      thinkingXhigh = "red";
      thinkingMax = "peach";

      bashMode = "yellow";
    };
    export = {
      pageBg = palette.base;
      cardBg = palette.mantle;
      infoBg = palette.surface0;
    };
  };

  # Pi owns the rest of this mutable file, so only merge the selected theme.
  home.activation.piTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    pi_settings=${lib.escapeShellArg settingsPath}
    if [ -f "$pi_settings" ]; then
      pi_current_theme="$(${pkgs.jq}/bin/jq -r '.theme // ""' "$pi_settings")"
      if [ "$pi_current_theme" != ${lib.escapeShellArg themeName} ]; then
        pi_settings_tmp="$(${pkgs.coreutils}/bin/mktemp)"
        ${pkgs.jq}/bin/jq --arg theme ${lib.escapeShellArg themeName} '.theme = $theme' "$pi_settings" > "$pi_settings_tmp"
        ${pkgs.coreutils}/bin/mv "$pi_settings_tmp" "$pi_settings"
      fi
    fi
  '';
}
