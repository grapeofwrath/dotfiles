{config,lib,...}:
let cfg = config.orion.desktop.plasma; in {
  options.orion.desktop.plasma = {
    enable = lib.mkEnableOption "plasma";
  };
  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
    };
  };
}
