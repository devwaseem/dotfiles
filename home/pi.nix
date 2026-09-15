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
  home = {
    file = {
      ".pi/agent/extensions/sidebar-owner".source = ./pi/sidebar-owner;
      ".pi/agent/extensions/btw-split".source = ./pi/extensions/btw-split;
      ".pi/agent/extensions/workflow-presets".source = ./pi/extensions/workflow-presets;
      ".pi/agent/extensions/herdr-companion".source = ./pi/extensions/herdr-companion;
      ".pi/agent/extensions/herdr-question-state".source = ./pi/extensions/herdr-question-state;
      ".pi/agent/extensions/decision-log".source = ./pi/extensions/decision-log;
      ".pi/agent/presets.json".source = ./pi/presets.json;
      ".pi/agent/prompts/todos-clear.md".source = ./pi/prompts/todos-clear.md;
      ".pi/agent/mcp.json".text = builtins.toJSON {
        mcpServers = {
          context7 = {
            url = "https://mcp.context7.com/mcp";
            headers.CONTEXT7_API_KEY = "$env:CONTEXT7_API_KEY";
          };
          chrome-devtools = {
            command = "npx";
            args = [
              "-y"
              "chrome-devtools-mcp@latest"
              "--autoConnect"
              "--no-usage-statistics"
            ];
          };
        };
      };

      ".pi/agent/themes/${themeName}.json".text = builtins.toJSON {
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
    };

    # Pi owns the rest of this mutable file. Merge the theme and replace duplicate UI packages.
    activation.piSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      pi_settings=${lib.escapeShellArg settingsPath}
      if [ -f "$pi_settings" ]; then
        pi_settings_tmp="$(${pkgs.coreutils}/bin/mktemp)"
        ${pkgs.jq}/bin/jq --arg theme ${lib.escapeShellArg themeName} '
          .theme = $theme
          | .packages = ((.packages // [])
            | map(
                if ((if type == "string" then . else (.source // "") end)
                  | test("^npm:@narumitw/pi-btw(@.*)?$"))
                then { source: "npm:@narumitw/pi-btw@0.55.4", extensions: [] }
                else .
                end
              )
            | if any(.[];
                ((if type == "string" then . else (.source // "") end)
                  | test("^npm:@narumitw/pi-btw(@.*)?$")))
              then .
              else . + [{ source: "npm:@narumitw/pi-btw@0.55.4", extensions: [] }]
              end
            | map(select(
                ((if type == "string" then . else (.source // "") end)
                  | test("^npm:(statusline-pi|pi-sidebar-tui)(@.*)?$"))
                | not
              ))
          )
        ' "$pi_settings" > "$pi_settings_tmp"
        if ! ${pkgs.diffutils}/bin/cmp -s "$pi_settings" "$pi_settings_tmp"; then
          ${pkgs.coreutils}/bin/mv "$pi_settings_tmp" "$pi_settings"
        else
          ${pkgs.coreutils}/bin/rm "$pi_settings_tmp"
        fi
      fi
    '';
  };
}
