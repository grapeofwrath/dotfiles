{config,pkgs,lib,...}:
let cfg = config.orion.tools; in {
  options.orion.tools = {
    appimage.enable = lib.mkEnableOption "appimage";
  };
  config = {
    boot.binfmt.registrations.appimage = lib.mkIf cfg.appimage.enable {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
}
