SOURCES = $(shell find . -type f -iname "*.nix")

.PHONY: boot switch clean delete-old gc gc-gen update-deps diff
boot: $(SOURCES)
	nixos-rebuild boot --flake '.#' --sudo

switch: $(SOURCES)
	nixos-rebuild switch --flake '.#' --sudo

result: $(SOURCES)
	nixos-rebuild build --flake '.#'

diff: result
	nvd diff /run/current-system ./result

delete-generations:
	sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5

gc:
	nix-collect-garbage -d

gc-gen: delete-generations gc

clean:
	rm -f result

update:
	nix flake update
