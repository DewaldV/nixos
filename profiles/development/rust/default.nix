{ config, pkgs, ... }:

{
  home.file.".cargo/config.toml".source = ./cargo/config.toml;
}
