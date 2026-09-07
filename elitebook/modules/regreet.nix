{ ... }:

{
  services.displayManager.regreet = {
    enable = true;

    cageArgs = [
      "-s"
      "-d"
      "-m"
      "last"
    ];
  };
}
