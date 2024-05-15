{inputs,config,pkgs,lib,...}:
let
  cfg = config.orion.sops;
  keyName = "${config.home.username}-${cfg.hostName}";
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  options.orion.sops = {
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
    };
  };
  config = {
    sops = {
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = ../../secrets.yaml;
      validateSopsFiles = false;
      secrets = {
        "private_keys/${keyName}" = {
          path = "${config.home.homeDirectory}/.ssh/id_${keyName}";
        };
      };
    };
    programs = {
      # TODO
      # make separate module for grapelab
      # keychain = {
      #   enable = true;
      #   enableNushellIntegration = true;
      #   keys = [ "id_${keyName}" ];
      # };
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
        After = [ "plasma-kwallet-pam.service" "sops-nix.service" "plasma-kwin_x11.service" "plasma-kwin_wayland.service" "plasma-polkit-agent.service"];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${pkgs.openssh}/bin/ssh-add ${config.home.homeDirectory}/.ssh/id_${keyName}";
      };
    };
  };
}
