{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nextcloud;
in {
  options.nextcloud = {
    enable = lib.mkEnableOption "Enable Nextcloud";
  };
  config = lib.mkIf cfg.enable {
    services = {
      nextcloud = {
        enable = true;
        package = pkgs.nextcloud30;
        hostName = "localhost:3001";

        database.createLocally = true;

        maxUploadSize = "16G";
        https = true;

        extraAppsEnable = true;
        extraApps = with config.services.nextcloud.package.packages.apps; {
          inherit calendar contacts notes;
        };
        config = {
          dbtype = "pgsql";
          adminuser = "admin";
          adminpassFile = config.sops.secrets.nextcloud_admin.path;
        };
      };
    };
  };
}
