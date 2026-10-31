.DEFAULT_GOAL := help

HOME_SRV_HOST ?= dewaldv@192.168.0.10

.PHONY: help result boot switch diff \
	home-srv-boot home-srv-switch home-srv-delete-generations home-srv-gc home-srv-gc-gen \
	home-manager-switch home-manager-delete-generations home-manager-gc \
	darwin-build darwin-switch delete-generations gc gc-gen clean update

help:
	@printf '%s\n' \
		'NixOS:' \
		'  result                           Build without activating (creates ./result)' \
		'  boot                             Build and activate on next boot' \
		'  switch                           Build and activate now' \
		'  diff                             Build and compare with the running system' \
		'Remote server (override with HOME_SRV_HOST=user@host):' \
		'  home-srv-boot                    Build and activate on next remote boot' \
		'  home-srv-switch                  Build and activate the remote server' \
		'  home-srv-delete-generations      Keep the last five remote system generations' \
		'  home-srv-gc                      Collect remote system garbage without deleting generations' \
		'  home-srv-gc-gen                  Prune remote generations, then collect garbage' \
		'Home Manager:' \
		'  home-manager-switch              Build and activate the home configuration' \
		'  home-manager-delete-generations  Delete generations older than five days' \
		'  home-manager-gc                  Expire home generations, then collect garbage' \
		'nix-darwin:' \
		'  darwin-build                     Build without activating' \
		'  darwin-switch                    Build and activate now' \
		'Maintenance:' \
		'  delete-generations               Keep the last five system generations' \
		'  gc                               Collect garbage without deleting generations' \
		'  gc-gen                           Prune system generations, then collect garbage' \
		'  clean                            Remove ./result' \
		'  update                           Update flake inputs'

# NixOS
result:
	nixos-rebuild build --flake '.#'

boot:
	nixos-rebuild boot --flake '.#' --sudo

switch:
	nixos-rebuild switch --flake '.#' --sudo

diff: result
	nvd diff /run/current-system ./result

# Remote server
home-srv-boot home-srv-switch: home-srv-%:
	nixos-rebuild $* --flake '.#home-srv' --target-host '$(HOME_SRV_HOST)' --sudo --ask-sudo-password

home-srv-delete-generations:
	ssh -t '$(HOME_SRV_HOST)' sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5

home-srv-gc:
	ssh -t '$(HOME_SRV_HOST)' sudo nix-collect-garbage

home-srv-gc-gen: home-srv-delete-generations
	$(MAKE) home-srv-gc

# Home Manager
home-manager-switch:
	home-manager switch --flake '.#dewaldv'

home-manager-delete-generations:
	home-manager expire-generations "-5 days"

home-manager-gc: home-manager-delete-generations
	$(MAKE) gc

# nix-darwin
darwin-build:
	darwin-rebuild build --flake '.#'

darwin-switch:
	sudo darwin-rebuild switch --flake '.#'

# Maintenance
delete-generations:
	sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5

gc:
	nix-collect-garbage

gc-gen: delete-generations
	$(MAKE) gc

clean:
	rm -f result

update:
	nix flake update
