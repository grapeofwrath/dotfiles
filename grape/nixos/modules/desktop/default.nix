{libgrape,...}: {
  imports = libgrape.allSubdirs ./.;
  config = {
    programs.dconf.enable = true;
  };
}
