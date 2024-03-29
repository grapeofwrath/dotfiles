{options,config,pkgs,lib,...}: with lib; with lib.orion;
let cfg = config.orion.apps.steam; in {
  options.orion.apps.steam = with types; {
    enable = mkBoolOpt false "Enable steam";
  };
  config = mkIf cfg.enable {
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
