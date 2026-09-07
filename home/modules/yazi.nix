{ pkgs, ... }:

{
  # -------------------------------------------------------------------
  # GENERAL TOOLS
  # -------------------------------------------------------------------

  home.packages = with pkgs; [
    fd
    ripgrep

    imv

    # USB / MTP diagnostics
    usbutils
    glib
  ];

  # -------------------------------------------------------------------
  # YAZI
  # -------------------------------------------------------------------

  programs.yazi = {
    enable = true;

    enableBashIntegration = true;
    shellWrapperName = "y";

    # -----------------------------------------------------------------
    # INTERNAL TOOLS
    # -----------------------------------------------------------------

    extraPackages = with pkgs; [
      # File detection / editing
      file
      micro

      # Navigation / search
      fzf
      zoxide

      # Archives
      ouch

      # Previews
      jq
      poppler
      ffmpeg
      resvg
      imagemagick

      # Removable storage
      udisks2
      util-linux
      eject
    ];

    # -----------------------------------------------------------------
    # PLUGINS
    # -----------------------------------------------------------------

    plugins = {
      # Normal USB drives / block devices
      mount = pkgs.yaziPlugins.mount;

      # GVFS: Android MTP and other virtual filesystems
      gvfs = {
        package = pkgs.yaziPlugins.gvfs;
        setup = true;
      };

      # ouch extract
      ouch = pkgs.yaziPlugins.ouch;
    };

    # -----------------------------------------------------------------
    # SETTINGS
    # -----------------------------------------------------------------

    settings = {
      mgr = {
        sort_by = "natural";
        sort_dir_first = true;

        show_hidden = false;
        show_symlink = true;

        linemode = "size";
      };

      # ---------------------------------------------------------------
      # OPENERS
      # ---------------------------------------------------------------

      opener = {
        edit = [
          {
            run = "micro %s";
            block = true;
            desc = "Edit with Micro";
          }
        ];

        image = [
          {
            run = "imv %s";
            orphan = true;
            desc = "View with imv";
          }
        ];

        extract = [
          {
            run = "ouch d -y %s";
            desc = "Extract here with ouch";
            for = "unix";
          }
        ];

      };

      # ---------------------------------------------------------------
      # OPEN RULES
      # ---------------------------------------------------------------

      open = {
        prepend_rules = [
          {
            mime = "image/*";
            use = "image";
          }

          {
            mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio}";
            use = "extract";
          }

          {
            mime = "text/*";
            use = "edit";
          }

          {
            url = "*.nix";
            use = "edit";
          }

          {
            url = "*.py";
            use = "edit";
          }

          {
            url = "*.md";
            use = "edit";
          }

          {
            url = "*.txt";
            use = "edit";
          }

          {
            url = "*.json";
            use = "edit";
          }

          {
            url = "*.toml";
            use = "edit";
          }

          {
            url = "*.yaml";
            use = "edit";
          }

          {
            url = "*.yml";
            use = "edit";
          }

          {
            url = "*.lua";
            use = "edit";
          }

          {
            url = "*.qml";
            use = "edit";
          }
        ];
      };

      # ---------------------------------------------------------------
      # GVFS / MTP
      # ---------------------------------------------------------------

      plugin = {
        # MTP can be slow. Avoid automatically preloading and previewing
        # every file from the phone.
        prepend_preloaders = [
          {
            url = "/run/user/1000/gvfs/**/*";
            run = "noop";
          }
        ];

        prepend_previewers = [

          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch";
          }

          {
            url = "/run/user/1000/gvfs/**/*";
            run = "noop";
          }
        ];
      };
    };

    # -----------------------------------------------------------------
    # ICONS
    # -----------------------------------------------------------------

    theme = {
      icon = {
        prepend_conds = [
          {
            "if" = "dir";
            text = "";
            fg = "#d7d7dc";
          }

          {
            "if" = "!dir";
            text = "";
            fg = "#b6b6bb";
          }
        ];
      };

      mode = {
        normal_main = {
          fg = "#d7d7dc";
          bg = "#232326";
          bold = true;
        };

        normal_alt = {
          fg = "#7a7a80";
          bg = "#151517";
        };
      };
    };

    # -----------------------------------------------------------------
    # KEYBINDS
    # -----------------------------------------------------------------

    keymap = {
      mgr.prepend_keymap = [
        # -------------------------------------------------------------
        # USB / BLOCK DEVICES
        # -------------------------------------------------------------

        {
          on = [ "M" ];
          run = "plugin mount";
          desc = "Mount manager";
        }

        # -------------------------------------------------------------
        # GVFS / ANDROID / MTP
        # -------------------------------------------------------------

        {
          on = [ "g" "v" ];
          run = "plugin gvfs -- select-then-mount --jump";
          desc = "Mount GVFS device and open";
        }

        {
          on = [ "g" "x" ];
          run = "plugin gvfs -- select-then-unmount";
          desc = "Unmount GVFS device";
        }

        {
          on = [ "g" "j" ];
          run = "plugin gvfs -- jump-to-device";
          desc = "Open mounted GVFS device";
        }

        {
          on = [ "g" "e" ];
          run = "plugin gvfs -- select-then-unmount --eject";
          desc = "Unmount and eject GVFS device";
        }

        # -------------------------------------------------------------
        # ARCHIVES
        # -------------------------------------------------------------

        {
          on = [ "C" ];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }


      ];
    };
  };
}
