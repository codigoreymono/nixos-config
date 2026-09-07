{ config, pkgs, ... }:

{
  imports = [
    ./modules/regreet.nix
    ./modules/stylix.nix
  ];

  # =================================================================
  # NIXOS CONFIGURATION
  # =================================================================


  # -----------------------------------------------------------------
  # BOOT
  # -----------------------------------------------------------------

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # -----------------------------------------------------------------
  # NETWORK & LOCALE
  # -----------------------------------------------------------------

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Mexico_City";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";


  # -----------------------------------------------------------------
  # DESKTOP / WAYLAND
  # -----------------------------------------------------------------

  # --- SWAY ---------------------------------------------------------

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.pam.services.swaylock = {};


  # --- HYPRLAND -----------------------------------------------------

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };


  # --- DESKTOP INTEGRATION ------------------------------------------

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  programs.dconf.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;

  # -----------------------------------------------------------------
  # FONTS
  # -----------------------------------------------------------------

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


  # -----------------------------------------------------------------
  # POWER MANAGEMENT
  # -----------------------------------------------------------------

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

  services.upower.enable = true;

  # -----------------------------------------------------------------
  # KEYRING CONFIG
  # -----------------------------------------------------------------

  services.gnome.gnome-keyring.enable = true;

  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    hyprlock = {};
  };


  # -----------------------------------------------------------------
  # GRAPHICS
  # -----------------------------------------------------------------

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };


  # -----------------------------------------------------------------
  # AUDIO
  # -----------------------------------------------------------------

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;
  };


  # -----------------------------------------------------------------
  # PRINTING
  # -----------------------------------------------------------------

  services.printing.enable = true;


  # -----------------------------------------------------------------
  # USERS
  # -----------------------------------------------------------------

  users.users.reymono = {
    isNormalUser = true;
    description = "AndresC";

    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "libvirtd"
    ];
  };


  # -----------------------------------------------------------------
  # SYSTEM PROGRAMS & PACKAGES
  # -----------------------------------------------------------------

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    tree
    brightnessctl
    wev
    networkmanagerapplet
    pavucontrol
    networkmanager_dmenu
    grim
    slurp
  ];


    programs.thunar = {
      enable = true;

      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };


  # -----------------------------------------------------------------
  # NIX
  # -----------------------------------------------------------------

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  # -----------------------------------------------------------------
  # SESSION VARIABLES
  # -----------------------------------------------------------------

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";

    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };


  # -----------------------------------------------------------------
  # VIRTUALIZATION
  # -----------------------------------------------------------------

  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };


  # -----------------------------------------------------------------
  # STATE VERSION
  # -----------------------------------------------------------------

  system.stateVersion = "26.05";
}
