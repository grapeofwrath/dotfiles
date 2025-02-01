{
  config,
  pkgs,
  lib,
  defaultUser,
  ...
}:
with lib; let
  cfg = config.plasma;
in {
  options.plasma = {
    enable = mkEnableOption "Enable Plasma Desktop Environment";
    autoLogin = mkOption {
      type = types.bool;
      default = false;
      description = "Whether or not to enable auto login with defaultUser";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.discover
    ];
    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        sddm = {
          enable = true;
          autoNumlock = true;
          wayland.enable = true;
        };
        autoLogin = mkIf cfg.autoLogin {
          enable = true;
          user = defaultUser;
        };
      };
    };
  };
}
