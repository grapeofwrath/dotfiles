{
  config,
  host,
  username,
  ...
}: {
  # sops.secrets.marcus-password.neededForUsers = true;
  users = {
    #mutableUsers = false;
    users.${username} = {
      name = "${username}";
      isNormalUser = true;
      # hashedPasswordFile = config.sops.secrets.marcus-password.path;
      home = "/home/${username}";
      group = "users";
      extraGroups = ["wheel" "networkmanager" "libvirtd"];
      #shell = pkgs.nushell;
      # TODO
      # generate auth keys list based off of keys in keys dir with nix lingo
      openssh.authorizedKeys.keys = [
        (builtins.readFile ./keys/id_${username}-grapelab.pub)
        (builtins.readFile ./keys/id_${username}-grapestation.pub)
        (builtins.readFile ./keys/id_${username}-grapespire.pub)
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  home-manager.users.${username} = import ../../../home-manager/homes/${username}-${host}.nix;
}
