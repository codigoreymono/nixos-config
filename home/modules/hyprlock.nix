{ ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
        immediate_render = true;
      };

      input-field = {
        monitor = "";

        size = "280, 52";
        position = "0, -80";

        halign = "center";
        valign = "center";

        outline_thickness = 2;

        dots_size = 0.22;
        dots_spacing = 0.25;
        dots_center = true;

        fade_on_empty = false;
        rounding = 12;

        placeholder_text = "Password...";
        fail_text = "$FAIL";

        shadow_passes = 1;
      };

      label = [
        # Clock
        {
          monitor = "";

          text = "$TIME";
          font_size = 72;

          position = "0, 140";

          halign = "center";
          valign = "center";
        }

        # Date
        {
          monitor = "";

          text = ''cmd[update:60000] LC_TIME=C date "+%A, %B %d"'';
          font_size = 18;

          position = "0, 75";

          halign = "center";
          valign = "center";
        }

        # User
        {
          monitor = "";

          text = "$USER";
          font_size = 16;

          position = "0, -25";

          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
