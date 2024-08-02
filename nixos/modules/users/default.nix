{
  host,
  username,
  glib,
  ...
}: let
  keyScan = glib.scanFiles ./keys;
in {
  users = {
    users.${username} = {
      name = "${username}";
      isNormalUser = true;
      home = "/home/${username}";
      group = "users";
      extraGroups = ["wheel" "networkmanager" "libvirtd"];
      openssh.authorizedKeys.keys = builtins.map (builtins.readFile) keyScan;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  home-manager.users.${username} = import ../../../home-manager/homes/${username}-${host}.nix;
}
