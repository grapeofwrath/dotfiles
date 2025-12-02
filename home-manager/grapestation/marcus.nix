{...}: {
  imports = [
    ./../modules/base
    ./../modules/desktop
  ];
  home = {
    file.".steam/steam/steam_dev.cfg".source = ./../modules/config/steam_dev.cfg;
  };

  hyprland = {
    enable = true;
    monitors = [",1600x900@60,auto,1"];
  };
  hyprlock.enable = true;
  hyprpaper.enable = true;
  waybar.enable = true;
  tofi.enable = true;
}
