SOURCES = $(shell find . -type f -iname "*.nix")

.PHONY: boot switch clean delete-old gc gc-gen update-deps
boot: $(SOURCES)
	sudo nixos-rebuild boot --flake '.#'

switch: $(SOURCES)
	sudo nixos-rebuild switch --flake '.#'

result: $(SOURCES)
	nixos-rebuild build --flake '.#'

delete-generations:
	sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5

gc:
	nix-collect-garbage -d

gc-gen: delete-generations gc

clean:
	rm result

update-deps:
	nix flake lock --update-input nixpkgs
	nix flake lock --update-input nixpkgs-unstable
	nix flake lock --update-input nixos-hardware
	nix flake lock --update-input home-manager
