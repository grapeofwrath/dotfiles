{config,pkgs,lib,...}:
let cfg = config.orion.system; in {
  options.orion.system = {
    latestKernel = lib.mkOption {
      description = "Enable the latest kernel";
      type = lib.types.bool;
    };
    variables = lib.mkOption {
      description = "Environment variables to apply to the system";
      type = lib.types.attrsOf lib.types.str;
      default = {
        EDITOR = "nvim";
      };
    };
  };
  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = lib.mkIf cfg.latestKernel pkgs.linuxPackages_latest;
    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
    boot.loader.systemd-boot.editor = false;

    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    time.timeZone = lib.mkDefault "America/Chicago";

    environment = {inherit (cfg) variables;};

    console.useXkbConfig = true;
    services.xserver = {
      xkb.layout = lib.mkDefault "us";
      xkb.options = "caps:escape";
    };
  };
}
