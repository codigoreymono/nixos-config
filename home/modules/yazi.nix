{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    fd        # búsqueda rápida de archivos (usada por yazi para fuzzy find)
    ripgrep   # búsqueda de contenido dentro de archivos (usada por yazi y telescope)
    imv       # visor de imágenes para Wayland
  ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    shellWrapperName = "y";

    settings = {
      opener = {
        edit = [
          { run = ''micro "$@"''; block = true; desc = "Editar con micro"; }
        ];
        image = [
          { run = ''imv "$@"''; desc = "Ver con imv"; orphan = true; }
        ];
      };

      open = {
        rules = [
          { mime = "image/*"; use = "image"; }
          { mime = "text/*"; use = "edit"; }
          { url = "*.nix"; use = "edit"; }
          { url = "*.py"; use = "edit"; }
          { url = "*.md"; use = "edit"; }
          { url = "*.txt"; use = "edit"; }
          { url = "*.json"; use = "edit"; }
          { url = "*.toml"; use = "edit"; }
          { mime = "*"; use = "edit"; }
        ];
      };
    };
  };
}
