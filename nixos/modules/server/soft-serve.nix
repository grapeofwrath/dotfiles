{config,lib,...}:
let
  cfg = config.orion.server.soft-serve;
  keyName = "${config.users.users.grape.name}-${config.networking.hostName}";
in {
  options.orion.server.soft-serve = {
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
          public_url = "ssh://git.${config.networking.hostName}";
          max_timeout = 0;
          idle_timeout = 0;
        };
        stats.listen_addr = ":23233";
        initial_admin_keys = [
          "${config.sops.secrets."private_keys".${keyName}.path}"
        ];
      };
    };
  };
}
