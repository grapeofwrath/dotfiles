{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.base.appimage;
in {
  options.base.appimage = {
    enable = lib.mkEnableOption "appimage";
  };
  config = lib.mkIf cfg.enable {
    boot.binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
}
