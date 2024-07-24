{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.base.tailscale;
in {
  options.base.tailscale = {
    enable = lib.mkEnableOption "tailscale";
  };
  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";
      after = ["network-pre.target" "tailscale.service"];
      wants = ["network-pre.target" "tailscale.service"];
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "oneshot";
      script = ''
        sleep 2
        status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then
          exit 0
        fi
        ${pkgs.tailscale}/bin/tailscale up --auth-key file:${config.sops.secrets."tailscale".path}
      '';
    };
  };
}
