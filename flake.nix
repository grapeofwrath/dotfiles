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
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

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
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # custom
    gLib = import ./lib {inherit (nixpkgs) lib;};
    gVar = import ./var {inherit gLib;};
  in {
    # TODO
    # Add devshell to flake

    # Accessible through 'nix build', 'nix shell', etc
    # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = builtins.listToAttrs (map (host: {
        name = host;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs gLib gVar host;};
          modules = [
            ./nixos/systems/${host}/configuration.nix
          ];
        };
      })
      gVar.hostNames);

    homeConfigurations = builtins.listToAttrs (map (homeFile: let
        splitName = nixpkgs.lib.strings.splitString "-" homeFile;
        host = nixpkgs.lib.strings.removeSuffix ".nix" (nixpkgs.lib.lists.last splitName);
        username = builtins.head splitName;
        # homeName = "${username}-${host}";
        # homePath = "${homeName}.nix";
      in {
        name = "${username}-${host}";
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs gLib gVar host username;};
          modules = [
            ./home-manager/homes/${homeFile}
          ];
        };
      })
      gVar.homeNames);
  };
}
