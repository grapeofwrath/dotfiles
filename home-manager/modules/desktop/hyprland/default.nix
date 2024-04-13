{inputs,config,pkgs,lib,...}: with lib;
let cfg = config.orion.desktop.hyprland; in {
  options.orion.desktop.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
    monitors = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      #plugins = [
      #  inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
      #];
    };
    wayland.windowManager.hyprland.settings = {
      monitor = [
        ",preferred,auto,1"
      ] ++ (builtins.concatLists cfg.monitors);
      #] ++ (builtins.concatLists {inherit (cfg) monitors;});
        #{inherit (cfg) monitors;}];
      general = {
        gaps_in = "6";
        gaps_out = "8";
        border_size = "2";
        #col = {
        #  active_border = "rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) rgba(${theme.base0B}ff) rgba(${theme.base0E}ff) 45deg";
        #  inactive_border = "rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg";
        #};
        layout = "dwindle";
        resize_on_border = true;
      };
      input = {
        kb_layout = "us";
        follow_mouse = "1";
        sensitivity = "0";
        accel_profile = "flat";
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
        #"$POLKIT_BIN"
        "dbus-update-activation-environment --systemd --all"
        #"systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        #"hyprctl setcursor Bibata-Modern-Ice 24"
        #"swww init"
        #"waybar"
        #"swaync"
        #"wallpaper"
        #"swayidle -w timeout 900 'swaylock -f'"
      ];
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master.new_is_master = true;
      "$mod" = "SUPER";
      bind = [
        "$mod,Return,exec,${pkgs.kitty}"
        ", Print, exec, grimblast copy area"
      ] ++ (builtins.concatLists (builtins.genList (
        x: let
          ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
        ]) 10)
      );
    };
  };
}
