{ ... }:

{
  programs.nvf.settings.vim = {
    languages.python = {
      enable = true;

      treesitter.enable = true;

      lsp = {
        enable = true;
        servers = [
          "basedpyright"
          "ruff"
        ];
      };

      format = {
        enable = true;
        type = [ "ruff" ];
      };
    };

    lsp.servers.ruff.capabilities.general.positionEncodings = [
      "utf-16"
    ];

    autocmds = [
      {
        event = [ "FileType" ];
        pattern = [ "python" ];
        command = "setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4";
        desc = "Python indentation";
      }
    ];
  };
}
