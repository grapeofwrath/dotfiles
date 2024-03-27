{ options, config, pkgs, lib, ... }:
with lib; with lib.orion;
let
  cfg = config.orion.user;
in {
  options.orion.user = with types; {
    name = mkOpt str "" "The name for the user account";
    description = mkOpt str "" "The user description";
    initialPassword = mkOpt str "password" "The initial password set when the user is created";
    extraGroups = mkOpt (listOf str) [] "Groups assigned to the user";
    extraOptions = mkOpt attrs {} "Extra options passed to <option>users.users.<name></option>";
  };
  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      inherit (cfg) name description initialPassword;
      home = "/home/${cfg.name}";
      group = "users";
      extraGroups = [
        "wheel" "networkmanager"
      ] ++ cfg.extraGroups;
    }
    // cfg.extraOptions;
  };
}
