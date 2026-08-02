{ config, pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      image = "/home/reymono/Pictures/wallpapers/jellyfish.jpg";
      scaling = "fill";
      effect-blur = "20x5";
      effect-vignette = "0.5:0.5";
      color = "1e1e2e";

      # Anillo exterior
      ring-color = "89b4fa";
      ring-ver-color = "89b4fa";
      ring-wrong-color = "f38ba8";
      ring-clear-color = "a6e3a1";

      # Interior del anillo (¡nuevo!)
      inside-color = "313244";
      inside-ver-color = "45475a";
      inside-wrong-color = "f38ba8";
      inside-clear-color = "a6e3a1";

      # Líneas del anillo (invisibles)
      line-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      line-clear-color = "00000000";

      # Teclas presionadas
      key-hl-color = "cba6f7";
      bs-hl-color = "f38ba8";

      # Texto
      font = "JetBrainsMono Nerd Font";
      font-size = 24;
      text-color = "cdd6f4";
      text-ver-color = "cdd6f4";
      text-wrong-color = "f38ba8";
      text-clear-color = "1e1e2e";

      # Layout
      indicator-radius = 120;
      indicator-thickness = 12;

      show-failed-attempts = false;
      show-keyboard-layout = false;
      ignore-empty-password = true;
      fade-in = 0.2;
    };
  };
}
