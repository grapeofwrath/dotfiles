{
  config,
  pkgs,
  lib,
  gVar,
  ...
}: let
  cfg = config.desktop.hyprland;
  theme = gVar.palette;
in {
  options.desktop.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpanel
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      settings = {
        monitor =
          [
            ",preferred,auto,1"
            "eDP-1,1920x1080@60.05,auto,1"
          ];
        general = {
          gaps_in = "6";
          gaps_out = "8";
          border_size = "2";
          "col.active_border" = "rgb(${theme.base08}) rgb(${theme.base0D}) rgb(${theme.base0E}) rgb(${theme.base05}) 45deg";
          "col.inactive_border" = "rgb(${theme.base00}) rgb(${theme.base01}) 45deg";
          layout = "dwindle";
          resize_on_border = true;
        };
        input = {
          kb_layout = "us";
          kb_options = "caps:escape";
          follow_mouse = "1";
          sensitivity = "0";
          accel_profile = "flat";
          touchpad = {
            natural_scroll = true;
          };
        };
        env = [
          "NIXOS_OZONE_WL, 1"
          "NIXPKGS_ALLOW_UNFREE, 1"
          "XDG_CURRENT_DESKTOP, Hyprland"
          "XDG_SESSION_TYPE, wayland"
          "XDG_SESSION_DESKTOP, Hyprland"
          "GDK_BACKEND, wayland"
          "CLUTTER_BACKEND, wayland"
          "SDL_VIDEODRIVER, wayland"
          "XCURSOR_SIZE, 24"
          "XCURSOR_THEME, Bibata-Modern-Ice"
          "QT_QPA_PLATFORM, wayland"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
          "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
          "MOZ_ENABLE_WAYLAND, 1"
        ];
        misc = {
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = false;
          force_default_wallpaper = "0";
          disable_splash_rendering = true;
        };
        animations = {
          enabled = "yes";
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];
          animation = [
            "windows, 1, 6, wind, slide"
            "windowsIn, 1, 6, winIn, slide"
            "windowsOut, 1, 5, winOut, slide"
            "windowsMove, 1, 5, wind, slide"
            "border, 1, 1, liner"
            "borderangle, 1, 90, liner, loop"
            "fade, 1, 10, default"
            "workspaces, 1, 5, wind"
          ];
        };
        decoration = {
          rounding = "10";
          drop_shadow = false;
          blur = {
            enabled = true;
            size = "5";
            passes = "3";
            new_optimizations = "on";
            ignore_opacity = "on";
          };
        };
        exec-once = [
          "$POLKIT_BIN"
          "dbus-update-activation-environment --systemd --all"
          "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "hyprpanel"
          #"hyprctl setcursor Bibata-Modern-Ice 24"
          #"swww init"
          #"wallpaper"
        ];
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        "$mod" = "SUPER";
        bind =
          [
            "$mod, Q, killactive,"
            "$modSHIFT, M, exit,"
            "$mod, Return, exec, kitty"
            "$mod, W, exec, brave"
            "$modSHIFT, A, exec, pkill ags && hyprctl dispatch exec ags"
            ", Print, exec, grimblast copy area"
            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"
            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"
            "$mod, 10, workspace, 10"
            "$mod SHIFT, 1, movetoworkspacesilent, 1"
            "$mod SHIFT, 2, movetoworkspacesilent, 2"
            "$mod SHIFT, 3, movetoworkspacesilent, 3"
            "$mod SHIFT, 4, movetoworkspacesilent, 4"
            "$mod SHIFT, 5, movetoworkspacesilent, 5"
            "$mod SHIFT, 6, movetoworkspacesilent, 6"
            "$mod SHIFT, 7, movetoworkspacesilent, 7"
            "$mod SHIFT, 8, movetoworkspacesilent, 8"
            "$mod SHIFT, 9, movetoworkspacesilent, 9"
            "$mod SHIFT, 10, movetoworkspacesilent, 10"
          ];
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
  };
}
