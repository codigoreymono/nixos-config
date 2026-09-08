{ ... }:

{
  stylix.targets.starship.enable = true;

  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      add_newline = true;

      # Top line: secondary information aligned to the right
      # Bottom line: main prompt aligned to the left
      format = "$fill\${custom.date}$cmd_duration\n$os$username$directory$git_branch$git_status$nix_shell$character";

      # ----------------------------------------------------------------
      # FILL
      # ----------------------------------------------------------------

      fill = {
        symbol = " ";
      };

      # ----------------------------------------------------------------
      # DATE
      # ----------------------------------------------------------------

      custom.date = {
        command = "date +%d/%m/%y";
        when = true;

        style = "base04";
        format = "[$output]($style)";
      };

      # ----------------------------------------------------------------
      # COMMAND DURATION
      # ----------------------------------------------------------------

      cmd_duration = {
        min_time = 2000;
        style = "bold base0A";

        format = "[ | ](base04)[$duration]($style)";
      };

      # ----------------------------------------------------------------
      # OS
      # ----------------------------------------------------------------

      os = {
        disabled = false;
        style = "bold base0A";

        symbols = {
          NixOS = " ";
        };
      };

      # ----------------------------------------------------------------
      # USER
      # ----------------------------------------------------------------

      username = {
        style_user = "bold base05";
        format = "[$user]($style) ";
        show_always = true;
      };

      # ----------------------------------------------------------------
      # DIRECTORY
      # ----------------------------------------------------------------

      directory = {
        style = "bold base0D";

        truncation_length = 2;
        truncate_to_repo = false;
        truncation_symbol = "…/";

        read_only = "";
      };

      # ----------------------------------------------------------------
      # GIT
      # ----------------------------------------------------------------

      git_branch = {
        style = "bold base0A";
        format = " [$symbol$branch]($style)";
        symbol = " ";
      };

      git_status = {
        style = "bold base09";
        format = "[$all_status$ahead_behind]($style)";
      };

      # ----------------------------------------------------------------
      # NIX SHELL
      # ----------------------------------------------------------------

      nix_shell = {
        style = "bold base0C";
        format = " [$symbol$state]($style)";
        symbol = " ";
      };

      # ----------------------------------------------------------------
      # PROMPT CHARACTER
      # ----------------------------------------------------------------

      character = {
        success_symbol = "[❯](bold base0A)";
        error_symbol = "[❯](bold base08)";
      };
    };
  };
}
