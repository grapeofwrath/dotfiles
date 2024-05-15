{config,pkgs,lib,...}:
let
  cfg = config.orion.interwebs;
  getFileName = lib.stringAsChars (x: if x == " " then "-" else x);
  createWifi = ssid: opt: {
    name = "NetworkManager/system-connections/${getFileName ssid}.nmconnection";
    value = {
      mode = "0400";
      source = pkgs.writeText "${ssid}.nmconnection" ''
        [connection]
        id=${ssid}
        type=wifi

        [wifi]
        ssid=${ssid}

        [wifi-security]
        ${lib.optionalString (opt.psk != null) ''
        key-mgmt=wpa-psk
        psk=${opt.psk}''}
      '';
    };
  };
  keyFiles = lib.mapAttrs' createWifi config.networking.wireless.networks;
in {
  options.orion.interwebs = {
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
    };
  };
  config = {
    environment.etc = keyFiles;
    systemd.services.NetworkManager-predifined-connections = {
      restartTriggers = lib.mapAttrsToList (name: value: value.source) keyFiles;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/true";
        ExecReload = "${pkgs.networkmanager}/bin/nmcli connection reload";
      };
      reloadIfChanged = true;
      wantedBy = ["multi-user.target"];
    };
    networking = {
      inherit (cfg) hostName;
      networkmanager = {
        enable = true;
      };
      wireless.networks."TheReturnOfThePing" = {
        psk = "jaggedbanana250"; #config.sops.secrets."wifi-pass".path
      };
    };
  };
}
