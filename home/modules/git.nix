{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "reymono";
      user.email = "adwind007@gmail.com";
    };
  };
}
