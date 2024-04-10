{inputs,config,lib,...}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  stylix = {
    image = ./wallpaper.jpg;
    base16Scheme = ./campfire.yaml;
  };
}
