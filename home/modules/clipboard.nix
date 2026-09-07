{ pkgs, ... }:

let
  # -------------------------------------------------------------------
  # CLIPBOARD ACTIONS
  # -------------------------------------------------------------------

  cliphist-copy = pkgs.writeShellScriptBin "cliphist-copy" ''
    set -euo pipefail

    entry="''${1:-}"

    [ -z "$entry" ] && exit 0

    printf '%s\n' "$entry" \
      | ${pkgs.cliphist}/bin/cliphist decode \
      | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  clipboard-clear-active =
    pkgs.writeShellScriptBin "clipboard-clear-active" ''
      set -euo pipefail

      ${pkgs.wl-clipboard}/bin/wl-copy --clear
      ${pkgs.wl-clipboard}/bin/wl-copy --clear-primary
    '';

  clipboard-history-wipe =
    pkgs.writeShellScriptBin "clipboard-history-wipe" ''
      set -euo pipefail

      ${pkgs.cliphist}/bin/cliphist wipe
    '';

  # -------------------------------------------------------------------
  # FUZZEL
  # -------------------------------------------------------------------

  cliphist-fuzzel = pkgs.writeShellScriptBin "cliphist-fuzzel" ''
    set -euo pipefail

    selected=$(
      ${pkgs.cliphist}/bin/cliphist list \
        | ${pkgs.fuzzel}/bin/fuzzel \
            --dmenu \
            --with-nth=2 \
            --only-match \
            --prompt "Clipboard > "
    )

    [ -z "$selected" ] && exit 0

    ${cliphist-copy}/bin/cliphist-copy "$selected"

    ${pkgs.libnotify}/bin/notify-send \
      "Clipboard" \
      "History item copied" \
      --icon=edit-paste
  '';

  clipboard-clear = pkgs.writeShellScriptBin "clipboard-clear" ''
    set -euo pipefail

    choice=$(
      printf '%s\n' \
        "Current clipboard" \
        "Clipboard history" \
        | ${pkgs.fuzzel}/bin/fuzzel \
            --dmenu \
            --only-match \
            --prompt "Clear > "
    )

    [ -z "$choice" ] && exit 0

    case "$choice" in
      "Current clipboard")
        ${clipboard-clear-active}/bin/clipboard-clear-active

        ${pkgs.libnotify}/bin/notify-send \
          "Clipboard" \
          "Current clipboard cleared" \
          --icon=edit-delete
        ;;

      "Clipboard history")
        ${clipboard-history-wipe}/bin/clipboard-history-wipe

        ${pkgs.libnotify}/bin/notify-send \
          "Clipboard" \
          "Clipboard history cleared" \
          --icon=edit-clear
        ;;
    esac
  '';

in
{
  # -------------------------------------------------------------------
  # PACKAGES
  # -------------------------------------------------------------------

  home.packages = [
    pkgs.wl-clipboard
    pkgs.cliphist
    pkgs.wl-clip-persist
    pkgs.xdg-utils
    pkgs.libnotify

    cliphist-copy
    clipboard-clear-active
    clipboard-history-wipe

    cliphist-fuzzel
    clipboard-clear
  ];

  # -------------------------------------------------------------------
  # CLIPHIST - TEXT
  # -------------------------------------------------------------------

  systemd.user.services.cliphist-text = {
    Unit = {
      Description = "Clipboard text history (cliphist)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart =
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";

      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # -------------------------------------------------------------------
  # CLIPHIST - IMAGES
  # -------------------------------------------------------------------

  systemd.user.services.cliphist-image = {
    Unit = {
      Description = "Clipboard image history (cliphist)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart =
        "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";

      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # -------------------------------------------------------------------
  # CLIPBOARD PERSISTENCE
  # -------------------------------------------------------------------

  systemd.user.services.wl-clip-persist = {
    Unit = {
      Description = "Keep clipboard alive after app closes";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart =
        "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard both";

      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
