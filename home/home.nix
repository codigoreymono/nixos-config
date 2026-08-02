{ config, pkgs, ... }:
{
  imports = [
    ./modules/git.nix
    ./modules/sway.nix
    ./modules/waybar.nix
    ./modules/bash.nix
    ./modules/swayidle.nix
    ./modules/apps.nix
    ./modules/fuzzel.nix
    ./modules/clipboard.nix
    ./modules/mako.nix
    ./modules/swaylock.nix
    ./modules/gtk.nix
    ./modules/thunar.nix
    ./modules/foot.nix
    ./modules/nvf.nix
    ./modules/direnv.nix
  ];

  home.username = "reymono";
  home.homeDirectory = "/home/reymono";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;
  };

}
