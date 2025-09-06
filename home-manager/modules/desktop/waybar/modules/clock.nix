{...}: {
  "clock#time" = {
    format = "{:%H:%M}";
    min-length = 5;
    max-length = 5;
    tooltip-format = "Standard Time: {:%I:%M %p}";
  };

  /*
    --------------
  calendar
  --------------
  */

  "clock#date" = {
    format = "󰸗 {:%m-%d}";
    min-length = 8;
    max-length = 8;
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
}
