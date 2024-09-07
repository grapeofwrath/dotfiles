{
  inputs,
  pkgs,
  gVar,
  gLib,
  ...
}: let
  keyScan = gLib.scanFiles ./keys;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
  ];

  users = {
    users = builtins.listToAttrs (builtins.map (u: {
        name = u;
        value = {
          name = u;
          isNormalUser = true;
          home = "/home/${u}";
          group = "users";
          extraGroups = ["wheel" "networkmanager" "libvirtd"];
          openssh.authorizedKeys.keys = builtins.map (builtins.readFile) keyScan;
        };
      })
      gVar.users);
  };

  security.sudo.wheelNeedsPassword = false;
}
