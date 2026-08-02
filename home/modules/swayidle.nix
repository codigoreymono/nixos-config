{ config, pkgs, ... }:

{
  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
      }
      {
        timeout = 1800;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];

    events = {
      after-resume = "${pkgs.sway}/bin/swaymsg 'output * power on'";
    };
  };
}
