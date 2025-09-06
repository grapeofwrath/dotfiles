{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.waybar;
in {
  imports = [
    ./scripts
    ./style.nix
  ];

  options.waybar = {
    enable = mkEnableOption "Enable Waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        "backlight" = import ./modules/backlight.nix;
        "battery" = import ./modules/battery.nix;
        "bluetooth" = import ./modules/bluetooth.nix;
        "clock" = import ./modules/clock.nix;
        "cpu" = import ./modules/cpu.nix;
        "idle_inhibitor" = import ./modules/idle_inhibitor.nix;
        "memory" = import ./modules/memory.nix;
        "mpris" = import ./modules/mpris.nix;
        "network" = import ./modules/network.nix;
        "temperature" = import ./modules/temperature.nix;
        "wireplumber" = import ./modules/wireplumber.nix;
        "custom/distro" = import ./modules/custom/distro.nix;
        "custom/dividers" = import ./modules/custom/dividers.nix;
        "custom/power_menu" = import ./modules/custom/power_menu.nix;
        "custom/system_update" = import ./modules/custom/system_update.nix;
        "hyprland/window" = import ./modules/hyprland/window.nix;
        "hyprland/windowcount" = import ./modules/hyprland/windowcount.nix;
        "hyprland/workspaces" = import ./modules/hyprland/workspaces.nix;

        modules-left = [
          "custom/left_div#1"
          "hyprland/workspaces"
          "custom/right_div#1"
          "hyprland/window"
        ];
        modules-center = [
          "hyprland/windowcount"
          "custom/left_div#2"
          "temperature"
          "custom/left_div#3"
          "memory"
          "custom/left_div#4"
          "cpu"
          "custom/left_inv#1"
          "custom/left_div#5"
          "custom/distro"
          "custom/right_div#2"
          "custom/right_inv#1"
          "idle_inhibitor"
          "clock#time"
          "custom/right_div#3"
          "clock#date"
          "custom/right_div#4"
          "network"
          "bluetooth"
          "custom/system_update"
          "custom/right_div#5"
        ];
        modules-right = [
          "mpris"
          "custom/left_div#6"
          "group/wireplumber"
          "custom/left_div#7"
          "backlight"
          "custom/left_div#8"
          "battery"
          "custom/left_inv#2"
          "custom/power_menu"
        ];

        layer = "top";
        height = 0;
        width = 0;
        margin = 0;
        spacing = 0;
        mode = "dock";
        reload_style_on_change = true;
      };
      systemd = {
        enable = true;
        enableDebug = true;
        enableInspect = true;
      };
    };
  };
}
