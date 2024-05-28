{inputs,...}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  stylix = {
    image = ../../assets/stylix/wallpaper.jpg;
    base16Scheme = ../../assets/stylix/campfire.yaml;
    targets.kitty.variant256Colors = true;
    #targets.kde.enable = false;
  };
}
