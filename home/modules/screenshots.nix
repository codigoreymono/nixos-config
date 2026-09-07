{ pkgs, ... }:

let
  # -------------------------------------------------------------------
  # SCREENSHOT
  # -------------------------------------------------------------------

  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    set -euo pipefail

    capture="''${1:-}"
    destination="''${2:-}"

    # -----------------------------------------------------------------
    # VALIDATION
    # -----------------------------------------------------------------

    case "$capture" in
      region|monitor)
        ;;
      *)
        echo "Usage: screenshot {region|monitor} {clipboard|file}" >&2
        exit 2
        ;;
    esac

    case "$destination" in
      clipboard|file)
        ;;
      *)
        echo "Usage: screenshot {region|monitor} {clipboard|file}" >&2
        exit 2
        ;;
    esac

    # -----------------------------------------------------------------
    # CAPTURE TARGET
    # -----------------------------------------------------------------

    geometry=""
    monitor=""

    case "$capture" in
      region)
        geometry="$(${pkgs.slurp}/bin/slurp)" || exit 0

        [ -z "$geometry" ] && exit 0
        ;;

      monitor)
        monitor="$(
          hyprctl -j monitors \
            | ${pkgs.jq}/bin/jq -r \
                '.[] | select(.focused == true) | .name'
        )"

        [ -z "$monitor" ] && exit 1
        ;;
    esac

    # -----------------------------------------------------------------
    # CLIPBOARD ONLY
    # -----------------------------------------------------------------

    if [ "$destination" = "clipboard" ]; then
      case "$capture" in
        region)
          ${pkgs.grim}/bin/grim \
            -g "$geometry" \
            - \
            | ${pkgs.wl-clipboard}/bin/wl-copy \
                --type image/png
          ;;

        monitor)
          ${pkgs.grim}/bin/grim \
            -o "$monitor" \
            - \
            | ${pkgs.wl-clipboard}/bin/wl-copy \
                --type image/png
          ;;
      esac

      ${pkgs.libnotify}/bin/notify-send \
        "Screenshot" \
        "Copied to clipboard" \
        --icon=camera-photo

      exit 0
    fi

    # -----------------------------------------------------------------
    # FILE + CLIPBOARD
    # -----------------------------------------------------------------

    screenshots_dir="$HOME/Pictures/Screenshots"

    mkdir -p "$screenshots_dir"

    filename="$screenshots_dir/$(date '+%Y-%m-%d_%H-%M-%S').png"

    case "$capture" in
      region)
        ${pkgs.grim}/bin/grim \
          -g "$geometry" \
          "$filename"
        ;;

      monitor)
        ${pkgs.grim}/bin/grim \
          -o "$monitor" \
          "$filename"
        ;;
    esac

    ${pkgs.wl-clipboard}/bin/wl-copy \
      --type image/png \
      < "$filename"

    ${pkgs.libnotify}/bin/notify-send \
      "Screenshot" \
      "Saved and copied to clipboard" \
      --icon=camera-photo
  '';

in
{
  home.packages = [
    pkgs.grim
    pkgs.slurp

    screenshot
  ];
}
