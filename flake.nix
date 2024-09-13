{
  description = "Irrenpi - NixOS on a Pi";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    schlag-o-meterer.url = "github:rubenhoenle/schlag-o-meterer";
    # formatter for *.nix files
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, ... }:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };
      lib = nixpkgs.lib;

      ssh-keys = {
        ssh-key-main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPk1h1lfFRthXiIA8UtWc5P5UmwZ2JjWiRv748Syx3jL";
        ssh-key-schlago = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB/dwv0ySSKyItRga5Ypeo1sBH3yDDKqOujMMeojSN30";
      };

      treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      formatter."x86_64-linux" = treefmtEval.config.build.wrapper;
      checks."x86_64-linux".formatter = treefmtEval.config.build.check self;

      nixosConfigurations = {
        irrenpi = lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            pkgs-unstable = pkgs-unstable;
            inputs = inputs;
            ssh-keys = ssh-keys;
          };

          modules = [
            ./hardware/hardware-configuration.nix
            ./modules/modules.nix
            ./services/services.nix
          ];
        };
      };
    };
}
