{ ... }:
{
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
          command = [ "npx" "-y" "chrome-devtools-mcp@latest" "--no-usage-statistics" ];
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
            projectId = "gen-lang-client-0291774259";
          };
        };
      };
    };
  };
}
