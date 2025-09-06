{...}: {
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
}
