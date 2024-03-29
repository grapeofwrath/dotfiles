{options,config,pkgs,lib,...}: with lib; with lib.orion;
let cfg = config.orion.system.boot; in {
  options.orion.system.boot = with types; {
    enable = mkBoolOpt false "Enable systemd-boot";
    #latestKernel = mkBoolOpt false "Use latest kernel";
  };
  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
    boot.loader.systemd-boot.editor = false;
  };
}
