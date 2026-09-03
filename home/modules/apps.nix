{ pkgs, ... }: {
  #APPS

  home.packages = with pkgs; [
    htop
    btop
    fastfetch
    brave
    vlc
    imv
    vscode
    harlequin
    obsidian
    dbeaver-bin
    ripgrep

  ];

}
