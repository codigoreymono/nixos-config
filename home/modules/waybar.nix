{ config, pkgs, ... }:

let
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    choice=$(printf "Bloquear pantalla\nSuspender\nReiniciar\nApagar" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt "󰐥 " --width 18 --lines 4)

    case "$choice" in
      "Bloquear pantalla") swaylock -f ;;
      Suspender) systemctl suspend ;;
      Reiniciar) systemctl reboot ;;
      Apagar) systemctl poweroff ;;
    esac
  '';
in
{
  home.packages = [ power-menu ];
  
  home.file.".config/networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = fuzzel --dmenu --prompt "󰤨 " --width 35 --lines 12
    [general]
    wifi_rescan = true
    notify = false
  '';

  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;
        margin-top = 6;
        margin-left = 10;
        margin-right = 10;

        modules-left = [
          "custom/launcher"
          "sway/workspaces"
          "sway/mode"
          "sway/window"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "idle_inhibitor"
          "custom/btop"
          "backlight"
          "pulseaudio"
          "network"
          "battery"
          "tray"
          "custom/power"
        ];

        "custom/launcher" = {
          format = " ";
          tooltip = false;
          on-click = "fuzzel";
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        "sway/mode" = {
          format = "󰋜 {}";
        };

        "sway/window" = {
          format = "{app_id}";
          max-length = 20;
          tooltip = false;
        };

        clock = {
          format = "󰃭 {:%d/%m/%Y  󰥔 %H:%M}";
          format-alt = "󰥔 {:%H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#cba6f7'><b>{}</b></span>";
              days = "<span color='#cdd6f4'><b>{}</b></span>";
              weeks = "<span color='#89b4fa'><b>W{}</b></span>";
              weekdays = "<span color='#f9e2af'><b>{}</b></span>";
              today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
          tooltip-format-activated = "Modo presentación activado";
          tooltip-format-deactivated = "Modo presentación desactivado";
        };

        "custom/btop" = {
          format = "󰍛";
          tooltip = false;
          on-click = "${pkgs.foot}/bin/foot -e btop";
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = [ "󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set 5%+";
          on-scroll-down = "brightnessctl set 5%-";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 Mudo";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
            headphone = "󰋋";
            headset = "󰋎";
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pavucontrol";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          tooltip-format = "{desc}";
        };

        network = {
          format-wifi = "󰤨 {essid}";
          format-ethernet = "󰈀 {ipaddr}";
          format-disconnected = "󰤭 Offline";
          format-alt = "󰛳 {bandwidthUpBytes} 󰛴 {bandwidthDownBytes}";
          tooltip-format-wifi = "Señal: {signalStrength}%\nFrecuencia: {frequency} GHz\nIP: {ipaddr}";
          tooltip-format-ethernet = "Interfaz: {ifname}\nIP: {ipaddr}\nGateway: {gwaddr}";
          on-click = "networkmanager_dmenu";
        };

        battery = {
          states = {
            good = 95;
            warning = 20;
            critical = 10;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip-format = "{timeTo} | {power}W";
        };

        tray = {
          spacing = 8;
          icon-size = 16;
          show-passive-items = true;
        };

        "custom/power" = {
          format = "󰐥";
          tooltip = false;
          on-click = "power-menu";
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Noto Sans", monospace;
        font-size: 13px;
        font-weight: 600;
        min-height: 0;
        border: none;
        border-radius: 0;
        padding: 0;
        margin: 0;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.85);
        color: #cdd6f4;
        border-radius: 12px;
        border: 1px solid rgba(137, 180, 250, 0.15);
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      tooltip {
        background: rgba(30, 30, 46, 0.95);
        border: 1px solid #89b4fa;
        border-radius: 8px;
        padding: 8px 12px;
      }
      tooltip label {
        color: #cdd6f4;
      }

      #workspaces,
      #clock,
      #idle_inhibitor,
      #custom-btop,
      #backlight,
      #pulseaudio,
      #network,
      #battery,
      #tray,
      #custom-launcher,
      #custom-power {
        background: rgba(49, 50, 68, 0.6);
        padding: 2px 12px;
        margin: 4px 2px;
        border-radius: 10px;
        transition: all 0.2s ease;
      }

      #clock:hover,
      #custom-btop:hover,
      #backlight:hover,
      #pulseaudio:hover,
      #network:hover,
      #battery:hover {
        background: rgba(69, 71, 90, 0.8);
      }

      #custom-launcher {
        background: linear-gradient(135deg, #89b4fa, #cba6f7);
        color: #1e1e2e;
        font-size: 16px;
        padding: 2px 14px;
        margin-left: 4px;
      }
      #custom-launcher:hover {
        background: linear-gradient(135deg, #b4befe, #f5c2e7);
      }

      #workspaces {
        padding: 2px 6px;
      }
      #workspaces button {
        color: #6c7086;
        padding: 0 8px;
        margin: 0 2px;
        border-radius: 8px;
        transition: all 0.2s ease;
      }
      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.2);
        color: #cdd6f4;
      }
      #workspaces button.focused {
        background: #89b4fa;
        color: #1e1e2e;
      }
      #workspaces button.urgent {
        background: #f38ba8;
        color: #1e1e2e;
      }

      #window {
        background: transparent;
        color: #a6adc8;
        font-weight: 500;
        padding: 0;
        margin: 0;
      }

      #mode {
        background: #f38ba8;
        color: #1e1e2e;
        font-weight: 700;
        padding: 2px 14px;
        margin: 4px 8px 4px 2px;
        border-radius: 10px;
      }

      #clock {
        background: rgba(137, 180, 250, 0.15);
        color: #89b4fa;
        font-weight: 700;
      }

      #idle_inhibitor.activated {
        background: #f9e2af;
        color: #1e1e2e;
      }

      #custom-btop {
        color: #f38ba8;
      }

      #backlight { color: #f9e2af; }

      #pulseaudio { color: #cba6f7; }
      #pulseaudio.muted {
        background: #313244;
        color: #6c7086;
      }

      #network { color: #89b4fa; }
      #network.disconnected {
        background: #f38ba8;
        color: #1e1e2e;
      }

      #battery { color: #a6e3a1; }
      #battery.charging { color: #a6e3a1; }
      #battery.warning {
        background: #f9e2af;
        color: #1e1e2e;
      }
      #battery.critical {
        background: #f38ba8;
        color: #1e1e2e;
        animation: blink 1s infinite;
      }

      #tray {
        padding: 2px 10px;
      }
      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background: #f38ba8;
      }

      #custom-power {
        background: #f38ba8;
        color: #1e1e2e;
        margin-right: 4px;
        font-size: 14px;
      }
      #custom-power:hover {
        background: #eba0ac;
      }
    '';
  };
}
