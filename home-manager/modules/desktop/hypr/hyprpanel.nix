{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.hyprpanel;
in {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  options.hyprpanel = {
    enable = mkEnableOption "Enable HyprPanel";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpanel
      cava
    ];
    programs.hyprpanel = {
      enable = false;
      systemd.enable = true;
      hyprland.enable = true;
      overwrite.enable = true;
      layout = {
        "bar.layouts" = {
          "0" = {
            left = ["dashboard"];
            middle = ["workspaces"];
            right = ["volume" "systray" "notifications"];
          };
        };
      };
      settings = {
        bar = {
          launcher.autoDetectIcon = true;
          workspaces.show_icons = false;
        };
        menus = {
          clock = {
            time = {
              military = false;
              hideSeconds = true;
            };
            weather.unit = "imperial";
          };
          dashboard = {
            directories.enabled = false;
            stats.enable_gpu = false;
          };
        };
        theme.bar.transparent = false;
      };
    };
  };
}
