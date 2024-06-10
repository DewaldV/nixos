{ config, pkgs, ... }:

{
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        indent_style = "space";
        indent_size = 2;
        insert_final_newline = true;
        trim_trailing_whitespace = true;
      };

      "*.md" = {
        trim_trailing_whitespace = false;
      };
      "*.go" = {
        indent_style = "tab";
      };
      "*.rs" = {
        indent_size = 4;
      };
      "Makefile" = {
        indent_style = "tab";
      };
    };
  };
}
