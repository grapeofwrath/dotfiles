{config,lib,...}: with lib;
let cfg = config.orion.desktop; in {
  options.orion.desktop = {
    startx = mkEnableOption "startx";
  };
  config = {
    programs.dconf.enable = true;
    services.xserver = {
      enable = true;
      displaymanager.startx.enable = mkIf cfg.startx true;
  };
}
