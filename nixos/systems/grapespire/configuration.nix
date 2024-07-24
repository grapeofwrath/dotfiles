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
  desktop = {
    gnome.enable = false;
    hyprland.enable = true;
    plasma.enable = false;
    tty-login.enable = true;
  };

  base = {
    fish.enable = true;
    battery.enable = true;
    system.latestKernel = true;
    tailscale.enable = true;
    appimage.enable = true;
  };

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "24.05";
}
