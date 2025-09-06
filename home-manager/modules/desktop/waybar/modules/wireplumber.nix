{...}: {
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

  /*
    -------------------
  output device
  -------------------
  */

  "wireplumber#sink" = {
    format = "{icon} {volume}%";
    format-muted = "󰝟 {volume}%";
    format-icons = ["󰕿" "󰖀" "󰕾"];
    min-length = 7;
    max-length = 7;
    on-click = "~/.config/waybar/scripts/wireplumber.sh out";
    on-scroll-up = "~/.config/waybar/scripts/wireplumber.sh out raise";
    on-scroll-down = "~/.config/waybar/scripts/wireplumber.sh out lower";
    tooltip-format = "Device: {node_name}";
  };

  /*
    ----------------
  microphone
  ----------------
  */

  "wireplumber#source" = {
    format = "󰍬 {volume}%";
    format-muted = "󰍭 {volume}%";
    min-length = 7;
    max-length = 7;
    on-click = "~/.config/waybar/scripts/wireplumber.sh mic";
    on-scroll-up = "~/.config/waybar/scripts/wireplumber.sh mic raise";
    on-scroll-down = "~/.config/waybar/scripts/wireplumber.sh mic lower";
    tooltip-format = "Device: {node_name}";
    node-type = "Audio/Source";
  };
}
