{
  description = "Grapeofwrath's NixOS & Home Manager configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    #nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware.url = "github:nixos/nixos-hardware";
    sops-nix.url = "github:Mic92/sops-nix";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    stylix.url = "github:danth/stylix";
    nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    jot.url = "github:grapeofwrath/jot";
    phortune.url = "github:grapeofwrath/phortune";
  };
  outputs = {
    nixpkgs,
    home-manager,
    hardware,
    sops-nix,
    stylix,
    nixvim,
    ...
  }@inputs:
    let
      # Nix
      lib = nixpkgs.lib;
      mkPkgs = system:
        (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (_: _: {
              jot = inputs.jot.packages.${system}.default;
              phortune = inputs.phortune.packages.${system}.default;
            })
          ];
        });
      # Personal
      libgrape = import ./lib/libgrape { inherit lib; };
      nameFromNixFile = file: lib.strings.removeSuffix ".nix" (baseNameOf file);
    in {
      nixosConfigurations = let
        systemDirs = libgrape.allSubdirs ./nixos/systems;
        mkConfig = dir:
          (let
            userData = import dir;
            system = userData.system;
            pkgs = mkPkgs system;
          in lib.nixosSystem {
            inherit pkgs system;
            modules = [ userData.module ];
            specialArgs = { inherit inputs libgrape; };
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
            modules = [ userData.module ];
            extraSpecialArgs = { inherit inputs libgrape; };
          });
      in (builtins.listToAttrs (map (file: {
        name = nameFromNixFile file;
        value = mkConfig file;
      }) userDirs));
    };
}
