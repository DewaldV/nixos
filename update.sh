#! /usr/bin/env sh

nix flake lock --update-input nixpkgs
nix flake lock --update-input nixpkgs-unstable
nix flake lock --update-input nixos-hardware
nix flake lock --update-input home-manager
