{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  system,
  gLib,
  defaultUser,
  hostName,
  campfire,
  ...
}:
with lib; let
  cfg = config.users;
  keyScan = gLib.scanFiles ./keys;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  options.users = {
    # TODO
    # make submodule
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
          ${defaultUser} = {
            name = "${defaultUser}";
            isNormalUser = true;
            home = "/home/${defaultUser}";
            group = "users";
            openssh.authorizedKeys.keys = map (builtins.readFile) keyScan;
          };
        }
        // builtins.listToAttrs (map (username: {
            name = username;
            value = {
              name = username;
              isNormalUser = true;
              home = "/home/${username}";
              group = "users";
              extraGroups = [
                "wheel"
                "networkmanager"
                "libvirtd"
              ];
              openssh.authorizedKeys.keys = map (builtins.readFile) keyScan;
              # packages = with pkgs; [ ];
            };
          })
          cfg.additionalUsers);
    };

    environment.systemPackages = [
      inputs.home-manager.packages.${pkgs.system}.default
      # gVimConfig.neovim
      outputs.packages.${system}.gVim
      # outputs.packages.${system}.gVim
      # pkgs.wl-clipboard
      # pkgs.ripgrep
    ];
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = {
        inherit inputs outputs system gLib defaultUser hostName campfire;
      };

      users =
        {
          ${defaultUser} = import ./../../../home-manager/${defaultUser}-${hostName}.nix;
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
