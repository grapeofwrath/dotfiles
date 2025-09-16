{
  config,
  pkgs,
  lib,
  gLib,
  campfire,
  ...
}: let
  cfg = config.hyprland;
  h-RGB = h: lib.strings.removePrefix "#" h;
in {
  imports = gLib.scanPaths ./.;

  options.hyprland = with lib; {
    enable = mkEnableOption "Enable hyprland";

    monitors = mkOption {
      default = [",preferred,auto,auto"];
      type = types.listOf types.str;
      example = ["DP-1,1920x1080@60,auto,1" ",preferred,auto,auto"];
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      swaynotificationcenter
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      extraConfig = builtins.readFile ./../../config/hypr/hyprland.conf;
      settings = let
        c = campfire;
      in {
        exec-once = [
          "systemctl --user start ${lib.getExe pkgs.hyprpolkitagent}"
          "swaync"
        ];

        env = [
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        ];

        general = {
          "col.inactive_border" = "rgb(${h-RGB c.subtle})";
          "col.active_border" = builtins.concatStringsSep " " [
            "rgb(${h-RGB c.ember})"
            "rgb(${h-RGB c.text})"
            "45deg"
          ];
        };

        monitor = cfg.monitors;

        "$mod" = "SUPER";
        bind =
          [
            "$mod, RETURN, exec, ghostty"
            "$mod, W, exec, brave"
            "$mod, A, exec, tofi-drun"
            "$mod, F, exec, nautilus"
            "$modSHIFT, S, exec, ${lib.getExe pkgs.grim}"

            "$mod, Q, killactive"
            "$modSHIFT, M, exit"
            "$mod, S, togglesplit"
            "$modSHIFT, F, togglefloating"
            "$modSHIFT, L, exec, hyprlock"
            "$modSHIFT, R, exec, systemctl reboot"
            "$modSHIFT, P, exec, systemctl poweroff"
            "$mod, H, movefocus, l"
            "$mod, L, movefocus, r"
            "$mod, K, movefocus, u"
            "$mod, J, movefocus, d"
            "$modSHIFT, right, resizeactive, 100 0" # Increase width
            "$modSHIFT, left, resizeactive, -100 0" # Reduce width
            "$modSHIFT, J, resizeactive, 0 100" # Increase height
            "$modSHIFT, K, resizeactive, 0 -100" # Reduce height
          ]
          ++ (
            builtins.concatLists (builtins.genList (i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ])
              10)
          );

        # Laptop multimedia keys for volume and LCD brightness
        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} s 10%+"
          ",XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} s 10%-"
          ", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
          ", XF86AudioPause, exec, ${lib.getExe pkgs.playerctl} play-pause"
          ", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
          ", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, Control_L, movewindow"
          "$mod, mouse:273, resizewindow"
          "$mod, ALT_L, resizewindow"
        ];
      };
    };
  };
}
