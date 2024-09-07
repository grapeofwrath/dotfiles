{
  config,
  pkgs,
  lib,
  gVar,
  host,
  ...
}: let
  cfg = config.server.soft-serve;
  keyName = "${gVar.serverUser}-${host}";
in {
  options.server.soft-serve = {
    enable = lib.mkEnableOption "Enable Soft Serve";
  };

  config = lib.mkIf cfg.enable {
    services.soft-serve = {
      enable = true;
      settings = {
        name = "grape's humble repositories";
        log_format = "text";
        ssh = {
          listen_addr = ":22";
          public_url = "ssh://git.${host}";
          max_timeout = 0;
          idle_timeout = 0;
        };
        stats.listen_addr = ":23233";
        initial_admin_keys = [
          "${config.sops.secrets."private_keys".${keyName}.path}"
        ];
      };
    };
    systemd.user.services.soft-serve = {
      description = "Soft Serve git server";
      requires = ["network-online.target"];
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 1;
        ExecStartPre = "mkdir -p ~/soft-serve";
        ExecStart = "${pkgs.soft-serve}/bin/soft serve";
      };
      environment = {
        SOFT_SERVE_DATA_PATH = "nl_NL.UTF-8";
        SOFT_SERVE_INITIAL_ADMIN_KEYS = "${config.sops.secrets."private_keys".${keyName}.path}";
      };
    };
  };
}
