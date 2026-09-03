{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # --- Sway (Wayland) ---
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.pam.services.swaylock = {};#swaylock
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
# --- Fuentes ---
  fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
    ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" ];
    sansSerif = [ "Noto Sans" ];
    emoji = [ "Noto Color Emoji" ];
  };

  # Servicios Laptop
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };

    services.thermald.enable = true;
    services.fstrim.enable = true;
    services.fwupd.enable = true;

    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };

  # --- Autologin en tty1 ---
  services.getty.autologinUser = "reymono";

  # --- Gráficos Intel (HP EliteBook 850 G3 / Skylake) ---
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver intel-vaapi-driver libvdpau-va-gl ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."reymono" = {
    isNormalUser = true;
    description = "AndresC";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "libvirtd" ];
    packages = with pkgs; [];
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    micro
    tree
    brightnessctl
    wev
    networkmanagerapplet
    pavucontrol
    networkmanager_dmenu
    grim
    slurp
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

   programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;  # soporte TPM virtual, útil para VMs con Windows 11 por ejemplo
      };
    };

  system.stateVersion = "26.05";
}
