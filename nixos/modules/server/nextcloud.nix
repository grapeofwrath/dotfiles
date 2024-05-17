{config,pkgs,lib,...}:
let cfg = config.orion.server.nextcloud; in {
  options.orion.server.nextcloud = {
    enable = lib.mkEnableOption "Enable Nextcloud";
  };
  config = lib.mkIf cfg.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud28;
      hostName = config.networking.hostName;
      config.adminpassFile = config.sops.secrets.nextcloud_admin.path;
    };
  };
}
