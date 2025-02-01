{
  config,
  lib,
  campfire,
  ...
}:
with lib; let
  cfg = config.hyprlock;
  h-RGB = h: strings.removePrefix "#" h;
in {
  options.hyprlock = {
    enable = mkEnableOption "Enable Hyprlock";
  };

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          ignore_empty_input = true;
          hide_cursor = true;
        };
        background = [
          {
            monitor = "";
            path = "$HOME/Pictures/wallpapers/lockscreen.png";
          }
        ];
        input-field = [
          {
            monitor = "";
            size = "200, 50";
            outline_thickness = 2;
            dots_size = "0.33";
            dots_spacing = "0.15";
            dots_center = true;
            dots_rounding = "-1";
            outer_color = "rgba(${h-RGB campfire.surface}ee)";
            inner_color = "rgb(${h-RGB campfire.base})";
            font_color = "rgb(${h-RGB campfire.subtle})";
            fade_on_empty = true;
            fade_timeout = 1000;
            placeholder_text = ''<i>Input Password...</i>'';
            hide_input = false;
            rounding = "-1";
            check_color = "rgb(204, 136, 34)";
            fail_color = "rgb(${h-RGB campfire.dawn})";
            fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
            fail_transition = 300;
            capslock_color = "-1";
            numlock_color = "-1";
            bothlock_color = "-1";
            invert_numlock = false;
            swap_font_color = false;
            position = "0, -20";
            halign = "center";
            valign = "center";
            shadow_passes = 10;
            shadow_size = 20;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = "1.6";
          }
        ];
        label = [
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$TIME"'';
            color = "rgba(200, 200, 200, 1.0)";
            font_size = 55;
            font_family = "Fira Semibold";
            position = "-100, 70";
            halign = "right";
            valign = "bottom";
            shadow_passes = 5;
            shadow_size = 10;
          }

          {
            monitor = "";
            text = "$USER";
            color = "rgba(200, 200, 200, 1.0)";
            font_size = 20;
            font_family = "Fira Semibold";
            position = "-100, 160";
            halign = "right";
            valign = "bottom";
            shadow_passes = 5;
            shadow_size = 10;
          }
        ];
        image = [
          {
            monitor = "";
            path = "$HOME/Pictures/profile.png";
            size = 280;
            rounding = "-1";
            border_size = 4;
            border_color = "rgb(221, 221, 221)";
            rotate = 0;
            reload_time = "-1";
            position = "0, 200";
            halign = "center";
            valign = "center";
            shadow_passes = 10;
            shadow_size = 20;
            shadow_color = "rgb(0,0,0)";
            shadow_boost = "1.6";
          }
        ];
      };
    };
  };
}
