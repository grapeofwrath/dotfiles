{
  config,
  pkgs,
  host,
  username,
  ...
}: {
  imports = [../modules];
  home = {
    username = username;
    homeDirectory = "/home/${username}";
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
      keys = ["id_${username}-${host}"];
    };
    # nushell.extraLogin = ''
    #   purpurmc-server
    # '';
  };
  orion = {
    shell = {
      nushell.enable = true;
    };
    server.savagecraft.enable = false;
  };

  # Believe it or not, if you change this? Straight to jail.
  home.stateVersion = "23.11";
}
