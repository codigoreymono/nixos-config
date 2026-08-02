{ config, pkgs, ... }:

let
  cliphist-fuzzel = pkgs.writeShellScriptBin "cliphist-fuzzel" ''
    set -euo pipefail

    mapfile -t entries < <(${pkgs.cliphist}/bin/cliphist list)
    [ ''${#entries[@]} -eq 0 ] && exit 0

    display=()
    for entry in "''${entries[@]}"; do
      display+=("$(echo "$entry" | sed 's/^[0-9]*[[:space:]]*//')")
    done

    selected=$(printf '%s\n' "''${display[@]}" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt "📋 ")
    [ -z "$selected" ] && exit 0

    for i in "''${!entries[@]}"; do
      if [ "''${display[$i]}" = "$selected" ]; then
        echo "''${entries[$i]}" | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
        ${pkgs.libnotify}/bin/notify-send "Portapapeles" "Elemento del historial copiado" --icon=edit-paste
        exit 0
      fi
    done
  '';

  clipboard-clear = pkgs.writeShellScriptBin "clipboard-clear" ''
    set -euo pipefail

    choice=$(
      printf '%s\n' \
        "Portapapeles activo" \
        "Historial completo" \
        | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt "🗑️ Borrar: "
    )
    [ -z "$choice" ] && exit 0

    case "$choice" in
      "Portapapeles activo")
        ${pkgs.wl-clipboard}/bin/wl-copy --clear
        ${pkgs.wl-clipboard}/bin/wl-copy --clear-primary
        ${pkgs.libnotify}/bin/notify-send "Portapapeles" "Portapapeles activo vaciado" --icon=edit-delete
        ;;
      "Historial completo")
        ${pkgs.cliphist}/bin/cliphist wipe
        ${pkgs.libnotify}/bin/notify-send "Historial" "Historial de cliphist borrado" --icon=edit-clear
        ;;
      *)
        ${pkgs.libnotify}/bin/notify-send "Error" "Opción no reconocida: $choice" --icon=dialog-error
        ;;
    esac
  '';
in
{
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    wl-clip-persist
    libnotify
    cliphist-fuzzel
    clipboard-clear
  ];

  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history daemon (cliphist)";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store'";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.wl-clip-persist = {
    Unit = {
      Description = "Keep clipboard alive after app closes";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard both";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
