{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.orion.server.minecraft;
in {
  options.orion.server.minecraft = {
    enable = lib.mkEnableOption "Enable minecraft server";
  };
  config = lib.mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      package = pkgs.purpur;
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
# services.minecraft-server = {
#   enable = true;
#   package = pkgs.papermc.overrideAttrs (oldAttrs: rec {
#     version = "1.20.4.448";
#     src =
#       let
#         mcVersion = lib.versions.pad 3 version;
#         buildNum = builtins.elemAt (lib.splitVersion version) 3;
#       in
#       pkgs.fetchurl {
#         url = "https://papermc.io/api/v2/projects/paper/versions/${mcVersion}/builds/${buildNum}/downloads/paper-${mcVersion}-${buildNum}.jar";
#         hash = "sha256-XFbZrB+3TUKAuJLAAokcBhSGv5QJcJvLzX5ploMN8g0=";
#       };
#     });
# };

