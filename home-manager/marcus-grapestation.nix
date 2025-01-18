{...}: {
  imports = [
    ./modules/base
    ./modules/desktop
  ];
  home = {
    username = "marcus";
    file.".steam/steam/steam_dev.cfg".source = ./modules/config/steam_dev.cfg;
  };
}
