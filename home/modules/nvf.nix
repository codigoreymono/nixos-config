{ inputs, pkgs, ... }:
{
  imports = [ inputs.nvf.homeManagerModules.default ];

  home.packages = with pkgs; [
    ripgrep
    tree-sitter
  ];
  programs.nvf = {
    enable = true;

    settings.vim = {
      viAlias = true;
      vimAlias = true;
      dashboard.dashboard-nvim = {
              enable = true;
              setupOpts = {
                theme = "hyper";
                config = {
                  header = [
                    "                                        "
                    " ███╗   ██╗██╗   ██╗███████╗            "
                    " ████╗  ██║██║   ██║██╔════╝            "
                    " ██╔██╗ ██║██║   ██║█████╗              "
                    " ██║╚██╗██║╚██╗ ██╔╝██╔══╝              "
                    " ██║ ╚████║ ╚████╔╝ ██║                 "
                    " ╚═╝  ╚═══╝  ╚═══╝  ╚═╝                 "
                    "                                        "
                  ];
                  project.enable = false;
                };
              };
            };
     utility.surround.enable = true;
     ui.illuminate.enable = true;
     notes.todo-comments.enable = true; 
     autopairs.nvim-autopairs.enable = true;
     binds.whichKey.enable = true;
     luaConfigRC.surroundSetup = ''
             require('nvim-surround').setup({})
           '';
     utility.motion.flash-nvim = {
             enable = true;
             mappings = {
               jump = "<leader><leader>";
             };
           };
     
      visuals = {
        indent-blankline.enable = true;
      };

      ui = {
        colorizer.enable = true;
      };

      lsp = {
        enable= true;
        trouble.enable = true;
      };

      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };

      statusline.lualine.enable = true;
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;

      filetree.nvimTree = {
        enable = true;
        setupOpts.view.width = 30;
      };

      treesitter = {
        enable = true;
        context.enable = true;
      };

      languages = {
       
        nix.enable = true;

        python = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
        };

        tsx = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
        };

        html.enable = true;
        css.enable = true;
        markdown = {
           enable = true;
           extensions.render-markdown-nvim.enable = true;
        };
      };

      git = {
        enable = true;
        gitsigns.enable = true;
      };

      terminal.toggleterm.enable = true;

      keymaps = [
        {
          key = "<leader>e";
          mode = "n";
          silent = true;
          action = "<cmd>NvimTreeToggle<CR>";
        }
        {
          key = "<leader>ff";
          mode = "n";
          silent = true;
          action = "<cmd>Telescope find_files<CR>";
        }
        {
          key = "<leader>fg";
          mode = "n";
          silent = true;
          action = "<cmd>Telescope live_grep<CR>";
        }
      ];
    };
  };
}
