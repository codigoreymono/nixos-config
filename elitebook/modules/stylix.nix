{ pkgs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = false;

    polarity = "dark";

    opacity = {
        terminal = 0.95;
      };

    # ---------------------------------------------------------------
    # ICONS
    # ---------------------------------------------------------------

    icons = {
      enable = true;

      package = pkgs.papirus-icon-theme;

      dark = "Papirus-Dark";
      light = "Papirus";
    };

    # ---------------------------------------------------------------
    # FONTS
    # ---------------------------------------------------------------

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      sizes = {
        desktop = 10;
        applications = 11;
        terminal = 11;
      };
    };

    # ---------------------------------------------------------------
    # NIXOS TARGETS
    # ---------------------------------------------------------------

    targets = {
      font-packages.enable = true;
      qt.enable = true;
      regreet.enable = true;
    };

    # ---------------------------------------------------------------
    # REYMONO MONOCHROME YELLOW
    # ---------------------------------------------------------------

    base16Scheme = {
      scheme = "Reymono Monochrome Yellow";
      author = "Reymono";

      # Backgrounds
      base00 = "0b0b0c";
      base01 = "151517";
      base02 = "232326";
      base03 = "3a3a3f";

      # Foregrounds
      base04 = "7a7a80";
      base05 = "d7d7dc";
      base06 = "eeeef0";
      base07 = "ffffff";

      # Yellow accent
      base08 = "f5c84c";
      base09 = "e7b93f";
      base0A = "ffd866";

      # Remaining monochrome tones
      base0B = "c8c8cc";
      base0C = "dddddf";
      base0D = "f2f2f3";
      base0E = "b6b6bb";
      base0F = "909096";
    };
  };
}
