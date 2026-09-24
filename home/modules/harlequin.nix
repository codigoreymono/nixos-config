{ pkgs, ... }:

{
  home.packages = [
    pkgs.harlequin
  ];

  xdg.configFile."harlequin/config.toml".text = ''
    default_profile = "default"

    [profiles.default]
    theme = "catppuccin-mocha"
  '';
}
