{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.foundryVTT;
in {
  options.foundryVTT = {
    enable = lib.mkEnableOption "Enable FoundryVTT";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs
      pm2
    ];
    systemd.user.services.foundryvtt = {
      description = "Foundry VTT";
      # requires = ["network.target"];
      # after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
      };
      script = "${pkgs.pm2}/bin/pm2 start --name foundry /home/marcus/srv/foundry/foundryvtt/resources/app/main.js -- --dataPath=/home/marcus/srv/foundry/foundrydata";
    };
  };
}
