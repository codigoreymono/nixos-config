{ config, pkgs, ... }:

let
  catppuccin-theme = pkgs.catppuccin-gtk.override {
    accents = [ "lavender" ];
    size = "compact";
    variant = "mocha";
  };
in
{
  home.packages = with pkgs; [
    catppuccin-theme
    papirus-icon-theme
  ];

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-lavender-compact";  # <-- nombre real
      package = catppuccin-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
  };

  home.sessionVariables.GTK_THEME = "catppuccin-mocha-lavender-compact";

  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=catppuccin-mocha-lavender-compact
    gtk-icon-theme-name=Papirus-Dark
    gtk-font-name=Noto Sans 11
    gtk-application-prefer-dark-theme=1
  '';

  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=catppuccin-mocha-lavender-compact
    gtk-icon-theme-name=Papirus-Dark
    gtk-font-name=Noto Sans 11
    gtk-application-prefer-dark-theme=1
  '';
}
