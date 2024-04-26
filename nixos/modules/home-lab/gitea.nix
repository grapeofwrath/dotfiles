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
        ensurePermissions."DATABASE ${config.services.gitea.database.name}" = "ALL PRIVILEGES";
      }];
    };
    sops.secrets."gitea_dbpass" = {
      #sopsFile = ;
      owner = config.services.gitea.user;
    };
    services.gitea = {
      enable = true;
      appName = "GrapeLab Gitea server";
      database = {
        type = "postgres";
        passwordFile = config.sops.secrets."gitea_dbpass".path;
      };
      domain = "git.grapelab";
      rootUrl = "https://git.grapelab/";
      httpPort = 3001;
    };
  };
}
