{
  pkgs,
  gLib,
  ...
}: {
  imports = gLib.scanPaths ./.;
  home = {
    file = {
      ".config/phortune/phortunes".source = ./../config/phortunes;
      "Pictures/wallpaper.png".source = ./../config/wallpaper.png;
      "Pictures/profile.png".source = ./../config/profile.png;
      "Pictures/lockscreen.png".source = ./../config/lockscreen.png;
    };
    packages = with pkgs; [
      nautilus
      brave
      discord
      spotify
      filezilla
      foliate
    ];
    pointerCursor = {
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.banana-cursor;
      name = "Banana";
      size = 32;
    };
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Yellow-Dark-Solid";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    # font = {
    #   name = "Sans";
    #   size = 11;
    # };
  };
}
