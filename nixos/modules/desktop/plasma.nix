{
  config,
  lib,
  gVar,
  ...
}: with lib; let
  cfg = config.desktop.plasma;
in {
  options.desktop.plasma = {
    enable = mkEnableOption "plasma";
    autoLogin = mkOption {
      type = types.bool;
      default = false;
    };
    #TODO
    # make as submodule
    # https://nixos.org/manual/nixos/stable/#section-option-types-submodule
    #
    # user = mkOption {
    #   type = types.str;
    #   default = "marcus";
    # };
  };
  config = mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        sddm = {
          enable = true;
          autoNumlock = true;
          wayland.enable = true;
        };
        autoLogin = mkIf cfg.autoLogin {
          enable = true;
          user = gVar.defaultUser;
        };
      };
    };
  };
}
