{config,lib,...}:
let cfg = config.orion.desktop.gnome; in {
  options.orion.desktop.gnome = {
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
          user = config.users.users.grape.name;
        };
      };
    };
    systemd.services = lib.mkIf cfg.auto-login {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };
}
