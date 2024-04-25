{config,lib,...}: with lib;
let cfg = config.orion.desktop.plasma; in {
  options.orion.desktop.plasma = {
    enable = mkEnableOption "plasma";
  };
  config = mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    services.xserver = {
      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
    };
  };
}
