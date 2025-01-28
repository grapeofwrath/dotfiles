{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.tailscaleAutoConnect;
in {
  options.tailscaleAutoConnect = {
    enable = mkEnableOption "tailscaleAutoConnect";

    authkeyFile = mkOption {
      type = types.str;
      description = "The authkey to use for authentication with Tailscale";
    };

    loginServer = mkOption {
      type = types.str;
      default = "";
      description = "The login server to use for authentication with Tailscale";
    };

    advertiseExitNode = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to advertise this node as an exit node";
    };

    exitNode = mkOption {
      type = types.str;
      default = "";
      description = "The exit node to use for this node";
    };

    exitNodeAllowLanAccess = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to allow LAN access to this node";
    };
  };
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.authkeyFile != "";
        message = "authkeyFile must be set";
      }
      {
        assertion = cfg.exitNodeAllowLanAccess -> cfg.exitNode != "";
        message = "exitNodeAllowLanAccess must be false if exitNode is not set";
      }
      {
        assertion = cfg.advertiseExitNode -> cfg.exitNode == "";
        message = "advertiseExitNode must be false if exitNode is set";
      }
    ];

    systemd.services.tailscale-autoconnect = {
      description = "Automatically connect to Tailscale";

      after = ["network-pre.target" "tailscale.service"];
      wants = ["network-pre.target" "tailscale.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        sleep 2

        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"

        echo "tailscale status: $status"
        if [ "$status" != "NeedsLogin" ]; then
            exit 0
                fi

                ${coreutils}/bin/timeout 10 ${tailscale}/bin/tailscale up \
                ${lib.optionalString (cfg.loginServer != "") "--login-server=${cfg.loginServer}"} \
                --authkey=$(cat "${cfg.authkeyFile}")

                ${coreutils}/bin/timeout 10 ${tailscale}/bin/tailscale up \
                ${lib.optionalString (cfg.loginServer != "") "--loginServer=${cfg.loginServer}"} \
                ${lib.optionalString (cfg.advertiseExitNode) "--advertise-exit-node"} \
                ${lib.optionalString (cfg.exitNode != "") "--exit-node=${cfg.exitNode}"} \
                ${lib.optionalString (cfg.exitNodeAllowLanAccess) "--exit-node-allow-lan-access"}
      '';
    };

    networking.firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [config.services.tailscale.port];
    };

    services.tailscale = {
      enable = true;
      useRoutingFeatures =
        if cfg.advertiseExitNode
        then "server"
        else "client";
    };
  };
}
