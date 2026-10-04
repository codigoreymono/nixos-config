{ pkgs, ... }: {
  #APPS

  home.packages = with pkgs; [
    qbittorrent
    jellyfin-desktop
    htop
    fastfetch
    brave
    vlc
    imv
    curl
    xh
    zstd
    unrar
    p7zip
    hyperfine
    qsv
    yq-go
    jq
    tabiew
    visidata
    miller
    bat
    imagemagick
    file
    vscode
    obsidian
    dbeaver-bin
    ripgrep
    fd
    discord
    ffmpegthumbnailer
    xarchiver
    wifitui
    wiremix
    pkgs.calcurse
    pkgs.jolt-tui
    pkgs.tray-tui
    pkgs.rnote
    libreoffice-stable
  ];

}
