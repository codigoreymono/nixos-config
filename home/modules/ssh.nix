{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
      };

      "lanix" = {
        HostName = "192.168.1.100";
        User = "data2";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };

      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };
    };
  };
}
