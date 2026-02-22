{
  pkgs-unstable,
  ...
}:

{
  # AI agent tools
  home.packages = [
    pkgs-unstable.claude-code
    pkgs-unstable.codex
    pkgs-unstable.opencode
    pkgs-unstable.opencode-desktop
  ];

  # Agent skills
  home.file.".config/opencode/skills/sudo/SKILL.md".source = ./skills/sudo/SKILL.md;
}
