{inputs,config,lib,...}: with lib;
let cfg = config.orion.sops; in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  options.orion.sops = {
    hostName = mkOption {
      type = types.str;
      default = "nixos";
    };
  };
  config = {
    sops = {
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = ../../secrets.yaml;
      validateSopsFiles = false;
      secrets = {
        "private_keys/${config.home.username}-${cfg.hostName}" = {
          path = "${config.home.homeDirectory}/.ssh/id_${config.home.username}-${cfg.hostName}";
        };
      };
    };
  };
}
