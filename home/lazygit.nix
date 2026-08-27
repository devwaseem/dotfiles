_:
let
  palette = import ./theme.nix;
in
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
          activeBorderColor = [ palette.blue ];
          inactiveBorderColor = [ palette.overlay1 ];
          optionsTextColor = [ palette.blue ];
          selectedLineBgColor = [ palette.surface0 ];
          cherryPickedCommitBgColor = [ palette.surface1 ];
          cherryPickedCommitFgColor = [ palette.blue ];
          unstagedChangesColor = [ palette.red ];
          defaultFgColor = [ palette.text ];
          searchingActiveBorderColor = [ palette.yellow ];
        };
        authorColors = {
          "*" = palette.lavender;
        };
      };
    };
  };
}
