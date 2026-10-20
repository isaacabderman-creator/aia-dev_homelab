{
  description = "nixos@aiadev";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # Must have this!

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Settle API, pushed from the laptop to the bare repo ~/settle-backend.git.
    # Update with: nix flake update settle-backend
    settle-backend = {
      url = "git+file:///home/iai/settle-backend.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Settle AI service (internal, called by the API), pushed to the bare repo ~/settle-ai.git.
    # Update with: nix flake update settle-ai
    settle-ai = {
      url = "git+file:///home/iai/settle-ai.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, settle-backend, settle-ai, ... }:
    let
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nixos/default.nix
          settle-backend.nixosModules.default
          settle-ai.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit unstable; }; # The Pass
            home-manager.users.iai = import ./home/iai/default.nix;
          }
        ];
      };
    };
}
