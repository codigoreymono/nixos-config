{ config, pkgs, ... }:
{
  programs.bash.shellAliases = {
    # Navegación
    ll = "ls -la";
    la = "ls -A";

    # NixOS
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#elitebook";
    nixcfg = "cd ~/nixos-config";

    # Git / lazygit
    lg = "lazygit";
    gs = "git status";

    # Yazi
  #  y = "y"; # ya viene del propio módulo de yazi (shellWrapperName), esto es solo referencia

    # Python / proyectos
    proyectos = "cd ~/proyectos";
  };
}
