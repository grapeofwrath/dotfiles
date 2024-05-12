{config,pkgs,...}: {
  sops.secrets.grape-password.neededForUsers = true;
  users = {
    #mutableUsers = false;
    users.grape = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.grape-password.path;
      home = "/home/grape";
      group = "users";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = [
        (builtins.readFile ./keys/id_grape-grapepad.pub)
        (builtins.readFile ./keys/id_grape-grapelab.pub)
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  home-manager.users.grape = import ../../../home-manager/homes/grape-${config.networking.hostName}/home.nix;
}
