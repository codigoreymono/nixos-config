{ config, pkgs, ... }:
{

home.packages = with pkgs; [
    swaybg
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = {
      terminal = "foot";
      menu = "fuzzel";
      modifier = "Mod4";
      bars = []; # la barra la maneja waybar.nix, no sway directamente

      startup = [
        { command = "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"; }
        { command = "systemctl --user start graphical-session.target"; }
        { command = "swaybg -i /home/reymono/Pictures/wallpapers/jellyfish.jpg -m fill"; }
      ];

      

# config del touchpad

input = {
        "type:touchpad" = {
          tap = "enabled";                # tocar para hacer click (sin necesidad de presionar físicamente)
          natural_scroll = "enabled";      # scroll estilo "trackpad de mac" (invertido respecto a mouse tradicional)
          dwt = "enabled";                 # disable-while-typing: ignora el touchpad mientras escribes
          click_method = "clickfinger";    # click derecho = 2 dedos, click medio = 3 dedos (sin zonas físicas)
          accel_profile = "adaptive";      # aceleración de puntero suave
          pointer_accel = "0.3";           # sensibilidad extra (rango -1 a 1, ajusta a gusto)
        };
        "type:keyboard" = {
                  xkb_layout = "us";  # o "us", según prefieras
                };
      };



 # Quita la barra de título; deja solo un borde delgado (o "none" para nada)
      window.border = 1;
      window.titlebar = false;

      floating.border = 1;
      floating.titlebar = false;

   workspaceOutputAssign = [
        { workspace = "1"; output = "eDP-1"; }
        { workspace = "2"; output = "DP-2"; }
      ];

# Pantallas
#principal
output = {
  "eDP-1" = {
    mode = "1920x1080@60.005Hz";
    position = "0,0";
    scale = "1";
  };
  #secundaria
  "DP-2" = {
    mode = "1360x768@60.015Hz";
    position = "1920,0";
    scale = "1";
  };
};




      
    };
    extraConfig = ''
    
      exec waybar
      
      # --- Volumen ---
            bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
            bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            bindsym XF86AudioMicMute exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      
            # --- Brillo ---
            bindsym XF86MonBrightnessUp exec brightnessctl set 5%+
            bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
      
            # --- WiFi / modo avión ---
            bindsym XF86RFKill exec nmcli radio wifi toggle

            # ── NUEVO: Atajos del clipboard ──
                  bindsym Mod4+Shift+v exec cliphist-fuzzel
                  bindsym Mod4+Shift+Delete exec clipboard-clear

            # ── NUEVO: Capturas de pantalla ──
                  # Pantalla completa → guarda en ~/Pictures/
                  bindsym Print exec grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png
            
                  # Seleccionar área → guarda en ~/Pictures/
                  bindsym Shift+Print exec grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png
            
                  # Seleccionar área → copia al portapapeles (para pegar directo)
                  bindsym Ctrl+Shift+Print exec grim -g "$(slurp)" - | wl-copy

                  #Thunar
                  bindsym Mod4+Shift+f exec thunar 

                  
            
    '';
  };
}
