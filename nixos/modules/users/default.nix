{
  host,
  gVar,
  gLib,
  ...
}: let
  keyScan = gLib.scanFiles ./keys;
in {
  users = {
    users.${gVar.username} = {
      name = "${gVar.username}";
      isNormalUser = true;
      home = "/home/${gVar.username}";
      group = "users";
      extraGroups = ["wheel" "networkmanager" "libvirtd"];
      openssh.authorizedKeys.keys = builtins.map (builtins.readFile) keyScan;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  home-manager.users.${gVar.username} = import ../../../home-manager/homes/${gVar.username}-${host}.nix;
}
