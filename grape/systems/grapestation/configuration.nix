{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-config.nix
    ../../modules/nixos
  ];
}
