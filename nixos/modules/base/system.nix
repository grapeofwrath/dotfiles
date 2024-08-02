{
  config,
  pkgs,
  lib,
  gVar,
  ...
}: let
  cfg = config.base.system;
in {
  options.base.system = {
    latestKernel = lib.mkOption {
      description = "Enable the latest kernel";
      type = lib.types.bool;
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
      kernelPackages = lib.mkIf cfg.latestKernel pkgs.linuxPackages_latest;
      kernelModules = ["v4l2loopback"];
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    };

    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    time.timeZone = lib.mkDefault "America/Chicago";

    environment.variables = {
      EDITOR = "nvim";
    };

    console = let
      theme = builtins.attrValues gVar.palette;
    in {
      colors = builtins.map (v: lib.strings.removePrefix "#" v) theme;
      useXkbConfig = true;
    };

    services.xserver = {
      xkb = {
        layout = lib.mkDefault "us";
        options = "caps:escape";
      };
    };
  };
}
