{
  config,
  pkgs,
  lib,
  ...
}: with lib; let
  cfg = config.base.appimage;
in {
  options.base.appimage = {
    enable = mkEnableOption "appimage";
  };
  config = mkIf cfg.enable {
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
