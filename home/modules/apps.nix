{ pkgs, ... }: {
  #APPS

  home.packages = with pkgs; [
    htop
    fastfetch
    brave
    vlc
    imv
    vscode
    harlequin
    obsidian
    dbeaver-bin
    ripgrep
    discord
    ffmpegthumbnailer
    xarchiver
    wifitui
    wiremix
    pkgs.calcurse
    pkgs.jolt-tui
    pkgs.tray-tui
    pkgs.rnote
  ];

}
