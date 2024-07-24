{
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = ../../../secrets.yaml;
    validateSopsFiles = false;
    age = {
      # auto imports host SSH keys as age keys
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    # secrets are output to /run/secrets
    # ie /run/secrets/gitea_dbpass
    secrets = {
      gitea_dbpass = {};
      wifi-ssid = {
        owner = username;
      };
      wifi-pass = {
        owner = username;
      };
      nextcloud_admin = {
        owner = username;
      };
      tailscale = {
        owner = username;
      };
    };
  };
}
