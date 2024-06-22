{config,pkgs,lib,...}:
let cfg = config.orion.desktop.plasma; in {
  options.orion.desktop.plasma = {
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
          user = config.users.users.grape.name;
        };
      };
    };
  };
}
