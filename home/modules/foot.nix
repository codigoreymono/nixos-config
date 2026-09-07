{ ... }:

{
  stylix.targets.foot.enable = true;

  programs.foot = {
    enable = true;

    settings = {
      main = {
        pad = "8x8";
      };

      cursor = {
        style = "block";
        blink = "no";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
