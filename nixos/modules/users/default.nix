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
        packages = [
          pkgs.obsidian
        ];
      };
    };
  };

  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
    outputs.packages.${system}.gVim
    inputs.no.packages.${system}.default
  ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs outputs system gLib hostName campfire;
    };
    users = builtins.listToAttrs (map (home: {
        name = home.user;
        value = import ./../../../home-manager/${hostName}/${home.user}.nix {
          home.username = home.user;
        };
      })
      homes);
  };

  security.sudo.wheelNeedsPassword = true;
}
