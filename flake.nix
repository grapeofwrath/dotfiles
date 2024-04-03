{
  description = "Grapeofwrath's NixOS & Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    sops-nix.url = "github:Mic92/sops-nix";
    hyprland.url = "github:hyprwm/Hyprland";
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    nixpkgs,
    home-manager,
    hardware,
    sops-nix,
    ...
  }@inputs:
    let
      # Nix
      lib = nixpkgs.lib;
      mkPkgs = system:
        (import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = true;
        });
      # Personal
      libgrape = import ./lib/libgrape { inherit lib; };
      # Helper to turn ./thing/someprofile.nix to someprofile
      nameFromNixFile = file: lib.strings.removeSuffix ".nix" (baseNameOf file);
    in {
      nixosConfigurations = let
        systemDirs = libgrape.allSubDirs ./nixos/systems;
        mkConfig = dir:
          (let
            userData = import dir;
            system = userData.system;
            pkgs = mkPkgs system;
          in lib.nixosSystem {
            inherit pkgs system;
            modules = [ userData.module ];
            specialArgs = { inherit libgrape; };
          });
        in (builtins.listToAttrs (map (dir: {
          name = builtins.baseNameOf dir;
          value = mkConfig dir;
        }) systemDirs));

        homeConfigurations = let
          userDirs = libgrape.allSubdirs ./home-manager/homes;
          mkConfig = dir:
            (let
              userData = import dir;
              pkgs = mkPkgs userData.system;
            in home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [];
              extraSpecialArgs = { inherit libgrape; };
            });
          in (builtins.listToAttrs (map (file: {
            name = nameFromNixFile file;
            value = mkConfig file;
          }) userDirs));
    };
}
