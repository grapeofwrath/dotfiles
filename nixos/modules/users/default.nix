{
  inputs,
  outputs,
  pkgs,
  system,
  gLib,
  defaultUser,
  homes,
  hostName,
  campfire,
  ...
}: let
  keyScan = gLib.scanFiles ./keys;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  users = {
    mutableUsers = true;
    users = {
      ${defaultUser} = {
        name = "${defaultUser}";
        isNormalUser = true;
        home = "/home/${defaultUser}";
        group = "users";
        openssh.authorizedKeys.keys = map (builtins.readFile) keyScan;
      };
    };
  };

  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
    outputs.packages.${system}.gVim
  ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs system gLib hostName campfire;
    };
    # I'm pretty positive this works how I want it to...
    users = builtins.listToAttrs (map (home: {
        name = builtins.head (builtins.split "-" home);
        value = import ./../../../home-manager/${home}.nix;
      })
      homes);
  };

  security.sudo.wheelNeedsPassword = false;
}
