{options,config,pkgs,lib,...}: with lib; with lib.orion;
let cfg = config.orion.nix; in {
  options.orion.nix = with types; {
    enable = mkBoolOpt true "Enable nix configuration module";
  };
  config = mkIf cfg.enable {
    # nix commands with flakes and such
    nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    nix.nixPath = ["/etc/nix/path"];
    environment.etc =
      lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;
    nix.settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      warn-dirty = false;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  };
}
