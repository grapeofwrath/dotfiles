{...}: {
  memory = {
    interval = 10;
    format = "󰘚 {percentage}%";
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
}
