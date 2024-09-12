{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/base
    ./../../modules/desktop
    ./../../modules/users
  ];

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    virt-manager
    qemu
    qemu_kvm
  ];

  # Personal Modules
  users.additionalUsers = ["paramount"];

  base = {
    fish.enable = true;
    battery.enable = true;
    system.latestKernel = true;
    tailscale.enable = true;
    appimage.enable = true;
  };

  desktop = {
    hyprland.enable = true;
    plasma.enable = false;
    tty-login.enable = true;
  };

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "24.05";
}
