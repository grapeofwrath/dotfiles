{inputs,config,osConfig,...}:
let
  sshID = "${config.home.username}-${osConfig.networking.hostName}";
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets.yaml;
    validateSopsFiles = false;
    secrets = {
      "private_keys/${sshID}" = {
        path = "${config.home.homeDirectory}/.ssh/id_${sshID}";
      };
    };
  };
}
