{
  config,
  pkgs,
  lib,
  gVar,
  ...
}: let
  cfg = config.server.purpur;
in {
  options.server.purpur = {
    enable = lib.mkEnableOption "PurpurMC";
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.purpur-savagecraft = {
      description = "Servers for the SavageCraft PurpurMC server";
      after = ["network.target"];
      wants = ["network.target"];
      wantedBy = ["default.target"];
      serviceConfig.Type = "simple";
      script = ''
        sleep 2
        cd /home/${gVar.defaultUser}/minecraft-servers/purpur/savagecraft
        ${pkgs.jdk21_headless}/bin/java --add-modules=jdk.incubator.vector -Xmx8192M -Xms8192M -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1HeapRegionSize=8M -XX:G1HeapWastePercent=5 -XX:G1MaxNewSizePercent=40 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1NewSizePercent=30 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15 -XX:MaxGCPauseMillis=200 -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar server.jar nogui
      '';
    };
  };
}
