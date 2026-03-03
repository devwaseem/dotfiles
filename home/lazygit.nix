{ ... }:
{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      git = {
        pagers = [
          {
            pager = "delta --dark --paging=never";
            colorArg = "never";
            useConfig = true;
          }
        ];
      };
      gui = {
        theme = {
          activeBorderColor = [ "#89b4fa" ];
          inactiveBorderColor = [ "#a6adc8" ];
          optionsTextColor = [ "#89b4fa" ];
          selectedLineBgColor = [ "#313244" ];
          cherryPickedCommitBgColor = [ "#45475a" ];
          cherryPickedCommitFgColor = [ "#89b4fa" ];
          unstagedChangesColor = [ "#f38ba8" ];
          defaultFgColor = [ "#cdd6f4" ];
          searchingActiveBorderColor = [ "#f9e2af" ];
        };
        authorColors = {
          "*" = "#b4befe";
        };
      };
    };
  };
}
