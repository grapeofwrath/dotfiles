{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./../modules/base
    ./../modules/desktop
    ./../modules/users
    ./../modules/gaming
  ];

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    virt-manager
    qemu
    qemu_kvm
    bottles
  ];

  # Personal Modules
  base = {
    appimage.enable = true;
    bluetooth.enable = true;
    fish.enable = true;
    system.latestKernel = true;
    tailscale.enable = true;
    vmware.enable = false;
  };

  desktop = {
    hyprland.enable = false;
    plasma.enable = true;
    tty-login.enable = false;
  };

  gaming = {
    steam.enable = true;
    sunshine.enable = false;
  };

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "24.05";
}
