{ config, pkgs, ... }:
{
  programs.bash.shellAliases = {

    ll = "ls -la";
    la = "ls -A";

    # NixOS
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#elitebook";
    nixcfg = "cd ~/nixos-config";

    # Git / lazygit
    lg = "lazygit";
    gs = "git status";

  };
}
