{...}: {
  "custom/system_update" = {
    exec = "gscript_system-update";
    return-type = "json";
    interval = 3600;
    format = "{}";
    min-length = 2;
    max-length = 2;
    on-click = "ghostty gscript_system-update start";
  }
       }
