{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.server.savagecraft;
in {
  options.server.savagecraft = {
    enable = lib.mkEnableOption "Enable SavageCraft";
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.savagecraft = {
      Unit = {
        Description = "SavageCraftMC server";
        After = ["network.target"];
        Wants = ["network.target"];
      };
      Service = {
        Type = "forking";
        ExecStart = "${pkgs.bash} savagecraft start";
        ExecStop = "${pkgs.bash} savagecraft stop";
        WorkingDirectory = "/home/${config.home.username}/minecraft-servers/fabric/savagecraft";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
