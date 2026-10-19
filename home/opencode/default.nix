_:
let
  palette = import ../theme.nix;
in
{
  xdg.configFile."opencode/tui.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/tui.json";
    theme = "catppuccin-mocha";
  };

  xdg.configFile."opencode/themes/catppuccin-mocha.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/theme.json";
    defs = palette;
    theme = {
      primary = "blue";
      secondary = "mauve";
      accent = "teal";
      error = "red";
      warning = "yellow";
      success = "green";
      info = "blue";
      text = "text";
      textMuted = "overlay1";
      background = "base";
      backgroundPanel = "mantle";
      backgroundElement = "surface0";
      border = "surface1";
      borderActive = "blue";
      borderSubtle = "surface0";
      diffAdded = "green";
      diffRemoved = "red";
      diffContext = "overlay1";
      diffHunkHeader = "blue";
      diffHighlightAdded = "green";
      diffHighlightRemoved = "red";
      diffAddedBg = "surface0";
      diffRemovedBg = "surface0";
      diffContextBg = "mantle";
      diffLineNumber = "overlay0";
      diffAddedLineNumberBg = "surface0";
      diffRemovedLineNumberBg = "surface0";
      markdownText = "text";
      markdownHeading = "yellow";
      markdownLink = "blue";
      markdownLinkText = "teal";
      markdownCode = "green";
      markdownBlockQuote = "overlay1";
      markdownEmph = "peach";
      markdownStrong = "yellow";
      markdownHorizontalRule = "surface2";
      markdownListItem = "blue";
      markdownListEnumeration = "teal";
      markdownImage = "mauve";
      markdownImageText = "teal";
      markdownCodeBlock = "text";
      syntaxComment = "overlay1";
      syntaxKeyword = "red";
      syntaxFunction = "green";
      syntaxVariable = "text";
      syntaxString = "teal";
      syntaxNumber = "mauve";
      syntaxType = "yellow";
      syntaxOperator = "peach";
      syntaxPunctuation = "subtext1";
    };
  };

  programs.opencode = {
    enable = true;
    agents = {
      interview = ./agents/interview.md;
    };
    web = {
      enable = false;
    };
    commands = {
      mystatus = ''
        # Query quota usage for all AI accounts

        Use the mystatus tool to query quota usage. Return the result as-is without modification.
      '';
    };
    skills = {
      design-an-interface = ./skills/design-an-interface;
      domain-model = ./skills/domain-model;
      grill-me = ./skills/grill-me;
      qa = ./skills/qa;
      request-refactor-plan = ./skills/request-refactor-plan;
      scaffold-exercises = ./skills/scaffold-exercises;
      tdd = ./skills/tdd;
      to-prd = ./skills/to-prd;
      triage-issue = ./skills/triage-issue;
      ubiquitous-language = ./skills/ubiquitous-language;
      write-a-skill = ./skills/write-a-skill;
      zoom-out = ./skills/zoom-out;
      improve-codebase-architecture = ./skills/improve-codebase-architecture;
    };
    settings = {
      permission = {
        edit = "allow";
        bash = "allow";
        skill = "allow";
        todoread = "allow";
        todowrite = "allow";
        webfetch = "allow";
        question = "allow";
      };
      lsp = { };
      formatter = { };
      compaction = {
        auto = true;
        prune = true;
      };
      mcp = {
        exa = {
          type = "remote";
          url = "https://mcp.exa.ai/mcp?tools=web_search_exa,web_search_advanced_exa,get_code_context_exa,crawling_exa,company_research_exa,people_search_exa,deep_researcher_start,deep_researcher_check";
          enabled = true;
          headers = {
            "x-api-key" = "{env:EXA_API_KEY}";
          };
        };
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          headers = {
            "CONTEXT7_API_KEY" = "{env:CONTEXT7_API_KEY}";
          };
          enabled = true;
        };
        chrome-devtools = {
          type = "local";
          command = [
            "npx"
            "-y"
            "chrome-devtools-mcp@latest"
            "--no-usage-statistics"
          ];
        };
      };
      plugin = [
        "opencode-mystatus"
        "opencode-plugin-openspec"
        "@plannotator/opencode@latest"
        "opencode-gemini-auth@latest"
      ];
      provider = {
        google = {
          options = {
            projectId = "woven-patrol-489808-t8";
          };
          models = {
            "gemini-3-flash" = { };
          };
        };
      };
    };
  };
}
