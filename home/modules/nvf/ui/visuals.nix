{ lib, ... }:

{
  programs.nvf.settings.vim = {
    options = {
      cursorline = true;
    };

    visuals.indent-blankline = {
      enable = true;

      setupOpts = {
        indent = {
          char = "│";
        };

        scope = {
          enabled = true;
          show_start = false;
          show_end = false;
        };
      };
    };

    diagnostics = {
      enable = true;

      config = {
        signs.text = lib.generators.mkLuaInline ''
          {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰌵 ",
          }
        '';

        underline = true;
        update_in_insert = false;

        virtual_text = false;
        virtual_lines = false;
      };
    };
  };
}
