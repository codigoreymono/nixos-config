{ ... }:

{
  virtualisation.docker.enable = true;

  users.users.reymono.extraGroups = [
    "docker"
  ];
}
