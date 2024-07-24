{
  config,
  lib,
  username,
  ...
}: let
  cfg = config.desktop.gnome;
in {
  options.desktop.gnome = {
    enable = lib.mkEnableOption "Enable Gnome";
    auto-login = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable {
    services.xserver = {
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
        autoLogin = lib.mkIf cfg.auto-login {
          enable = true;
          user = username;
        };
      };
    };
    systemd.services = lib.mkIf cfg.auto-login {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };
}
