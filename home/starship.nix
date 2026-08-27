_: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command_timeout = 1000;
      format = "$nix_shell$directory$python$git_branch$git_status\n$character";
      right_format = "\${custom.git_project}";
      add_newline = false;

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      nix_shell = {
        symbol = "❄️ ";
        format = "[$symbol]($style)";
        style = "bold blue";
        impure_msg = "impure";
        pure_msg = "pure";
      };

      directory = {
        style = "bold cyan";
        format = "[$path]($style) ";
        truncation_length = 1;
        truncate_to_repo = false;
        read_only = " 󰌾";
      };

      custom.git_project = {
        command = ''basename "$(git rev-parse --show-toplevel)"'';
        when = "git rev-parse --is-inside-work-tree";
        format = "[󰂋 $output]($style)";
        style = "bold cyan";
      };

      git_branch = {
        symbol = "⎇ ";
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        style = "bold red";
        modified = "!";
        untracked = "?";
      };

      nodejs = {
        symbol = " ";
        style = "bold green";
        format = "via [$symbol($version )]($style)";
      };

      python = {
        style = "bold yellow";
        format = "[(\\($virtualenv\\))]($style) ";
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
      docker_context.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      fennel.symbol = " ";
      fossil_branch.symbol = " ";
      gcloud.symbol = "  ";
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
