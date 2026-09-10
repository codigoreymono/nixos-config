{ pkgs, ... }:

{
  services.greetd = {
    enable = true;

    # tuigreet runs directly on the Linux virtual console.
    useTextGreeter = true;

    settings.default_session = {
      user = "greeter";

      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd '${pkgs.uwsm}/bin/uwsm start -e -D Hyprland hyprland.desktop' --theme 'border=yellow;text=white;time=yellow;container=black;title=yellow;greet=white;prompt=yellow;input=white;action=cyan;button=yellow'";
    };
  };
}
