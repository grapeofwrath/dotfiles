{
  config,
  lib,
  ...
}: with lib;
let
  cfg = config.base.vmware;
in {
  options.base.vmware = {
    enable = mkEnableOption "Enable VMware";
  };

  config = mkIf cfg.enable {
    # services.xserver.videoDrivers = [ "vmware" ];
    virtualisation.vmware.host.enable = true;
  };
}
