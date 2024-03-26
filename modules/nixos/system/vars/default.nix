{ options, config, pkgs, lib, ... }:
with lib; with lib.orion;
let
  cfg = config.orion.system.vars;
in {
  options.orion.system.vars = with types; {
    enable = mkBoolOpt false "Enable environment variables";
  };
  config = mkIf cfg.enable {
    environment.variables = {
      EDITOR = "nvim";
    };
  };
}
