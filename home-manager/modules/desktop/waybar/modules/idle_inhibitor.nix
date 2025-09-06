{...}: {
  idle_inhibitor = {
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
}
