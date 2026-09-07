{ ... }:

{
  programs.nvf.settings.vim.keymaps = [
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>write<CR>";
      desc = "Save file";
      silent = true;
    }

    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>quit<CR>";
      desc = "Quit window";
      silent = true;
    }

    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      desc = "Clear search highlight";
      silent = true;
    }

    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      desc = "Focus left window";
      silent = true;
    }

    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      desc = "Focus lower window";
      silent = true;
    }

    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      desc = "Focus upper window";
      silent = true;
    }

    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      desc = "Focus right window";
      silent = true;
    }
  ];
}
