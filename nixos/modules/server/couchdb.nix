# couchdb install for obsidian livesync
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.couchdb;
in {
  options.couchdb = {
    enable = mkEnableOption "Enable CouchDB";
  };

  config = mkIf cfg.enable {
    services.couchdb = {
      enable = true;
      adminPass = "taco";
    };
  };
}
