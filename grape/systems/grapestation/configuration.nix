{config,lib,pkgs,...}: {
  imports = [
    ./hardware-config.nix
    ../modules
  ];
  orion = {
    hardware.bluetooth.enable = true;
    system.latestKernel = true;
  };
}
