{ config, pkgs, ... }:
{
  services.mako = {
    enable = true;

    settings = {
      font = "JetBrainsMono Nerd Font 10";
      width = 300;
      margin = "10,10";
      padding = "10";
      border-size = 2;
      border-radius = 12;
      anchor = "top-right";
      default-timeout = 5000;
      ignore-timeout = false;
      icons = true;

      background-color = "#1e1e2eee";
      text-color = "#cdd6f4ff";
      border-color = "#89b4faff";
      progress-color = "#313244ff";
    };
  };
}
