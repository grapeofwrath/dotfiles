{
  config,
  pkgs,
  host,
  username,
  ...
}: {
  imports = [../modules];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };

  home.packages = with pkgs; [
    # desktop
    brave
    discord
    spotify
    element-desktop
    gnome-keyring
    kdePackages.qtstyleplugin-kvantum
    obs-studio
    filezilla
    # gaming
    wineWowPackages.staging
  ];

  # Disable when auto-login is off
  programs = {
    keychain = {
      enable = true;
      enableNushellIntegration = true;
      keys = ["id_${username}-${host}"];
    };
  };

  orion = {
    desktop = {
      hyprland = {
        enable = true;
      };
    };
    shell = {
      nushell.enable = true;
    };
  };

  # Believe it or not, if you change this? Straight to jail.
  home.stateVersion = "23.11";
}
