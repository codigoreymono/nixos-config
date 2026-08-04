{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      add_newline = true;

      format = ''
        $os$username$directory$git_branch$git_status$python$nix_shell$character
      '';

      os = {
        disabled = false;
        style = "bold #89b4fa";
        symbols = {
          NixOS = " ";
        };
      };

      username = {
        style_user = "bold #cba6f7";
        format = "[$user]($style) ";
        show_always = true;
      };

      character = {
        success_symbol = "[❯](bold #a6e3a1)";
        error_symbol = "[❯](bold #f38ba8)";
      };

      directory = {
        style = "bold #89b4fa";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        style = "bold #cba6f7";
        format = " [$symbol$branch]($style)";
        symbol = " ";
      };

      git_status = {
        style = "bold #f9e2af";
        format = "[$all_status$ahead_behind]($style)";
      };

      python = {
        style = "bold #a6e3a1";
        format = " [$symbol$virtualenv]($style)";
        symbol = " ";
      };

      nix_shell = {
        style = "bold #94e2d5";
        format = " [$symbol$state]($style)";
        symbol = " ";
      };
    };
  };
}
