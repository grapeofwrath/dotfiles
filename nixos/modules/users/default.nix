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
          pkgs.anytype
          pkgs.gum
        ];
      };
    };
  };

  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
    inputs.nixhusky.packages.${system}.default
    inputs.no.packages.${system}.default
    pkgs.gnome-disk-utility
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
