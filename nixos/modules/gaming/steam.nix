{config,pkgs,lib,...}:
let cfg = config.orion.gaming.steam; in {
  options.orion.gaming.steam = {
    enable = lib.mkEnableOption "steam";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      protonup-qt
      mesa
    ];
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true;
      };
      gamescope.enable = true;
    };
    programs.gamemode.enable = true;
  };
}
