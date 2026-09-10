{ inputs, config, pkgs, ... }:
{
  imports = [

     inputs.nvf.homeManagerModules.default

    ./modules/git.nix
    ./modules/bash.nix
    ./modules/hypridle.nix
    ./modules/apps.nix
    ./modules/fuzzel.nix
    ./modules/clipboard.nix
    ./modules/hyprlock.nix
    ./modules/gtk.nix
    ./modules/foot.nix
    ./modules/direnv.nix
    ./modules/yazi.nix
    ./modules/lazygit.nix
    ./modules/aliases.nix
    ./modules/starship.nix
    ./modules/micro.nix
    ./modules/hyprland
    ./modules/quickshell
    ./modules/screenshots.nix
    ./modules/mako.nix
    ./modules/hyprpaper.nix
    ./modules/opencode.nix
    ./modules/herdr.nix
    ./modules/tray.nix
    ./modules/zed.nix
    ./modules/nvf
    ./modules/polkit.nix
    ./modules/ssh.nix
  ];

  home.username = "reymono";
  home.homeDirectory = "/home/reymono";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.pointerCursor = {
    enable = true;
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;
  };
  stylix.targets.qt.enable = true;
}
