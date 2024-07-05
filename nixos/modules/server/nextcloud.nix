{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.orion.server.nextcloud;
in {
  options.orion.server.nextcloud = {
    enable = lib.mkEnableOption "Enable Nextcloud";
  };
  config = lib.mkIf cfg.enable {
    services = {
      nextcloud = {
        enable = true;
        package = pkgs.nextcloud28;
        hostName = config.networking.hostName;
        database.createLocally = true;
        maxUploadSize = "16G";
        https = true;
        autoUpdateApps.enable = true;
        extraAppsEnable = true;
        # extraApps = with config.services.nextcloud.package.packages.apps; {
        #   inherit calendar contacts notes onlyoffice tasks cookbook qownnotesapi;
        # };
        config = {
          overwriteProtocol = "https";
          defaultPhoneRegion = "us";
          dbtype = "pgsql";
          adminuser = "admin";
          adminpassFile = config.sops.secrets.nextcloud_admin.path;
        };
        phpOptions."opcache.interned_strings_buffer" = "16";
      };
      postgresqlBackup = {
        enable = true;
        startAt = "*-*-* 01:15:00";
      };
    };
  };
}
