{...}: {
  network = {
    interval = 10;
    format = "󰤨";
    format-ethernet = "󰈀";
    format-wifi = "{icon}";
    format-disconnected = "󰤯";
    format-disabled = "󰤮";
    format-icons = [
      "󰤟"
      "󰤢"
      "󰤥"
      "󰤨"
    ];
    min-length = 2;
    max-length = 2;
    on-click = "ghostty gscript_network";
    on-click-right = "nmcli radio wifi off && notify-send 'Wi-Fi Disabled' -r 1125";
    tooltip-format = "Gateway: {gwaddr}";
    tooltip-format-ethernet = "Interface: {ifname}";
    tooltip-format-wifi = "Network: {essid}\nIP Addr: {ipaddr}/{cidr}\nStrength: {signalStrength}%\nFrequency: {frequency} GHz";
    tooltip-format-disconnected = "Wi-Fi Disconnected";
    tooltip-format-disabled = "Wi-Fi Disabled";
  };
}
