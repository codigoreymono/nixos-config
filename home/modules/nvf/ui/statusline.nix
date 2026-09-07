{ lib, ... }:

{
  programs.nvf.settings.vim.statusline.lualine = {
    enable = true;

    setupOpts = {
      options = {
        theme = "auto";
        globalstatus = true;

        component_separators = {
          left = "";
          right = "";
        };

        section_separators = {
          left = "";
          right = "";
        };
      };

      sections = {
        lualine_a = [
          "mode"
        ];

        lualine_b = [
          (lib.generators.mkLuaInline ''
            {
              "branch",
              icon = "",
            }
          '')
        ];

        lualine_c = [
          "filename"
        ];

        lualine_x = [
          (lib.generators.mkLuaInline ''
            {
              "diagnostics",
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = "󰌵 ",
              },
            }
          '')

          "filetype"
        ];

        lualine_y = [ ];

        lualine_z = [
          "location"
        ];
      };
    };
  };
}
