{ ... }:

{
  programs.nvf.settings.vim = {
    languages.nix = {
      enable = true;

      treesitter.enable = true;

      lsp = {
        enable = true;
        servers = [ "nil" ];
      };

      format = {
        enable = true;
        type = [ "alejandra" ];
      };

      extraDiagnostics = {
        enable = true;
        types = [
          "statix"
          "deadnix"
        ];
      };
    };

    autocmds = [
      {
        event = [ "FileType" ];
        pattern = [ "nix" ];
        command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2";
        desc = "Nix indentation";
      }
    ];
  };
}
