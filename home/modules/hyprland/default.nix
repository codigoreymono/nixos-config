{ config, ... }:

{
  stylix.targets.hyprland.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;


    package = null;
    portalPackage = null;


    configType = "lua";


    systemd.enable = false;

    extraLuaFiles = {
      bindings = ./bindings.lua;
      monitors = ./monitors.lua;
      input = ./input.lua;
      environment= ./environment.lua;
      general = ./general.lua;
      windowrules = ./windowrules.lua;
    };
  };


  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
