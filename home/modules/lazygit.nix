{ config, pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          activeBorderColor = [ "#89b4fa" "bold" ];
          inactiveBorderColor = [ "#585b70" ];
          selectedLineBgColor = [ "#313244" ];
        };
      };
    };
  };
}
