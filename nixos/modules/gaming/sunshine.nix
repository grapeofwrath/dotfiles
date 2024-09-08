{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.gaming.sunshine;
  configFile = pkgs.writeTextDir "config/sunshine.conf"
    ''
      origin_web_ui_allowed=wan
    '';
in {
  options.gaming.sunshine = {
    enable = lib.mkEnableOption "Enable Sunshine streaming service";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sunshine
      xorg.xrandr
    ];
    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
    };
    systemd.user.services.sunshine = {
      description = "Sunshine server";
      wantedBy = [ "graphical-session.target" ];
      startLimitIntervalSec = 500;
      startLimitBurst = 5;
      partOf = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${config.security.wrapperDir}/sunshine ${configFile}/config/sunshine.conf";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
    services = {
      avahi.publish.userServices = true;
      udev.extraRules = ''
        KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
      '';
      # sunshine = {
      #   enable = true;
      #   capSysAdmin = true;
      # };
    };
    boot.kernelModules = [ "uinput" ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
