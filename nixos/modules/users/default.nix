{config,pkgs,...}: {
  users = {
  # mutableUsers = false;
    users.grape = {
      isNormalUser = true;
      home = "/home/grape";
      group = "users";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = [
        (builtins.readFile ./keys/id_grape-grapepad.pub)
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  home-manager.users.grape = import ../../../home-manager/homes/grape-${config.networking.hostName}/home.nix;
}
