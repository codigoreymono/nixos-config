{ ... }:

{
  programs.nvf.settings.vim = {
    languages.sql = {
      enable = true;

      treesitter.enable = true;

      lsp = {
        enable = true;
        servers = [
          "sqls"
        ];
      };

      format = {
        enable = true;
        type = [
          "sqlfluff"
        ];
      };

      extraDiagnostics = {
        enable = true;
        types = [
          "sqlfluff"
        ];
      };
    };

    autocmds = [
      {
        event = [ "FileType" ];
        pattern = [ "sql" ];
        command = "setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4";
        desc = "SQL indentation";
      }
    ];
  };
}
