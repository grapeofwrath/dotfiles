{pkgs,...}: {
  imports = [../../modules];
  home = {
    username = "grape";
    homeDirectory = "/home/grape";
  };
  home.packages = with pkgs; [
  ];
  orion = {
    shell = {
      nushell.enable = true;
    };
  };

  # Believe it or not, if you change this? Straight to jail.
  home.stateVersion = "23.11";
}
