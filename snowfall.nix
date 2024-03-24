{
  description = "NixOS config for my systems built with Snowfall";

  inputs = {
    # TODO add stable branch to use as well
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    sops-nix.url = "github:Mic92/sops-nix";

    # hyprland.url = "github:hyprwm/Hyprland";
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkFlake {
      inherit inputs;
      # root of the flake
      src = ./.;
      # optional snowfall settings
      snowfall = {
        # metadata for tools like snowfall frost
        meta = {
          # slug for use in docs when displaying things like file paths
          name = "orion";
          title = "Orion";
        };
        # used for flake packages, library, and overlays
        namespace = "orion";
      };
    };
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };
      # modules applied to all systems
      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
      ];
      # nixos configurations
      systems.hosts = {
        grapestation.modules = with inputs; [
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd
        ];
      };
    };
}
