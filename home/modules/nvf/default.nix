{ ... }:

{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./treesitter.nix
    ./completion.nix
    ./autopairs.nix
    ./languages
    ./ui
    ./plugins



  ];

##################

  programs.nvf = {
    enable = true;
    enableManpages = true;

    settings.vim = {
      viAlias = true;
      vimAlias = true;
    };
  };
}
