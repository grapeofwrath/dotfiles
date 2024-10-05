{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.hyprland;
in lib.mkIf cfg.enable {
  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, Q, killactive,"
          "$modSHIFT, M, exit,"
          "$modSHIFT, L, exec, pgrep hyprlock || hyprlock"
          "$modSHIFT, A, exec, pkill ags && hyprctl dispatch exec hyprpanel"
          "$mod, A, exec, hyprpanel -t dashboardmenu"
          "$mod, E, exec, hyprpanel -t bar-0"

          "$mod, Return, exec, kitty"
          "$mod, W, exec, brave"
          ", Print, exec, grimblast copy area"
          "$mod, D, exec, walker"
          "$mod, F, exec, nautilus"

          "$modSHIFT, S, togglesplit,"
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"
          ", XF86MonBrightnessUp, exec, brightnessctl -q s +10%"
          ", XF86MonBrightnessDown, exec, brightnessctl -q s 10%-"
        ]
        ++ (
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          10)
      );
      bindm = [
        "$mod,mouse:272,movewindow"
        "$mod,mouse:273,resizewindow"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
    };
  };
}
