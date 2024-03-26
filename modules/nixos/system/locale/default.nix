{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.orion;
let
  cfg = config.orion.system.locale;
in {
  options.orion.system.locale = with types; {
    enable = mkBoolOpt false "Enable default locale";
  };
  config = mkIf cfg.enable {
    i18n.defaultLocale = "en_US.UTF-8";
  };
}
