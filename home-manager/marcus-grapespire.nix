{...}: {
  imports = [
    ./modules/base
    ./modules/desktop
  ];

  home.username = "marcus";

  devUtils.enable = true;
  hyprland = {
    enable = true;
    monitors = [",1920x1080@60,auto,1"];
  };
}
