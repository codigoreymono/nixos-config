{ config, pkgs, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;
  fonts = config.stylix.fonts;
  iconTheme = config.stylix.icons.dark;

  quickshellConfig = pkgs.runCommand "quickshell-main" { } ''
    mkdir -p "$out"

    cp -r ${./config}/. "$out/"
    chmod -R u+w "$out"

    sed -i '1i//@ pragma IconTheme ${iconTheme}' "$out/shell.qml"

    mkdir -p "$out/theme"

    cat > "$out/theme/Theme.qml" <<'EOF'
    pragma Singleton

    import QtQuick
    import Quickshell

    Singleton {
        // -----------------------------------------------------------
        // BACKGROUNDS
        // -----------------------------------------------------------

        readonly property color background: "${colors.base00}"
        readonly property color surface: "${colors.base01}"
        readonly property color surfaceActive: "${colors.base02}"
        readonly property color border: "${colors.base03}"

        // -----------------------------------------------------------
        // FOREGROUNDS
        // -----------------------------------------------------------

        readonly property color textMuted: "${colors.base04}"
        readonly property color text: "${colors.base05}"
        readonly property color textStrong: "${colors.base06}"
        readonly property color foreground: "${colors.base07}"

        // -----------------------------------------------------------
        // SEMANTIC
        // -----------------------------------------------------------

        readonly property color critical: "${colors.base08}"
        readonly property color urgent: "${colors.base09}"
        readonly property color warning: "${colors.base0A}"

        // -----------------------------------------------------------
        // FONTS
        // -----------------------------------------------------------

        readonly property string fontMono: "${fonts.monospace.name}"
        readonly property real fontDesktopSize: ${toString fonts.sizes.desktop}
    }
    EOF
  '';

in
{
  programs.quickshell = {
    enable = true;

    configs.main = quickshellConfig;
    activeConfig = "main";

    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
  };
}
