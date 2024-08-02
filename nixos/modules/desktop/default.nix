{gLib, ...}: {
  imports = gLib.scanPaths ./.;

  programs.dconf.enable = true;
  services = {
    xserver = {
      enable = true;
    };
  };
}
