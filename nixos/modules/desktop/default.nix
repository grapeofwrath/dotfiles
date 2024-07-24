{glib, ...}: {
  imports = glib.scanPaths ./.;

  programs.dconf.enable = true;
  services = {
    xserver = {
      enable = true;
    };
  };
}
