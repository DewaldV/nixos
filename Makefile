SOURCES = $(shell find . -type f -iname "*.nix")

.PHONY: boot switch build clean
boot: $(SOURCES)
	sudo nixos-rebuild boot --flake '.#'

switch: $(SOURCES)
	sudo nixos-rebuild switch --flake '.#'

result: $(SOURCES)
	nixos-rebuild build --flake '.#'

clean:
	rm result
