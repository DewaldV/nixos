.PHONY: boot
boot:
	sudo nixos-rebuild boot --flake '.#'

.PHONY: switch
switch:
	sudo nixos-rebuild switch --flake '.#'
