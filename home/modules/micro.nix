{ pkgs, ... }:

{
  programs.micro = {
    enable = true;

    settings = {

      colorscheme = "simple";
      truecolor = "on";
      cursorline = true;
      scrollbar = true;


      autoclose = true;
      autoindent = true;
      tabstospaces = true;
      tabsize = 2;


      eofnewline = true;
      rmtrailingws = true;
      mkparents = true;


      ruler = true;
      hlsearch = true;
      hltaberrors = true;
      hltrailingws = true;
    };
  };

  home.packages = with pkgs; [
    nixfmt
  ];

  home.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };
}
