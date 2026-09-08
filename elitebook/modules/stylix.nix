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

    base16Scheme =
      "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };
}
