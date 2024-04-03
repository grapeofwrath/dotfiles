{config,pkgs,lib,...}: with lib;
let cfg = config.orion.nixos.apps.steam; in {
  options.orion.nixos.apps.steam = {
    enable = mkEnableOption "steam";
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
