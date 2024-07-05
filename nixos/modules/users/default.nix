{
  config,
  pkgs,
  ...
}: {
  sops.secrets.grape-password.neededForUsers = true;
  users = {
    #mutableUsers = false;
    users.grape = {
      name = "grape";
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.grape-password.path;
      home = "/home/grape";
      group = "users";
      extraGroups = ["wheel" "networkmanager" "libvirtd"];
      #shell = pkgs.nushell;
      # TODO
      # generate auth keys list based off of keys in keys dir with nix lingo
      openssh.authorizedKeys.keys = [
        (builtins.readFile ./keys/id_grape-grapelab.pub)
        (builtins.readFile ./keys/id_grape-grapestation.pub)
        (builtins.readFile ./keys/id_grape-grapespire.pub)
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  home-manager.users.grape = import ../../../home-manager/homes/grape-${config.networking.hostName}.nix;
}
