{
  config,
  lib,
  username,
  ...
}: let
  cfg = config.desktop.plasma;
in {
  options.desktop.plasma = {
    enable = lib.mkEnableOption "plasma";
    auto-login = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        sddm = {
          enable = true;
          autoNumlock = true;
          wayland.enable = true;
        };
        autoLogin = lib.mkIf cfg.auto-login {
          enable = true;
          user = username;
        };
      };
    };
  };
}
