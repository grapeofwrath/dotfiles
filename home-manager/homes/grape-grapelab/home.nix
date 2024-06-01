{config,pkgs,...}: {
  imports = [../../modules];
  home = {
    username = "grape";
    homeDirectory = "/home/grape";
  };
  home.packages = [
    pkgs.brave
    pkgs.jdk21_headless
    pkgs.tmux
    # Custom
    pkgs.jot
    # Local
    (import ../../../pkgs/scripts/savagecraft.nix {inherit pkgs;})
  ];
  programs = {
    keychain = {
      enable = true;
      enableNushellIntegration = true;
      keys = [ "id_${config.home.username}-${config.orion.sops.hostName}" ];
    };
    # nushell.extraLogin = ''
    #   purpurmc-server
    # '';
  };
  orion = {
    shell = {
      nushell.enable = true;
    };
    sops.hostName = "grapelab";
    server.savagecraft.enable = false;
  };

  # Believe it or not, if you change this? Straight to jail.
  home.stateVersion = "23.11";
}
