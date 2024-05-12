{config,pkgs,lib,...}:
let cfg = config.orion.apps.steam; in {
  options.orion.apps.steam = {
    enable = lib.mkEnableOption "steam";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      protonup-qt
      mesa
    ];
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;
  };
}
