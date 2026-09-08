{ pkgs, ... }:

##Mako notification center

let
  mako-history = pkgs.writeShellScriptBin "mako-history" ''
    set -euo pipefail

    history="$(${pkgs.mako}/bin/makoctl history)"

    count="$(
      printf '%s\n' "$history" \
        | ${pkgs.gnugrep}/bin/grep -c '^Notification [0-9]\+:' \
        || true
    )"

    if [ "$count" -eq 1 ]; then
      count_text="1 notification"
    else
      count_text="$count notifications"
    fi

    {
      printf '%s\n' \
        '──────────────────────── Notifications ────────────────────────'

      printf '%s\n' \
        "History: $count_text    Latest first"

      printf '%s\n' \
        'j/k scroll   PgUp/PgDn page   g/G first/last   q close'

      printf '%s\n\n' \
        '───────────────────────────────────────────────────────────────'

      if [ -n "$history" ]; then
        printf '%s\n' "$history"
      else
        printf '%s\n' 'No notifications in history.'
      fi
    } | ${pkgs.less}/bin/less -R +g
  '';
in

##########################

{

  home.packages = [
    mako-history
  ];

  stylix.targets.mako.enable = true;

  services.mako = {
    enable = true;

    settings = {
      anchor = "top-right";
      layer = "overlay";

      width = 360;
      height = 120;

      margin = "12";
      padding = "12";

      border-size = 2;
      border-radius = 10;

      default-timeout = 5000;

      icons = true;
      markup = true;

      max-history = 50;
    };
  };

  systemd.user.services.mako = {
    Unit = {
      Description = "Lightweight Wayland notification daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

}
