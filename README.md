# Irrenpi - NixOS on a Pi.
My personal little NixOS server configuration for a Raspberry Pi. Probably will be running mostly stupid stuff nobody really needs.

## Rebuild
`nixos-rebuild switch --flake .#irrenpi --target-host root@irrenpi.fritz.box`