{ ... }:

{
  programs.nvf.settings.vim.presence."cord-nvim" = {
    enable = true;

    setupOpts = {
      editor = {
        client = "neovim";
        tooltip = "Neovim";
      };

      display = {
        theme = "default";
        flavor = "accent";
        view = "full";
        swap_icons = false;
      };
    };
  };
}
