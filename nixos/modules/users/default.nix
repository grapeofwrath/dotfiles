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
  # TODO
  # make submodule
  mkUser = {
    username = mkOption {
      type = types.str;
      default = "";
    };
    packages = mkOption {
      type = types.listOf types.pkgs;
      default = [];
    };
  };
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
      mutableUsers = true;
      users =
        {
          ${gVar.defaultUser} = {
            name = "${gVar.defaultUser}";
            isNormalUser = true;
            home = "/home/${gVar.defaultUser}";
            group = "users";
            extraGroups = ["wheel" "networkmanager" "libvirtd"];
            openssh.authorizedKeys.keys = builtins.map (builtins.readFile) keyScan;
            # hashedPasswordFile = config.sops.secrets."user-passwords"."marcus".path;
            packages = with pkgs; [
              # desktop
              brave
              discord
              spotify
              gnome-keyring
              filezilla
              # charm
              vhs
              charm-freeze
              glow
              # custom
              #jot
            ];
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
              # hashedPasswordFile = config.sops.secrets."user-passwords"."${username}".path;
              # packages = with pkgs; [ ];
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
          ${gVar.defaultUser} = import ./../../../home-manager/${gVar.defaultUser}-${hostName}.nix;
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
