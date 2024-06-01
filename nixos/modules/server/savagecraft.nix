{config,pkgs,lib,...}:
let
  cfg = config.orion.server.savagecraft;
  dir = "/home/${config.users.users.grape.name}/minecraft-servers/fabric/savagecraft";
in {
  options.orion.server.savagecraft = {
    enable = lib.mkEnableOption "Enable SavageCraft";
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.SavageCraftMC = {
      description = "SavageCraftMC server";
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        sleep 2
        cd ${dir}
        ${pkgs.tmux}/bin/tmux new-session -s minecraft -d
        sleep 1
        ${pkgs.tmux}/bin/tmux send -t minecraft "java -Xmx10G -Xms10G -jar ./server.jar --nogui" ENTER
      '';
    };
  };
}
