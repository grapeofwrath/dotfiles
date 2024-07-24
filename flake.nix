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
    #lib = nixpkgs.lib;
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # custom lib
    glib = import ./lib {inherit (nixpkgs) lib;};

    hostNames = glib.allSubdirs ./nixos/systems;
    username = "marcus";
  in {
    # TODO
    # Add devshell to flake

    # Accessible through 'nix build', 'nix shell', etc
    #packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = builtins.listToAttrs (builtins.map (h: let
        host = builtins.baseNameOf h;
      in {
        name = host;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs glib username host;};
          modules = [
            ./nixos/systems/${host}/configuration.nix
          ];
        };
      })
      hostNames);

    homeConfigurations = builtins.listToAttrs (builtins.map (h: let
        host = builtins.baseNameOf h;
      in {
        name = "${username}-${host}";
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs glib username host;};
          modules = [
            ./home-manager/homes/${username}-${host}.nix
          ];
        };
      })
      hostNames);
  };
}
