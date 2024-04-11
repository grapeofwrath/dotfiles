{inputs,config,lib,...}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  stylix = {
    image = ../../assets/stylix/wallpaper.jpg;
    base16Scheme = ../../assets/stylix/campfire.yaml;
  };
}
