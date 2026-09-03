{ pkgs, ... }:

{
  programs.micro = {
    enable = true;

    settings = {
      # Apariencia
      colorscheme = "simple";
      truecolor = "on";
      cursorline = true;
      scrollbar = true;

      # Edición
      autoclose = true;
      autoindent = true;
      tabstospaces = true;
      tabsize = 2;

      # Archivos
      eofnewline = true;
      rmtrailingws = true;
      mkparents = true;

      # Ayudas visuales
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
