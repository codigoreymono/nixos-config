{ ... }:
{
  programs.bash.shellAliases = {

    ll = "ls -la";
    la = "ls -A";

    # NixOS
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#elitebook";
    nixcfg = "cd ~/nixos-config";

    nix-gens = "sudo nix-env --profile /nix/var/nix/profiles/system --list-generations";
    nix-keep-10 = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +10";

    nix-gc = "sudo nix-collect-garbage --delete-older-than 30d";
    nix-optimize = "sudo nix-store --optimise";
    nix-clean = "sudo nix-collect-garbage --delete-older-than 30d && sudo nix-store --optimise";

    # Git / lazygit
    lg = "lazygit";
    gs = "git status";

  };
}
