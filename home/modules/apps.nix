{ pkgs, ... }: {
  #APPS
  
  home.packages = with pkgs; [
    htop
    btop
    fastfetch
    brave
    vlc
    imv
    vscodium
    harlequin
    dbeaver-bin
    obsidian
    
  ];

}
