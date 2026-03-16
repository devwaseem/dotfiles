{ ... }:
{
  programs.opencode = {
    enable = true;
    agents = { };
    web = {
      enable = false;
    };
    commands = {
      mystatus = ''
        # Query quota usage for all AI accounts

        Use the mystatus tool to query quota usage. Return the result as-is without modification.
      '';
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
