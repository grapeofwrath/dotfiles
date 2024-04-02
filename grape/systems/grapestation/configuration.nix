{config,lib,pkgs,...}: {
  imports = [
    ./hardware-config.nix
    ../modules/nixos
  ];
  orion = {
    hardware.bluetooth.enable = true;
    system.latestKernel = true;
  };
}
