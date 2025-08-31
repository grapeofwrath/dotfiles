{
  config,
  pkgs,
  defaultUser,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../modules/base
    ./../modules/desktop
    ./../modules/users
  ];

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    qemu
    qemu_kvm
    xdotool
    xorg.xwininfo
    yad
    # gaming specific
    steam-run
    protonup-qt
    wineWowPackages.unstableFull
  ];

  users.users.${defaultUser} = {
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "input"
    ];
    # packages = with pkgs; [
    # ];
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };

  hardware.graphics = {
    # I'm pretty positive that this is the same RADV package as vulkan-radeon on Arch.
    # Which is why i don't use pkgs.amdvlk and pkgs.driversi686Linux like the NixOS wiki suggests.
    # AMD
    enable32Bit = true;
    # NVIDIA
    enable = true;
  };

  # NVIDIA
  # services.xserver.videoDrivers = ["nvidia"];
  # hardware.nvidia.open = false;

  # Personal Modules
  hyprland.enable = true;
  plasma = {
    enable = true;
    autoLogin = false;
  };

  tailscaleAutoConnect = {
    enable = true;
    authkeyFile = config.sops.secrets.tailscale_key.path;
    loginServer = "https://login.tailscale.com";
  };

  # Believe it or not, if you change this? Straight to jail.
  system.stateVersion = "24.05";
}
