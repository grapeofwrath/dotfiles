{
  inputs,
  config,
  pkgs,
  hostName,
  ...
}: let
  keyName = "${config.home.username}-${hostName}";
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "/home/${config.home.username}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets.yaml;
    validateSopsFiles = false;
    secrets = {
      "private_keys/${keyName}" = {
        path = "/home/${config.home.username}/.ssh/id_${keyName}";
      };
    };
  };

  programs = {
    keychain = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      keys = ["id_${keyName}"];
      extraFlags = ["--quiet"];
    };
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };
  };

  services.ssh-agent.enable = true;

  # TODO
  # find a way for this to work on tty for grapelab
  systemd.user.services.add-ssh-keys = {
    Unit = {
      Description = "Add SSH keys";
      After = ["plasma-kwallet-pam.service" "sops-nix.service" "plasma-kwin_x11.service" "plasma-kwin_wayland.service" "plasma-polkit-agent.service"];
    };
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      ExecStart = "${pkgs.openssh}/bin/ssh-add /home/${config.home.username}/.ssh/id_${keyName}";
    };
  };
}
