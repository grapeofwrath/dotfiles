{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./../modules/base
    ./../modules/desktop
    ./../modules/users
    ./../modules/gaming
    ./../modules/server
  ];

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    curl
    virt-manager
    qemu
    qemu_kvm
  ];

  # Personal Modules
  users.additionalUsers = ["paramount"];

  base = {
    battery.enable = true;
    latestKernel.enable = true;
    tailscale.enable = true;
    appimage.enable = true;
  };

  desktop = {
    hyprland.enable = true;
    plasma.enable = false;
    tty-login.enable = true;
  };

  gaming = {
    steam.enable = true;
  };

  server = {
    podman.enable = true;
  };

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "24.05";
}
