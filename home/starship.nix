{ pkgs, ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command_timeout = 1000;
      format = ''
        [╭─](bold white)\[$directory\] $git_branch$git_status$nix_shell$container
        [╰─](bold white)$character
      '';

      right_format = ''
        $cmd_duration$aws$gcloud$python$nodejs$rust$golang
      '';

      # Fill pushes the duration/time to the far right of the first line
      fill = {
        symbol = " ";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold purple)";
      };

      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state( \($name\))]($style) ";
        style = "bold blue";
        impure_msg = "impure";
        pure_msg = "pure";
      };

      directory = {
        style = "bold cyan";
        format = "[$path]($style) ";
        truncation_length = 3;
        truncation_symbol = "…/";
        truncate_to_repo = true; # If inside a Git repo, stop truncating at the root
        fish_style_pwd_dir_length = 1; # Turns /home/user/projects into /h/u/projects
      };

      nodejs = {
        symbol = " ";
        style = "bold green";
        format = "via [$symbol($version )]($style)";
      };

      python = {
        symbol = " ";
        style = "bold yellow";
        format = "via [$symbol($version )]($style)";
      };

      aws.symbol = "  ";
      buf.symbol = " ";
      bun.symbol = " ";
      c.symbol = " ";
      cpp.symbol = " ";
      cmake.symbol = " ";
      conda.symbol = " ";
      crystal.symbol = " ";
      dart.symbol = " ";
      deno.symbol = " ";
      directory.read_only = " 󰌾";
      docker_context.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      fennel.symbol = " ";
      fossil_branch.symbol = " ";
      gcloud.symbol = "  ";
      git_branch.symbol = " ";
      git_commit.tag_symbol = "  ";
      golang.symbol = " ";
      guix_shell.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = " ";
      hg_branch.symbol = " ";
      hostname.ssh_symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      kotlin.symbol = " ";
      lua.symbol = " ";
      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nim.symbol = "󰆥 ";
      ocaml.symbol = " ";
      package.symbol = "󰏗 ";
      perl.symbol = " ";
      php.symbol = " ";
      pijul_channel.symbol = " ";
      pixi.symbol = "󰏗 ";
      rlang.symbol = "󰟔 ";
      ruby.symbol = " ";
      rust.symbol = "󱘗 ";
      scala.symbol = " ";
      swift.symbol = " ";
      zig.symbol = " ";
      gradle.symbol = " ";
    };
  };
}
