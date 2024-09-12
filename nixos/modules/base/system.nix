{
  config,
  pkgs,
  lib,
  gVar,
  ...
}: with lib; let
  cfg = config.base.system;
in {
  options.base.system = {
    latestKernel = mkOption {
      description = "Enable the latest kernel";
      type = types.bool;
      default = true;
    };
  };
  config = {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          editor = false;
        };
        efi.canTouchEfiVariables = true;
      };
      kernelPackages = mkIf cfg.latestKernel pkgs.linuxPackages_latest;
      kernelModules = ["v4l2loopback"];
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    };

    i18n.defaultLocale = mkDefault "en_US.UTF-8";

    time.timeZone = mkDefault "America/Chicago";

    environment.variables = {
      EDITOR = "nvim";
    };

    console = let
      theme = builtins.attrValues gVar.palette;
    in {
      colors = map (v: strings.removePrefix "#" v) theme;
      useXkbConfig = true;
    };

    services.xserver = {
      xkb = {
        layout = mkDefault "us";
        options = "caps:escape";
      };
    };
  };
}
