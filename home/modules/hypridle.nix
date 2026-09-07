{ ... }:

{
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        # Start hyprlock when the session receives a lock request.
        lock_cmd = "pidof hyprlock || hyprlock";

        # Always lock before suspending.
        before_sleep_cmd = "loginctl lock-session";

        # Make sure displays wake up after suspend.
        after_sleep_cmd =
          "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";

        # Respect application and Wayland inhibitors.
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
        ignore_wayland_inhibit = false;
      };

      listener = [
        {
          # Lock after 5 minutes.
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }

        {
          # Turn displays off 30 seconds after locking.
          timeout = 330;

          on-timeout =
            "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'";

          on-resume =
            "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
        }

        {
          # Suspend after 30 minutes.
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
