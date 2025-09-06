{...}: {
  cpu = {
    interval = 10;
    format = "󰍛 {usage}%";
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
}
