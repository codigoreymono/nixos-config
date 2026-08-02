{ config, pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        terminal = "foot";
        layer = "overlay";
        width = 40;
        horizontal-pad = 20;
        vertical-pad = 12;
        inner-pad = 10;
        icon-theme = "hicolor";
        icons-enabled = true;
        lines = 8;
       # prompt = "  ";
      };

      colors = {
        # Paleta Catppuccin Mocha, igual que waybar
        background = "1e1e2eee";       # fondo con transparencia
        text = "cdd6f4ff";
        match = "89b4faff";            # texto que coincide con la búsqueda
        selection = "89b4faff";
        selection-text = "1e1e2eff";
        selection-match = "1e1e2eff";
        border = "89b4fa66";
      };

      border = {
        width = 2;
        radius = 12;
      };
    };
  };
}
