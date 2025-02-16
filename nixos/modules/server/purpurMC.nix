{
  config,
  pkgs,
  lib,
  defaultUser,
  ...
}:
with lib; let
  cfg = config.purpurMC;
in {
  options.purpurMC = {
    enable = mkEnableOption "PurpurMC";
    ram = mkOption {
      type = types.str;
      default = "8192";
      description = "Amount of RAM in MB to allocate to the server.";
    };
  };
  config = mkIf cfg.enable {
    systemd.user.services.purpur-murica-craft = {
      description = "Service for the MuricaCraft PurpurMC server";
      after = ["network.target"];
      wants = ["network.target"];
      wantedBy = ["default.target"];
      serviceConfig.Type = "simple";
      script = ''
        sleep 2
        cd /home/${defaultUser}/minecraft-servers/purpur/murica-craft
        ${pkgs.jdk21_headless}/bin/java --add-modules=jdk.incubator.vector -Xmx${cfg.ram}M -Xms${cfg.ram}M -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1HeapRegionSize=8M -XX:G1HeapWastePercent=5 -XX:G1MaxNewSizePercent=40 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1NewSizePercent=30 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15 -XX:MaxGCPauseMillis=200 -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar server.jar nogui
      '';
    };
  };
}
