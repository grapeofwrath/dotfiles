{
  config,
  lib,
  ...
}: with lib; let
  cfg = config.desktop.tty-login;
in {
  options.desktop.tty-login = {
    enable = mkEnableOption "tty-login";
  };
  config = mkIf cfg.enable {
    services = {
      # getty.autologinUser = gVar.username;
      xserver = {
        displayManager.startx.enable = true;
      };
    };
  };
}
