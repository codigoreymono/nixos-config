{ pkgs, ... }:

{
  home.packages = with pkgs; [
    openspec
  ];
}
