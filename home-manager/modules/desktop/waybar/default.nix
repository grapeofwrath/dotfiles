# Currently based off of mechabar by sejjy
#
# https://github.com/sejjy/mechabar/

{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.waybar;
in {
  imports = [
    ./style.nix
  ];

  options.waybar = {
    enable = mkEnableOption "Enable Waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          modules-left = [
            "hyprland/workspaces"
            "custom/right_div#1"
            "hyprland/window"
          ];
          modules-center = [
            "hyprland/windowcount"
            "custom/left_div#2"
            "network#ip"
            "custom/left_div#3"
            "cpu"
            "custom/left_div#4"
            "clock#time"
            "custom/left_inv#1"
            "custom/left_div#5"
            "custom/distro"
            "custom/right_div#2"
            "custom/right_inv#1"
            "clock#date"
            "custom/right_div#3"
            "memory"
            "custom/right_div#4"
            "network"
            "bluetooth"
            "idle_inhibitor"
            "custom/right_div#5"
            "custom/spacer"
          ];
          modules-right = [
            "mpris"
            "custom/left_div#6"
            "group/wireplumber"
            "custom/left_div#7"
            "backlight"
            "custom/left_div#8"
            "battery"
          ];

          layer = "top";
          height = null;
          width = null;
          margin = null;
          spacing = null;
          mode = "dock";
          reload_style_on_change = true;

          "backlight" = {
            format = "{icon} {percent}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
            min-length = 7;
            max-length = 7;
            on-scroll-up = "gscript_backlight up";
            on-scroll-down = "gscript_backlight down";
            tooltip = false;
          };
          "battery" = {
            states = {
              warning = 20;
              critical = 10;
            };
            interval = 10;
            format = "{icon} {capacity}";
            format-time = "{H} hr {M} min";
            format-icons = ["󰂎" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            format-charging = "󰉁 {capacity}%";
            min-length = 7;
            max-length = 7;
            tooltip-format = "Discharging: {time}";
            tooltip-format-charging = "Charging: {time}";
            events = {
              on-discharging-warning = "notify-send 'Low Battery' '{capacity}% remaining'";
              on-discharging-critical = "notify-send 'Low Battery' '{capacity}% remaining' -u critical";
              "on-charging-100" = "notify-send 'Battery full' 'Battery is at {capacity}%'";
            };
          };
          "bluetooth" = {
            format = "󰂯";
            format-disabled = "󰂲";
            format-off = "󰂲";
            format-on = "󰂰";
            format-connected = "󰂱";
            min-length = 2;
            max-length = 2;
            on-click = "ghostty gscript_bluetooth";
            on-click-right = "bluetoothctl power off && notify-send 'Bluetooth Off' -r 1925";
            tooltip-format = "Device Addr: {device_address}";
            tooltip-format-disabled = "Bluetooth Disabled";
            tooltip-format-off = "Bluetooth Off";
            tooltip-format-on = "Bluetooth Disconnected";
            tooltip-format-connected = "Device: {device_alias}";
            tooltip-format-enumerate-connected = "Device: {device_alias}";
            tooltip-format-connected-battery = "Device: {device_alias}\nBattery: {device_battery_percentate}%";
            tooltip-format-enumerate-connected-battery = "Device: {device_alias}\nBattery: {device_battery_percentage}%";
          };
          "clock#time" = {
            format = "{:%H%M}";
            min-length = 7;
            max-length = 7;
            tooltip-format = "Standard Time: {:%I:%M %p}";
          };

          "clock#date" = {
            format = "{:%m-%d}";
            min-length = 7;
            max-length = 7;
            tooltip-format = "{calendar}";
            calendar = {
              mode = "month";
              mode-mon-col = 6;
              format = {
                months = "<span alpha='100%'><b>{}</b></span>";
                days = "<span alpha='90%'>{}</span>";
                weekdays = "<span alpha='80%'><i>{}</i></span>";
                today = "<span alpha='100%'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click = "mode";
            };
          };
          "cpu" = {
            interval = 10;
            format = "C {usage}%";
            format-warning = "󰀨 {usage}%";
            format-critical = "󰀨 {usage}%";
            min-length = 7;
            max-length = 7;
            states = {
              warning = 75;
              critical = 90;
            };
            tooltip = false;
          };
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "󰈈";
              deactivated = "󰈉";
            };
            min-length = 3;
            max-length = 3;
            tooltip-format-activated = "Presentation Mode (<span text_transform='capitalize'>{status}</span>)";
            tooltip-format-deactivated = "Idle Mode (<span text_transform='capitalize'>{status}</span>)";
            start-activated = false;
          };
          "memory" = {
            interval = 10;
            format = "M {percentage}%";
            format-warning = "󰀧 {percentage}%";
            format-critical = "󰀧 {percentage}%";
            states = {
              warning = 75;
              critical = 90;
            };
            min-length = 7;
            max-length = 7;
            tooltip-format = "Memory Used: {used:0.1f} GB / {total:0.1f} GB";
          };
          "mpris" = {
            format = "{player_icon} {title} - {artist}";
            format-paused = "{status_icon} {title} - {artist}";
            tooltip-format = "Playing: {title} - {artist}";
            tooltip-format-paused = "Paused: {title} - {artist}";
            player-icons = {
              default = "󰐊";
            };
            status-icons = {
              paused = "󰏤";
            };
            max-length = 1000;
          };
          "network" = {
            interval = 10;
            format = "󰤨";
            format-ethernet = "󰈀";
            format-wifi = "{icon}";
            format-disconnected = "󰤯";
            format-disabled = "󰤮";
            format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
            min-length = 2;
            max-length = 2;
            on-click = "ghostty -e gscript_network";
            on-click-right = "nmcli radio wifi off && notify-send 'Wi-Fi Disabled' -r 1125";
            tooltip-format = "Gateway: {gwaddr}";
            tooltip-format-ethernet = "Interface: {ifname}";
            tooltip-format-wifi = "Network: {essid}\nIP Addr: {ipaddr}/{cidr}\nStrength: {signalStrength}%\nFrequency: {frequency} GHz";
            tooltip-format-disconnected = "Wi-Fi Disconnected";
            tooltip-format-disabled = "Wi-Fi Disabled";
          };
          "network#ip" = {
            interval = 10;
            format = "{ipaddr}";
            format-disconnected = "offline";
            format-disabled = "offline";
            tooltip = false;
            min-length = 15;
            max-length = 15;
          };
          "group/wireplumber" = {
            orientation = "horizontal";
            modules = [
              "wireplumber#sink"
              "wireplumber#source"
            ];
            drawer = {
              transition-left-to-right = false;
            };
          };

          "wireplumber#sink" = {
            format = "{icon} {volume}%";
            format-muted = "󰝟 {volume}%";
            format-icons = ["󰕿" "󰖀" "󰕾"];
            min-length = 7;
            max-length = 7;
            on-click = "gscript_wireplumber out";
            on-scroll-up = "gscript_wireplumber out raise";
            on-scroll-down = "gscript_wireplumber out lower";
            tooltip-format = "Device: {node_name}";
          };

          "wireplumber#source" = {
            format = "󰍬 {volume}%";
            format-muted = "󰍭 {volume}%";
            min-length = 7;
            max-length = 7;
            on-click = "gscript_wireplumber mic";
            on-scroll-up = "gscript_wireplumber mic raise";
            on-scroll-down = "gscript_wireplumber mic lower";
            tooltip-format = "Device: {node_name}";
            node-type = "Audio/Source";
          };

          "custom/spacer" = {
            format = "   ";
            tooltip = false;
            min-length = 11;
            max-length = 11;
          };
          "custom/distro" = {
            format = "";
            tooltip = false;
          };

          "custom/left_div#1" = {
            format = "";
            tooltip = false;
          };
          "custom/left_div#2" = {
            format = "";
            tooltip = false;
          };
          "custom/left_div#3" = {
            format = "";
            tooltip = false;
          };
          "custom/left_div#4" = {
            format = "";
            tooltip = false;
          };
          "custom/left_div#5" = {
            format = "";
            tooltip = false;
          };
          "custom/left_div#6" = {
            format = "";
            tooltip = false;
          };
          "custom/left_div#7" = {
            format = "";
            tooltip = false;
          };
          "custom/left_div#8" = {
            format = "";
            tooltip = false;
          };
          "custom/left_inv#1" = {
            format = "";
            tooltip = false;
          };
          "custom/left_inv#2" = {
            format = "";
            tooltip = false;
          };

          "custom/right_div#1" = {
            format = "";
            tooltip = false;
          };
          "custom/right_div#2" = {
            format = "";
            tooltip = false;
          };
          "custom/right_div#3" = {
            format = "";
            tooltip = false;
          };
          "custom/right_div#4" = {
            format = "";
            tooltip = false;
          };
          "custom/right_div#5" = {
            format = "";
            tooltip = false;
          };
          "custom/right_inv#1" = {
            format = "";
            tooltip = false;
          };
          "hyprland/window" = {
            format = "{}";
            rewrite = {
              "^$" = "Desktop";
              "^ghostty$" = "Terminal";
              "^~$" = "Terminal";
            };
            tooltip = false;
            swap-icon-label = false;
          };
          "hyprland/windowcount" = {
            format = "[{}]";
            swap-icon-label = false;
          };
          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              active = "";
              default = "";
            };
            persistent-workspaces = {
              "*" = 5;
            };
            cursor = true;
          };
        };
      };
      systemd = {
        enable = true;
        enableDebug = false;
        enableInspect = false;
      };
    };
  };
}
