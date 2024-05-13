{config,lib,...}:
let cfg = config.orion.desktop; in {
  options.orion.desktop = {
    startx = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = {
    programs.dconf.enable = true;
    services = {
      xserver = {
        enable = true;
        displayManager.startx.enable = lib.mkIf cfg.startx true;
      };
      displayManager = {
        autoLogin = {
          enable = true;
          user = "grape";
        };
      };
    };
  };
}
