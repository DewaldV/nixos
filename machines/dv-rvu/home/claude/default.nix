{
  pkgs-unstable,
  ...
}:

{
  home.packages = [ pkgs-unstable.claude-code ];

  home.file.".claude/settings.json".source = ./settings.json;
}
