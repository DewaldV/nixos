SOURCES = $(shell find . -type f -iname "*.nix")

.PHONY: boot switch clean delete-old gc gc-old
boot: $(SOURCES)
	sudo nixos-rebuild boot --flake '.#'

switch: $(SOURCES)
	sudo nixos-rebuild switch --flake '.#'

result: $(SOURCES)
	nixos-rebuild build --flake '.#'

delete-old:
	sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old

gc:
	nix-collect-garbage -d

gc-old: delete-old gc

clean:
	rm result
