{config,lib,...}:
let cfg = config.orion.server.minecraft; in {
  options.orion.server.minecraft = {
    enable = lib.mkEnableOption "Enable minecraft server";
  };
  config = lib.mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      eula = true;
      declarative = true;
      # https://minecraft.gamepedia.com/Server.properties#server.properties
      serverProperties = {
        server-port = 25565;
        gamemode = "survival";
        motd = "Welcome one and all!";
        max-players = 10;
        enable-rcon = true;
        "rcon.password" = "taco420";
        level-seed = "10292992";
      };
    };
  };
}
