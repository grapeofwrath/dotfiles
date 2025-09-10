{...}: {
  imports = [
    ./../modules/base
    ./../modules/desktop
  ];

  devUtils.enable = true;

  hyprland = {
    enable = true;
    monitors = [",1920x1080@60,auto,1"];
  };
  hyprlock.enable = true;
  waybar.enable = true;
  tofi.enable = true;
}
