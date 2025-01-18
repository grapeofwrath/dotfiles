{
  config,
  lib,
  defaultUser,
  ...
}:
with lib; let
  cfg = config.ttyLogin;
in {
  options.ttyLogin = {
    enable = mkEnableOption "Enable TTY login";
  };
  config = mkIf cfg.enable {
    services = {
      # getty.autologinUser = defaultUser;
      xserver = {
        displayManager.startx.enable = true;
      };
    };
  };
}
