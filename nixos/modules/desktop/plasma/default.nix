{config,lib,...}: with lib;
let cfg = config.orion.nixos.desktop.plasma; in {
  options.orion.nixos.desktop.plasma = {
    enable = mkEnableOption "plasma";
  };
  config = mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    services.xserver = {
      enable = true;
      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
    };
  };
}
