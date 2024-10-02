{
  config,
  pkgs,
  lib,
  ...
}: with lib; let
  cfg = config.base.latestKernel;
in {
  options.base.latestKernel = {
    enable = mkEnableOption "Enable latest kernel";
  };
  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
