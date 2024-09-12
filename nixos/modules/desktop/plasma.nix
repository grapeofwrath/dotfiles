{
  config,
  lib,
  gVar,
  ...
}: with lib; let
  cfg = config.desktop.plasma;
in {
  options.desktop.plasma = {
    enable = mkEnableOption "plasma";
    auto-login = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        sddm = {
          enable = true;
          autoNumlock = true;
          wayland.enable = true;
        };
        autoLogin = mkIf cfg.auto-login {
          enable = true;
          user = gVar.username;
        };
      };
    };
  };
}
