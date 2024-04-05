{config,...}: {
  users = {
    # mutableUsers = false;

    users.grape = {
      isNormalUser = true;
      home = "/home/grape";
      group = "users";
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  home-manager.users.grape = import ../../../home-manager/homes/grape/${config.networking.hostName};
}
