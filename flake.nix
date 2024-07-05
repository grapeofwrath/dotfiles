{
  description = "Grapeofwrath's NixOS & Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";
    sops-nix.url = "github:Mic92/sops-nix";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    ags.url = "github:Aylur/ags";
    nix-colors.url = "github:misterio77/nix-colors";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jot.url = "github:grapeofwrath/jot";
    phortune.url = "github:grapeofwrath/phortune";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    lib = nixpkgs.lib;
    libgrape = import ./lib/libgrape {inherit lib;};
  in {
    # Accessible through 'nix build', 'nix shell', etc
    #packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter for your nix files, available through 'nix fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      grapelab = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs libgrape;};
        modules = [
          ./nixos/systems/grapelab/configuration.nix
        ];
      };
      grapespire = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs libgrape;};
        modules = [
          ./nixos/systems/grapespire/configuration.nix
        ];
      };
      grapestation = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs libgrape;};
        modules = [
          ./nixos/systems/grapestation/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "grape-grapelab" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs libgrape;};
        modules = [
          ./home-manager/homes/grape-grapelab/home.nix
        ];
      };
      "grape-grapespire" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs libgrape;};
        modules = [
          ./home-manager/homes/grape-grapespire.nix
        ];
      };
      "grape-grapestation" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs libgrape;};
        modules = [
          ./home-manager/homes/grape-grapestation/home.nix
        ];
      };
    };
  };
}
