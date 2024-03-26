{ options, config, pkgs, lib, ... }:
with lib; with lib.orion;
let
  cfg = config.orion.network;
in {
  options.orion.network = with types; {
    enable = mkBoolOpt false "Enable networking";
    hostName = mkOpt str "nixos" "The name of the machine";
  };
  config = mkIf cfg.enable {
    networking = {inherit hostName;};
    networking.networkmanager.enable = true;
  };
}
