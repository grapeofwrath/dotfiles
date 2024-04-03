{config,pkgs,lib,...}: with lib;
let cfg = config.orion.nixos.tools; in {
  options.orion.nixos.tools = {
    appimage.enable = mkEnableOption "appimage";
  };
  config = {
    boot.binfmt.registrations.appimage = mkIf cfg.appimage.enable {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
}
