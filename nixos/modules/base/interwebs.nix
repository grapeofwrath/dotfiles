{
  config,
  pkgs,
  lib,
  hostName,
  ...
}: with lib; let
  getFileName = stringAsChars (x:
    if x == " "
    then "-"
    else x);
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
        ${optionalString (opt.psk != null) ''
          key-mgmt=wpa-psk
          psk=${opt.psk}''}
      '';
    };
  };
  keyFiles = mapAttrs' createWifi config.networking.wireless.networks;
in {
  environment.etc = keyFiles;

  systemd.services.NetworkManager-predifined-connections = {
    restartTriggers = mapAttrsToList (name: value: value.source) keyFiles;
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
    inherit hostName;
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
    };
    wireless.networks = {
      "TheReturnOfThePing" = {
        psk = "jaggedbanana250"; #config.sops.secrets."wifi-pass".path
      };
      "Marcus's Work Phone" = {
        psk = "Para2021";
      };
    };
  };
}
