{config,lib,...}: with lib;
let cfg = config.orion.home-lab.gitea; in {
  options.orion.home-lab.gitea = {
    enable = mkEnableOption "gitea";
  };
  config = mkIf cfg.enable {
    services.postgresql = {
      ensureDatabases = [config.services.gitea.user];
      ensureUsers = [{
        name = config.services.gitea.database.user;
        #ensurePermissions."DATABASE gitea" = "ALL PRIVILEGES";
      }];
    };
    sops.secrets."gitea_dbpass" = {
      owner = config.services.gitea.user;
    };
    services.gitea = {
      enable = true;
      appName = "GrapeLab Gitea server";
      database = {
        type = "postgres";
        passwordFile = config.sops.secrets."gitea_dbpass".path;
      };
      settings.server = {
        DOMAIN = "localhost";
        ROOT_URL = "http://localhost/";
        HTTP_PORT = 3001;
      };
    };
  };
}
