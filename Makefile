SOURCES = $(shell find . -type f -iname "*.nix")

.PHONY: boot switch home-manager-switch clean delete-old gc gc-gen update-deps diff
boot: $(SOURCES)
	nixos-rebuild boot --flake '.#' --sudo

switch: $(SOURCES)
	nixos-rebuild switch --flake '.#' --sudo

home-manager-switch: $(SOURCES)
	home-manager switch --flake '.#dewaldv'

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
