{
  config,
  lib,
  username,
  ...
}: let
  cfg = config.desktop.tty-login;
in {
  options.desktop.tty-login = {
    enable = lib.mkEnableOption "tty-login";
  };
  config = lib.mkIf cfg.enable {
    services = {
      # getty.autologinUser = "${username}";
      xserver = {
        displayManager.startx.enable = true;
      };
    };
  };
}
