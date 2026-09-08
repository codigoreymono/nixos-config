{ pkgs, ... }:

{
  programs.nvf.settings.vim = {
    fzf-lua.enable = true;

    extraPackages = with pkgs; [
      fd
      ripgrep
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>FzfLua files<CR>";
        desc = "Find files";
        silent = true;
      }

      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>FzfLua live_grep<CR>";
        desc = "Find text";
        silent = true;
      }

      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>FzfLua buffers<CR>";
        desc = "Find buffers";
        silent = true;
      }

      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>FzfLua oldfiles<CR>";
        desc = "Recent files";
        silent = true;
      }
    ];
  };
}
