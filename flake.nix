{
  description = "ethan's nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      # intentionally not following nixpkgs — see readme
    };
  };

  outputs = { self, nixpkgs, home-manager, agenix, catppuccin, noctalia, ... }@inputs:
  let
    user = {
      name     = "ethan";
      gitName  = "ethandhershey";
      gitEmail = "ethandhershey@gmail.com";
    };

    mkHost = system: hostName: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs user; };
      modules = [
        ./hosts/${hostName}
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.backupFileExtension = "backup";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [
            catppuccin.homeModules.catppuccin
          ];
        }
      ];
    };
  in {
    nixosConfigurations = {
      homelab = mkHost "x86_64-linux" "homelab";
      matcha = mkHost "x86_64-linux" "matcha";
      framework  = mkHost "x86_64-linux" "framework";
    };
  };
}
