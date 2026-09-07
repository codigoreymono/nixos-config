{ ... }:

{
  programs.nvf.settings.vim = {
    languages.lua = {
      enable = true;

      treesitter.enable = true;

      lsp = {
        enable = true;
        servers = [
          "lua-language-server"
        ];
      };

      format = {
        enable = true;
        type = [
          "stylua"
        ];
      };
    };

    autocmds = [
      {
        event = [ "FileType" ];
        pattern = [ "lua" ];
        command = "setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4";
        desc = "Lua indentation";
      }
    ];
  };
}
