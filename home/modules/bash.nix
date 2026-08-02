{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    initExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';
  };
}
