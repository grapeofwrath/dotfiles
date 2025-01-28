{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.devUtils;
in {
  options.devUtils = {
    enable = lib.mkEnableOption "Enable dev utilities";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gnumake
      tailwindcss
      # go
      go
      gopls
      gotools
      golangci-lint
      air
      templ
      # zig
      zig
    ];
  };
}
