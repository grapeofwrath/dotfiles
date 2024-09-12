{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  system,
  gLib,
  gVar,
  hostName,
  ...
}: with lib; let
  cfg = config.users;
  keyScan = gLib.scanFiles ./keys;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  options.users = {
    additionalUsers = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional system users";
    };
  };

  config = {
    users = {
      users =
        {
          marcus = {
            name = "marcus";
            isNormalUser = true;
            home = "/home/marcus";
            group = "users";
            extraGroups = ["wheel" "networkmanager" "libvirtd"];
            openssh.authorizedKeys.keys = builtins.map (builtins.readFile) keyScan;
          };
        }
        // builtins.listToAttrs (map (username: {
            name = username;
            value = {
              name = username;
              isNormalUser = true;
              home = "/home/${username}";
              group = "users";
              extraGroups = ["wheel" "networkmanager" "libvirtd"];
              openssh.authorizedKeys.keys = builtins.map (builtins.readFile) keyScan;
            };
          })
          cfg.additionalUsers);
    };

    environment.systemPackages = [
      inputs.home-manager.packages.${pkgs.system}.default
    ];
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = {
        inherit inputs outputs system gLib gVar hostName;
      };

      users =
        {
          marcus = import ./../../../home-manager/marcus-${hostName}.nix;
        }
        // builtins.listToAttrs (map (username: {
            name = username;
            value = import ./../../../home-manager/${username}-${hostName}.nix;
          })
          cfg.additionalUsers);
    };

    security.sudo.wheelNeedsPassword = false;
  };
}
