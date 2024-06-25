{inputs,config,pkgs,lib,...}: {
  imports = [
    ./hardware-config.nix
    ../../modules
  ];
  orion = {
    battery = {
      enable = true;
    };
    interwebs = {
      hostName = "grapetop";
    };
    system.latestKernel = true;
    tailscale.enable = true;
    tools.appimage.enable = true;
    desktop = {
      auto-login.enable = false;
      gnome.enable = true;
      hyprland.enable = true;
      plasma.enable = false;
    };
    gaming = {
      steam.enable = true;
    };
  };
  virtualisation.libvirtd.enable = true;
  #services.displayManager.sddm.theme = "${import ./sddm-theme.nix {inherit pkgs;}}";
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    virt-manager
    qemu
    qemu_kvm
  ];

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "23.11";
}
