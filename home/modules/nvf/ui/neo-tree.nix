{ ... }:
{
  programs.nvf.settings.vim = {
    filetree.neo-tree = {
      enable = true;
    };

    keymaps = [
      {
        key = "<leader>e";
        mode = "n";
        action = "<cmd>Neotree toggle<CR>";
        silent = true;
        desc = "Toggle file explorer";
      }
    ];
  };
}
