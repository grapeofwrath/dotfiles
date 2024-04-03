{config,pkgs,lib,...}: with lib;
let cfg = config.orion.nixos.system; in {
  options.orion.nixos.system = {
    latestKernel = mkOption {
      description = "Enable the latest kernel";
      type = types.bool;
    };
    variables = mkOption {
      description = "Environment variables to apply to the system";
      type = types.attrsOf str;
      default = {
        EDITOR = "nvim";
      };
    };
  };
  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = mkIf cfg.latestKernel pkgs.linuxPackages_latest;
    # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
    boot.loader.systemd-boot.editor = false;

    i18n.defaultLocale = mkDefault "en_US.UTF-8";

    time.timeZone = mkDefault "America/Chicago";

    environment = {inherit variables;};

    console.useXkbConfig = true;
    services.xserver = {
      layout = mkDefault "us";
      xkb.options = "caps:escape";
    };
  };
}
