{ pkgs, ... }: {
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
}
