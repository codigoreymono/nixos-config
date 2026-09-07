{ ... }:

{
  programs.nvf.settings.vim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    options = {
      # Lines
      number = true;
      relativenumber = true;
      signcolumn = "yes";

      # Navigation
      scrolloff = 8;
      sidescrolloff = 8;
      wrap = false;

      # Search
      ignorecase = true;
      smartcase = true;

      # Splits
      splitbelow = true;
      splitright = true;

      # Editing
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;

      # Files
      undofile = true;
      confirm = true;

      # Responsiveness
      updatetime = 250;
      timeoutlen = 300;
    };
  };
}
