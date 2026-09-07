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
