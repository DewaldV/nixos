# Agent Guidelines for NixOS Configuration

## Build/Test Commands
- **Build config**: `make result` (creates `result` symlink without activating)
- **Apply config**: `make switch` (builds and activates immediately)
- **Apply on reboot**: `make boot` (builds and sets as default for next boot)
- **Update flake inputs**: `make update`
- **Format Nix files**: `nixfmt-rfc-style <file.nix>` (use RFC 166 style)
- **No test suite**: This is a declarative configuration repo with no automated tests

## Code Style
- **Language**: Nix expressions following RFC 166 formatting style
- **Imports**: Use relative paths (e.g., `./module.nix`, `../common`); group in `imports = [ ]` lists
- **Formatting**: 2-space indentation, trailing semicolons, format with `nixfmt-rfc-style`
- **Function args**: Multi-line attribute sets with one parameter per line, closed with `}:`
- **Let bindings**: Use `let ... in` for local variables; prefer descriptive names
- **Packages**: Use `with pkgs;` for package lists; prefix unstable packages with `pkgs-unstable.`
- **Comments**: Inline for configuration context (e.g., `# Boot`, `# Services`)
- **Naming**: Use kebab-case for files/directories (e.g., `my-module.nix`); snake_case for Nix attributes

## Architecture
- **Structure**: Flake-based with `mkHost` and `mkHome` helper functions in `lib/`
- **Machines**: Per-machine configs in `machines/<name>/` with NixOS config and home-manager config
- **Profiles**: Shared config profiles in `profiles`
- **Never modify**: `flake.lock` manually; `system.stateVersion` values
