{ pkgs, inputs, ... }:
{
  imports = [
    ./boot.nix
    ./locales.nix
    ./networking.nix
    ./nix.nix
    ./user.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    git
    btop
    fastfetch
  ];
}
