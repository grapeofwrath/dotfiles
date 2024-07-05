{
  config,
  lib,
  ...
}: {
  # let cfg = config.orion.desktop; in {
  #   options.orion.desktop = {
  #   };
  config = {
    programs.dconf.enable = true;
    services = {
      xserver = {
        enable = true;
      };
    };
  };
}
