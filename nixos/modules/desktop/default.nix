{config,lib,...}: with lib;
let cfg = config.orion.desktop; in {
  options.orion.desktop = {
    startx = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = {
    programs.dconf.enable = true;
    services.xserver = {
      enable = true;
      displayManager.startx.enable = mkIf cfg.startx true;
    };
  };
}
